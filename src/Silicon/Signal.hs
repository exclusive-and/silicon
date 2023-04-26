
---------------------------------------------------------------------
-- |
-- Module       : Silicon.Signal
-- Description  : Infinite Synchronous Signals
-- 
module Silicon.Signal
    ( -- * Signal Data Types
      Signal (..)
    , mapSignal
    , appSignal
    , foldSignal
    
      -- * Signal Sampling
    , sample
    , sampleN
    
      -- * Signal Combinators
    , register
    ) where

import Data.Function (fix)


---------------------------------------------------------------------
-- Signal Data Type

-- |
-- An infinite sequence of values.
-- 
-- Refer to 'foldSignal' and 'sampleN' for techniques for evaluating
-- these infinite signals.
-- 
data Signal a = a :- Signal a

infixr 5 :-


-- |
-- Map a function over every value in a signal.
-- 
mapSignal :: (a -> b) -> Signal a -> Signal b
mapSignal f = go where
    go (a :- as) = f a :- go as

instance Functor Signal where
    fmap = mapSignal

-- |
-- Given a signal of functions and a signal of arguments, apply each
-- function to its corresponding argument.
-- 
appSignal :: Signal (a -> b) -> Signal a -> Signal b
appSignal (f :- fs) (a :- as) = f a :- appSignal fs as

instance Applicative Signal where
    pure x = fix (x :-)
    (<*>)  = appSignal

-- |
-- Fold right over a signal.
-- 
-- Computers don't like folding infinite things! The binary operation
-- /must/ be lazy in its second argument for it to work. The
-- fold never terminates, so it will just ignore the initial value.
-- 
foldSignal :: (a -> b -> b) -> b -> Signal a -> b
foldSignal f _ = go where
    go (a :- s) = a `f` go s

instance Foldable Signal where
    foldr = foldSignal


---------------------------------------------------------------------
-- Signal Sampling
    
-- |
-- Convert a signal to an infinite list using a fold.
-- 
sample :: Signal a -> [a]
sample = foldr (:) []

-- |
-- Convert a signal to a finite list by taking an integer number of
-- samples.
-- 
-- This is the /only/ way to evaluate a signal.
-- 
sampleN :: Int -> Signal a -> [a]
sampleN n = take n . sample


---------------------------------------------------------------------
-- Signal Combinators

-- |
-- Registers delay signals by one timestep.
-- 
register :: a -> Signal a -> Signal a
register resetVal (x :- xs) = resetVal :- x :- xs
