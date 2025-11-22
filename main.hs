import Data.List (nub)
import Modules.TerminalColors

main :: IO ()
main = do
    content <- getContents
    putStr $ unlines $ map graph $ groupAndSumReports $ format content

data Report = Report {subject :: String, mark :: Float, total :: Float, weight :: Float}

format :: String -> [Report]
format = map ((\(subject:mark:total:weight:_) -> Report subject (read mark) (read total) (read weight)) . words) . lines

uniqueSubjects :: [Report] -> [String]
uniqueSubjects = nub . map subject

sumSubjectMarks :: [Report] -> Report
sumSubjectMarks (report:reports) = foldl (\(Report s mk ttl w) (Report _ mk2 ttl2 w2)-> Report s (mk + mk2) (ttl + ttl2) (w + w2)) report reports

groupBySubject :: [Report] -> [[Report]]
groupBySubject reports = [[report | report <- reports, aSubject == subject report] | aSubject <- uniqueSubjects reports]

groupAndSumReports :: [Report] -> [Report]
groupAndSumReports reports = map sumSubjectMarks (groupBySubject reports)

graph :: Report -> String
graph (Report subj mk ttl weight) =  subj ++ replicate (subjFieldLength - length subj) ' ' ++ "0 [" ++
    colorString Bold Green Default (replicate nGreens '|') ++
    colorString Bold Red Default (replicate nReds '|') ++
    replicate (round graphLength - nReds - nGreens) ' ' ++
    "] " ++ show highestMark ++ replicate (markFieldLength - 6) ' ' ++
    colorString Bold Green Default (show ((mk / ttl) * weight * highestMark)) ++ replicate (markFieldLength - length (show mk)) ' ' ++
    colorString Bold Red Default (show $ ((ttl - mk) / ttl) * weight * highestMark)
    where subjFieldLength = 12
          markFieldLength = 15
          graphLength = 50
          highestMark = 10
          nGreens = round (((mk / ttl) * weight) * graphLength)
          nReds = round (weight * graphLength) - nGreens