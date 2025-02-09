{-# LANGUAGE DeriveGeneric #-}

module Cardano.Entropy.Types.JmaQuake
  ( JmaQuakeOptions(..)
  ) where

import Data.Fixed
import Data.Time.Clock (UTCTime)
import GHC.Generics    (Generic)

data JmaQuakeOptions = JmaQuakeOptions
  { workspace :: FilePath
  , endDateTime :: UTCTime
  , hours :: Pico
  } deriving (Eq, Generic, Show)
