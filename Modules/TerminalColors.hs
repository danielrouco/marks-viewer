module Modules.TerminalColors (colorString, Style (..), Color (..)) where 
import qualified Data.Map as Map

data Style = Bold | Normal deriving (Eq, Ord)
data Color = Black | Red | Green | Yellow | Blue | Magenta | Cyan | White | Default deriving (Ord, Eq)

styles :: [(Style, String)]
styles = [(Bold, "1;"),
          (Normal, "0;")]

-- The first Int of the tuple is the foreground code and the second the background one
colors :: [(Color, (Int, Int))]
colors = [(Black, (30, 40)),
          (Red, (31, 41)),
          (Green, (32, 42)),
          (Yellow, (33, 43)),
          (Blue, (34, 44)),
          (Magenta, (35, 45)),
          (Cyan, (36, 46)),
          (White, (37, 47)),
          (Default, (39, 49))]

colorsMap :: Map.Map Color (Int, Int)
colorsMap = Map.fromList colors

lookupColors :: Color -> (Int, Int)
lookupColors color = case Map.lookup color colorsMap of
    Just tuple -> tuple
    Nothing -> lookupColors Default

stylesMap :: Map.Map Style String
stylesMap = Map.fromList styles

lookupStyles :: Style -> String
lookupStyles style = case Map.lookup style stylesMap of
    Just string -> string
    Nothing -> lookupStyles Normal

ansiEscape :: Style -> Color -> Color -> String
ansiEscape style foreground background = 
    "\x1b[" ++
    lookupStyles style ++
    show (fst $ lookupColors foreground) ++ ";" ++
    show (snd $ lookupColors background) ++ "m"

colorString :: Style -> Color -> Color -> String -> String
colorString style foreground background string =
    ansiEscape style foreground background ++
    string ++
    ansiEscape Normal Default Default