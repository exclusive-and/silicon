
---------------------------------------------------------------------
-- |
-- Module       : Silicon.Domain
-- Description  :
--
module Silicon.Domain
    ( -- * Reset Signal
      Reset
    , HiddenReset

      -- * Enable Signal
    , Enable
    , HiddenEnable
    ) where

import Silicon.Signal

import GHC.Classes


---------------------------------------------------------------------
-- Reset Signal

-- |
--
--
newtype Reset = Reset (Signal Bool)

type HiddenReset = IP "reset" Reset


---------------------------------------------------------------------
-- Enable Signal

-- |
--
--
newtype Enable = Enable (Signal Bool)

type HiddenEnable = IP "enable" Enable
