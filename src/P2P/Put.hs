module P2P.Put where

import P2P.Chan
import P2P.JSONUtils
import P2P.KeyValPair
import P2P.SendMessage

put :: KeyValPair -> AddrChan -> StoreChan -> IO ()
put pair addrChan store = do
    pairs <- readEverything store
    if pair `elem` pairs
        then pure ()
        else do
            write store pair
            sendThrough pair addrChan

sendThrough :: KeyValPair -> AddrChan -> IO ()
sendThrough pair addrChan = do
    addresses <- readEverything addrChan
    mapM_ (sendMessage (encode pair)) addresses
