module P2P.Chan
    ( module P2P.Chan
    , module Control.Concurrent.STM.TChan
    ) where

import Import

import Control.Concurrent.STM.TChan
import Control.Monad.STM

import P2P.KeyValPair
import P2P.SockAddr

type AddrChan = TChan SockAddr

type StoreChan = TChan KeyValPair

cleanChannel :: TChan a -> IO ()
cleanChannel chan = void $ readTheRest chan []

readEverything :: TChan a -> IO [a]
readEverything chan = do
    contents <- readTheRest chan []
    mapM_ (write chan) contents
    pure contents

isEmpty :: TChan a -> IO Bool
isEmpty = atomically . isEmptyTChan

readTheRest :: TChan a -> [a] -> IO [a]
readTheRest chan xs = do
    empty <- isEmpty chan
    if empty
        then pure xs
        else do
            x <- atomically $ readTChan chan
            readTheRest chan (x : xs)

write :: TChan a -> a -> IO ()
write chan x = atomically $ writeTChan chan x
