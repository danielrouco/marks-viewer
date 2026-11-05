import Data.List (nub)
import Modules.TerminalColors

main :: IO ()
main = do
  content <- getContents
  let highestMark = parseRational (head (lines content))
   in putStr $ unlines $ map (graph highestMark) (groupAndSumReports (format content))

data Report = Report {subject :: String, mark :: Rational, total :: Rational, weight :: Rational}

parseRational :: String -> Rational
parseRational s = case break (== '.') s of
  (whole, "") -> fromInteger (read whole)
  (whole, _ : frac) -> fromInteger (read (whole ++ frac)) / 10 ^ length frac

showDecimal :: Int -> Rational -> String
showDecimal digits r = sign ++ show whole ++ (if digits > 0 then "." ++ padded else "")
  where
    scaled = round (abs r * 10 ^ digits) :: Integer
    (whole, frac) = scaled `divMod` (10 ^ digits)
    padded = replicate (digits - length (show frac)) '0' ++ show frac
    sign = if r < 0 && scaled /= 0 then "-" else ""

format :: String -> [Report]
format = map ((\(subject : mark : total : weight : _) -> Report subject (parseRational mark) (parseRational total) (parseRational weight)) . words) . tail . lines

uniqueSubjects :: [Report] -> [String]
uniqueSubjects = nub . map subject

groupBySubject :: [Report] -> [[Report]]
groupBySubject reports = [[report | report <- reports, aSubject == subject report] | aSubject <- uniqueSubjects reports]

type Summary = (String, Rational, Rational)

sumSubjectMarks :: [Report] -> Summary
sumSubjectMarks reports =
  ( subject (head reports),
    sum [mark r / total r * weight r | r <- reports],
    sum (map weight reports)
  )

groupAndSumReports :: [Report] -> [Summary]
groupAndSumReports reports = map sumSubjectMarks (groupBySubject reports)

graph :: Rational -> Summary -> String
graph highestMark (subj, earnedFraction, weightSum) =
  subj
    ++ replicate (subjFieldLength - length subj) ' '
    ++ "0 ["
    ++ colorString Bold Green Default (replicate nGreens '|')
    ++ colorString Bold Red Default (replicate nReds '|')
    ++ replicate (round graphLength - nReds - nGreens) ' '
    ++ "] "
    ++ showDecimal 2 highestMark
    ++ replicate (markFieldLength - 6) ' '
    ++ colorString Bold Green Default earned
    ++ replicate (markFieldLength - length earned) ' '
    ++ colorString Bold Red Default lost
  where
    subjFieldLength = 12
    markFieldLength = 15
    graphLength = 50
    earned = showDecimal 2 (earnedFraction * highestMark)
    lost = showDecimal 2 ((weightSum - earnedFraction) * highestMark)
    nGreens = round (earnedFraction * graphLength)
    nReds = round (weightSum * graphLength) - nGreens