
---------------------------------------------------------------------
-- |
-- Module       : Silicon.Signal
-- Description  : Infinite Synchronous Signals
-- 
module Silicon.Signal
    ( -- * Signal Data Type
      Signal (..)
    , mapSignal
    , appSignal
    , foldSignal
    
      -- * Signal Sampling
    , sample
    , sampleN
    
      -- * Algebra on Signals
      --
      -- $veryNearlyOrd
    , (.==.), (./=.)
    , (.<=.), (.<.)
    , (.>=.), (.>.)

      -- * Signal Combinators
    , register
    ) where

import              Silicon.BitArithmetic
    
import              Algebra.Lattice
import              Control.Applicative (liftA2)
import              Data.Function (fix)


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
-- Algebra on Signals

instance Lattice a => Lattice (Signal a) where
    (\/) = liftA2 (\/)
    (/\) = liftA2 (/\)

instance Num a => Num (Signal a) where
    (+)         = liftA2 (+)
    (-)         = liftA2 (-)
    (*)         = liftA2 (*)
    negate      = fmap negate
    abs         = fmap abs
    signum      = fmap signum

    -- N.B. that this is sort of a hack, since @'Signal' 'Int'@ is
    -- in theory of uncountable size.
    --
    -- To satisfy 'Num', we just need this injection, and not full
    -- bijection with 'Integer'.
    fromInteger = pure . fromInteger

instance BitArithmetic a => BitArithmetic (Signal a) where
    ground = pure ground
    
    clearBit n = fmap (clearBit n)
    setBit   n = fmap (setBit n)
    
    (.|.) = liftA2 (.|.)
    (.&.) = liftA2 (.|.)
    xor   = liftA2 (.|.)
    
    complement = fmap complement
    
    shift  n = fmap (shift n)
    rotate n = fmap (rotate n)

-- $veryNearlyOrd
--
-- We can very nearly, but not quite, implement 'Eq' and 'Ord'. The
-- closest we can get is with the operators below.

(.==.), (./=.)
    :: (Eq a, Applicative f) => f a -> f a -> f Bool

(.==.) = liftA2 (==)
(./=.) = liftA2 (/=)

(.<=.), (.<.), (.>=.), (.>.)
    :: (Ord a, Applicative f) => f a -> f a -> f Bool

(.<=.) = liftA2 (<=)
(.<.)  = liftA2 (<)
(.>=.) = liftA2 (>=)
(.>.)  = liftA2 (>)


---------------------------------------------------------------------
-- Signal Combinators

-- |
-- Registers delay signals by one timestep.
-- 
register :: a -> Signal a -> Signal a
register resetVal xs = resetVal :- xs

{-# NOINLINE register #-}
