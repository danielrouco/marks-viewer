import Data.List (nub)
import Modules.TerminalColors 

main :: IO ()
main = do 
    content <- getContents
    putStr $ unlines $ map graph $ groupAndSumReports $ format content

data Report = Report {subject :: String, mark :: Float, total :: Float}

format :: String -> [Report]
format = map ((\(subject:mark:total:_) -> Report subject (read mark) (read total)) . words) . lines 

uniqueSubjects :: [Report] -> [String]
uniqueSubjects = nub . map subject 

sumSubjectMarks :: [Report] -> Report
sumSubjectMarks reports = Report (subject $ head reports) (sum $ map mark reports) (sum $ map total reports)

groupBySubject :: [Report] -> [[Report]]
groupBySubject reports = map (\aSubject -> [report | report <- reports, aSubject == subject report]) (uniqueSubjects reports) 

groupAndSumReports :: [Report] -> [Report]
groupAndSumReports reports = map sumSubjectMarks (groupBySubject reports)

graph :: Report -> String
graph (Report subj mk ttl) =  subj ++ replicate (subjFieldLength - length subj) ' ' ++ "0 [" ++ 
    colorString Bold Green Default (replicate nGreens '|') ++ 
    colorString Bold Red Default (replicate nReds '|') ++ 
    replicate (round graphLength - nReds - nGreens) ' ' ++ 
    "] " ++ show highestMark ++ replicate (markFieldLength - 6) ' ' ++
    colorString Bold Green Default (show mk) ++ replicate (markFieldLength - length (show mk)) ' ' ++
    colorString Bold Red Default (show $ ttl - mk)
    where subjFieldLength = 12
          markFieldLength = 15
          graphLength = 50 
          highestMark = 10  
          nGreens = round ((mk / highestMark) * graphLength)   
          nReds = round ((ttl / highestMark) * graphLength) - nGreens