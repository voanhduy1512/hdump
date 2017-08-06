import qualified Control.Monad.State as S

type Request = Int
type AppState = (Bool, [Int])

startState = (False, [])

run :: [Int] -> S.State AppState [Request]
run [] = do
  (_, requests) <- S.get
  return requests
run (x:xs) = do
  (on, score) <- S.get
  S.put(on, score ++ [x + 10])
  run xs


main = print $ S.evalState (run [1,2,3]) startState
