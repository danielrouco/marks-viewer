import Data.List (nub)
import Modules.TerminalColors 

main :: IO ()
main = do 
    content <- getContents
    putStrLn $ unlines $ map graph $ groupAndSumReports $ format content

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

graphLength :: Int
graphLength = 20

graph :: Report -> String
graph (Report subj mk ttl) =  subj ++ "  [" ++ 
    colorString Bold Green Default (replicate roundedMark '|') ++ 
    colorString Bold Red Default (replicate (roundedMark - roundedTotal) '|') ++ 
    replicate (10 - roundedTotal) ' ' ++ 
    "] 10"
    where roundedMark = round mk  
          roundedTotal = round ttl