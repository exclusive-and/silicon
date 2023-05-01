
---------------------------------------------------------------------
-- |
-- Module       : Silicon.BitArithmetic
-- Description  : Arithmetic Laws for Bit-Encoded Types
-- 
module Silicon.BitArithmetic
    ( -- * Arithmetic Laws
      BitArithmetic (..)
      
      -- * Shifts and Rotates
    , shiftLeft
    , shiftRight
    , rotateLeft
    , rotateRight
    ) where

import qualified    Data.Bits as Bits


---------------------------------------------------------------------
-- Arithmetic Laws

-- |
-- Arithmetic laws for bit-encoded types.
-- 
-- These laws are slightly more permissive than 'Bits.Bits' so that
-- we can write an instance for 'Silicon.Signal'.
--
class BitArithmetic a where
    -- |
    -- The value corresponding to having all bits pulled low.
    -- 
    ground :: a
    
    default ground :: Bits.Bits a => a
    ground = Bits.zeroBits
    
    -- |
    -- Set the @i@-th bit in the argument low.
    -- 
    clearBit :: a -> Int -> a
    
    default clearBit :: Bits.Bits a => a -> Int -> a
    clearBit = Bits.clearBit
    
    -- |
    -- Set the @i@-th bit in the argument high.
    -- 
    setBit :: a -> Int -> a
    
    default setBit :: Bits.Bits a => a -> Int -> a
    setBit = Bits.setBit
    
    -- | Bitwise OR. 
    (.|.) :: a -> a -> a
    
    default (.|.) :: Bits.Bits a => a -> a -> a
    (.|.) = (Bits..|.)
    
    -- | Bitwise AND.
    (.&.) :: a -> a -> a
    
    default (.&.) :: Bits.Bits a => a -> a -> a
    (.&.) = (Bits..&.)
    
    -- | Bitwise XOR.
    xor :: a -> a -> a
    
    default xor :: Bits.Bits a => a -> a -> a
    xor = Bits.xor
    
    -- | Flip all the bits in the argument.
    complement :: a -> a
    
    default complement :: Bits.Bits a => a -> a
    complement = Bits.complement
    
    -- |
    -- Shift the first argument left by @i@ bits if @i@ is positive.
    -- Otherwise, shift it right by @-i@ bits.
    -- 
    shift :: a -> Int -> a
    
    default shift :: Bits.Bits a => a -> Int -> a
    shift = Bits.shift
    
    -- |
    -- Rotate the first argument left by @i@ bits if @i@ is
    -- positive. Otherwise, rotate right by @-i@ bits.
    -- 
    rotate :: a -> Int -> a
    
    default rotate :: Bits.Bits a => a -> Int -> a
    rotate = Bits.rotate


---------------------------------------------------------------------
-- Shifts and Rotates

-- |
-- Shift the argument left by @i@ bits.
-- 
shiftLeft :: BitArithmetic a => a -> Int -> a
shiftLeft a i = shift a i

-- |
-- Shift the argument right by @i@ bits.
--
shiftRight :: BitArithmetic a => a -> Int -> a
shiftRight a i = shift a $ -i

-- |
-- Rotate the argument left by @i@ bits.
--
rotateLeft :: BitArithmetic a => a -> Int -> a
rotateLeft a i = rotate a i

-- |
-- Rotate the argument right by @i@ bits.
--
rotateRight :: BitArithmetic a => a -> Int -> a
rotateRight a i = rotate a $ -i
