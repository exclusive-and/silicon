
-- |
-- Module       : Silicon.BitArithmetic
-- Description  : Arithmetic Laws for Bit-Encoded Types
-- 
module Silicon.BitArithmetic where

import Data.Bits qualified as Bits
import Data.Word
import Numeric.Natural


-- * Arithmetic Laws
---------------------------------------------------------------------

-- |
-- Arithmetic laws for bit-encoded types.
-- 
-- These laws are slightly more permissive than 'Bits.Bits' so that we can
-- write an instance for 'Silicon.Signal'.
--
class BitArithmetic a where
    -- |
    -- Ground state: the value corresponding to having all bits pulled low.
    -- 
    ground :: a
    
    default ground :: Bits.Bits a => a
    ground = Bits.zeroBits
    
    -- |
    -- @'clearBit' x i@ forces the @i@-th bit of @x@ to be low.
    -- 
    clearBit :: Int -> a -> a
    
    default clearBit :: Bits.Bits a => Int -> a -> a
    clearBit = flip Bits.clearBit
    
    -- |
    -- @'setBit' x i@ forces the @i@-th bit of @x@ to be high.
    -- 
    setBit :: Int -> a -> a
    
    default setBit :: Bits.Bits a => Int -> a -> a
    setBit = flip Bits.setBit
    
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
    -- @'shift' x i@ shifts @x@ left by @i@ bits if @i@ is positive.
    -- Otherwise, it shifts right by @-i@.
    -- 
    shift :: Int -> a -> a
    
    default shift :: Bits.Bits a => Int -> a -> a
    shift = flip Bits.shift
    
    -- |
    -- @'rotate' x i@ rotates @x@ left by @i@ bits if @i@ is positive.
    -- Otherwise, it rotates right by @-i@.
    -- 
    rotate :: Int -> a -> a
    
    default rotate :: Bits.Bits a => Int -> a -> a
    rotate = flip Bits.rotate


instance BitArithmetic Bool
instance BitArithmetic Int
instance BitArithmetic Integer
instance BitArithmetic Natural
instance BitArithmetic Word
instance BitArithmetic Word8
instance BitArithmetic Word16
instance BitArithmetic Word32
instance BitArithmetic Word64


-- * Shifts and Rotates
---------------------------------------------------------------------

-- |
-- Shift the argument left by @i@ bits.
-- 
shiftLeft :: BitArithmetic a => a -> Int -> a
shiftLeft = flip shift

-- |
-- Shift the argument right by @i@ bits.
--
shiftRight :: BitArithmetic a => a -> Int -> a
shiftRight = flip $ shift . negate

-- |
-- Rotate the argument left by @i@ bits.
--
rotateLeft :: BitArithmetic a => a -> Int -> a
rotateLeft = flip rotate

-- |
-- Rotate the argument right by @i@ bits.
--
rotateRight :: BitArithmetic a => a -> Int -> a
rotateRight = flip $ rotate . negate
