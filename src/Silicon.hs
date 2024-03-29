
-- |
-- Module       : Silicon
-- Description  : Top-level Silicon Re-exporter
-- 
module Silicon
    ( module X
    , (|>), (<|)
    ) where

-- * Re-exported Modules
---------------------------------------------------------------------
    
import Silicon.BitArithmetic as X
import Silicon.Bundle as X
import Silicon.Signal as X


-- * Application Operators
---------------------------------------------------------------------

infixl 0 |>
infixr 0 <|

-- |
-- Apply the second argument as a function to the first.
-- 
-- Equivalent to @'flip' '($)'@.
-- 
(|>) :: a -> (a -> b) -> b
(|>) x f = f x

-- |
-- Apply the first argument as a function to the second.
-- 
-- Equivalent to @'($)'@.
-- 
(<|) :: (a -> b) -> a -> b
(<|) f x = f x
