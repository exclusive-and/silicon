
module Silicon.Bundle where

import Silicon.Signal


-- * Bundles of Signals
---------------------------------------------------------------------

-- |
-- Conversion between signal-of-product types and product-of-signals types.
-- 
class Bundle a where
    type Unbundled a = res | res -> a
    type Unbundled a = Signal a
    
    -- |
    -- If the input is a product of signals, anti-distribute the signal
    -- functor to get a signal of products.
    -- 
    bundle :: Unbundled a -> Signal a
    
    default bundle :: (Unbundled a ~ Signal a) => Unbundled a -> Signal a
    bundle s = s
    
    -- |
    -- If the input is a signal of products, distribute the signal functor
    -- to get a product of signals.
    -- 
    unbundle :: Signal a -> Unbundled a
    
    default unbundle :: (Unbundled a ~ Signal a) => Signal a -> Unbundled a
    unbundle s = s


-- Default Instances
---------------------------------------------------------------------

instance Bundle ()

instance Bundle (a, b) where
    type Unbundled (a, b) = (Signal a, Signal b)
    
    bundle (a, b) = (,) <$> a <*> b
    
    unbundle s = (fst <$> s, snd <$> s)

instance Bundle (a, b, c) where
    type Unbundled (a, b, c) = (Signal a, Signal b, Signal c)
    
    bundle (a, b, c) = (,,) <$> a <*> b <*> c
    
    unbundle s = (a, b, c)
        where
        a = do { ~(x, _, _) <- s ; pure x }
        b = do { ~(_, x, _) <- s ; pure x }
        c = do { ~(_, _, x) <- s ; pure x }

instance Bundle (a, b, c, d) where
    type Unbundled (a, b, c, d) = (Signal a, Signal b, Signal c, Signal d)
    
    bundle (a, b, c, d) = (,,,) <$> a <*> b <*> c <*> d
    
    unbundle s = (a, b, c, d)
        where
        a = do { ~(x, _, _, _) <- s ; pure x }
        b = do { ~(_, x, _, _) <- s ; pure x }
        c = do { ~(_, _, x, _) <- s ; pure x }
        d = do { ~(_, _, _, x) <- s ; pure x }
