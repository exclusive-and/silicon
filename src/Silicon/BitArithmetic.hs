
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
import              Data.Word
import              Numeric.Natural


---------------------------------------------------------------------
-- Arithmetic Laws

-- |
-- Arithmetic laws for bit-encoded types.
-- 
-- These laws are slightly more permissive than 'Bits.Bits' so that
-- we can write an instance for 'Silicon.Signal'.
--
class BitArithmetic a where
    -----------------------------------------------------------------
    -- Ground State Law
    
    -- |
    -- The value corresponding to having all bits pulled low.
    -- 
    ground :: a
    
    default ground :: Bits.Bits a => a
    ground = Bits.zeroBits
    
    
    -----------------------------------------------------------------
    -- Single Bit Set and Reset Laws
    
    -- |
    -- @'clearBit' x i@ forces the @i@-th bit of @x@ to be low.
    -- 
    clearBit :: a -> Int -> a
    
    default clearBit :: Bits.Bits a => a -> Int -> a
    clearBit = Bits.clearBit
    
    -- |
    -- @'setBit' x i@ forces the @i@-th bit of @x@ to be high.
    -- 
    setBit :: a -> Int -> a
    
    default setBit :: Bits.Bits a => a -> Int -> a
    setBit = Bits.setBit
    
    
    -----------------------------------------------------------------
    -- Bitwise Logic Operations
    
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
    
    
    -----------------------------------------------------------------
    -- Shifting and Rotation
    
    -- |
    -- @'shift' x i@ shifts @x@ left by @i@ bits if @i@ is positive.
    -- Otherwise, it shifts right by @-i@.
    -- 
    shift :: a -> Int -> a
    
    default shift :: Bits.Bits a => a -> Int -> a
    shift = Bits.shift
    
    -- |
    -- @'rotate' x i@ rotates @x@ left by @i@ bits if @i@ is
    -- positive. Otherwise, it rotates right by @-i@.
    -- 
    rotate :: a -> Int -> a
    
    default rotate :: Bits.Bits a => a -> Int -> a
    rotate = Bits.rotate


instance BitArithmetic Bool
instance BitArithmetic Int
instance BitArithmetic Integer
instance BitArithmetic Natural
instance BitArithmetic Word
instance BitArithmetic Word8
instance BitArithmetic Word16
instance BitArithmetic Word32
instance BitArithmetic Word64


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
