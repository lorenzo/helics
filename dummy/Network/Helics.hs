{-# LANGUAGE CPP #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Network.Helics
    ( HelicsConfig(..)
    , withHelics
    , sampler
    -- * metric
    , recordMetric
    , recordCpuUsage
    , recordMemoryUsage
    -- * transaction
    , TransactionType(..)
    , TransactionId
    , withTransaction
    , addAttribute
    , setRequestUrl
    , setMaxTraceSegments
    -- * segment
    , SegmentId
    , autoScope
    , rootSegment
    , genericSegment
    , Operation(..)
    , DatastoreSegment(..)
    , datastoreSegment
    , externalSegment
    -- * status code
    , StatusCode
    , statusShutdown
    , statusStarting
    , statusStopping
    , statusStarted
    -- * reexports
    , def
    ) where

import System.IO.Error

import Control.Exception
import Control.Monad
import Control.Concurrent

import Foreign.C
import Foreign.Ptr
import Foreign.Marshal
import Foreign.Storable

import Data.Word
import Data.Default.Class
import qualified Data.ByteString as S

import qualified Network.Helics.Sampler as Sampler
import Network.Helics.Types

autoScope, rootSegment :: SegmentId
autoScope   = SegmentId 0
rootSegment = SegmentId 1

statusShutdown, statusStarting, statusStopping, statusStarted :: StatusCode
statusShutdown = StatusCode 0
statusStarting = StatusCode 1
statusStopping = StatusCode 2
statusStarted  = StatusCode 3

-- | start new relic®  collector client.
-- you must call this function when embed-mode.
withHelics :: HelicsConfig -> IO a -> IO a
withHelics _ m = m

-- | record custom metric.
recordMetric :: S.ByteString -> Double -> IO ()
recordMetric _ _ = return ()

-- | sample and send metric of cpu/memory usage.
sampler :: Int -- ^ sampling frequency (sec)
        -> IO ()
sampler _ = return ()

-- | record CPU usage. Normally, you don't need to call this function. use sampler.
recordCpuUsage :: Double -> Double -> IO ()
recordCpuUsage _ _ = return ()

-- | record memory usage. Normally, you don't need to call this function. use sampler.
recordMemoryUsage :: Double -> IO ()
recordMemoryUsage _ = return ()

withTransaction :: S.ByteString -- ^ name of transaction
                -> TransactionType -> (TransactionId -> IO c) -> IO c
withTransaction _ _ m = m (TransactionId 0)

genericSegment :: SegmentId     -- ^ parent segment id
               -> S.ByteString  -- ^ name of represent segment
               -> IO c          -- ^ action in segment
               -> TransactionId
               -> IO c
genericSegment _ _ m _ = m

datastoreSegment :: SegmentId -> DatastoreSegment -> IO a -> TransactionId -> IO a
datastoreSegment _ _ m _ = m

externalSegment :: SegmentId
                -> S.ByteString -- ^ host of segment
                -> S.ByteString -- ^ name of segment
                -> IO a -> TransactionId -> IO a
externalSegment _ _ _ m _ = m

addAttribute :: S.ByteString -> S.ByteString -> TransactionId -> IO ()
addAttribute _ _ _ = return ()

setRequestUrl :: S.ByteString -> TransactionId -> IO ()
setRequestUrl _ _ = return ()

setMaxTraceSegments :: Int -> TransactionId -> IO ()
setMaxTraceSegments _ _ = return ()