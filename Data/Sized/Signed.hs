{-# LANGUAGE ScopedTypeVariables #-}

-- | Signed, fixed sized numbers.
-- 
-- Copyright: (c) 2009 University of Kansas
-- License: BSD3
--
-- Maintainer: Andy Gill <andygill@ku.edu>
-- Stability: unstable
-- Portability: ghc

module Data.Sized.Signed 
	( Signed
	, toMatrix
	, fromMatrix
	,           S2,  S3,  S4,  S5,  S6,  S7,  S8,  S9
	, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19
	, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29
	, S30, S31, S32
	) where
	
import Data.Sized.Matrix as M
import Data.Sized.Ix
import Data.List as L
import Data.Bits

newtype Signed ix = Signed Integer 

-- 'toMatrix' turns a sized 'Signed' value into a 'Matrix' of 'Bool's. 
toMatrix :: (Size ix, Enum ix) => Signed ix -> Matrix ix Bool
toMatrix s@(Signed v) = matrix $ take (bitSize s) $ map odd $ iterate (`div` 2) v

-- 'toMatrix' turns a a 'Matrix' of 'Bool's into sized 'Signed' value. 
fromMatrix :: (Size ix, Enum ix) => Matrix ix Bool -> Signed ix
fromMatrix m = mkSigned $
	  sum [ n	
	      | (n,b) <- zip (iterate (* 2) 1)
			      (M.toList m)
	      , b
	      ]
-- 
mkSigned :: (Size ix, Enum ix) => Integer -> Signed ix
mkSigned v = res
   where sz' = 2 ^ (fromIntegral bitCount :: Integer)
	 bitCount = bitSize res - 1
	 res = case divMod v sz' of
	  	(s,v') | even s    -> Signed v' 
		       | otherwise -> Signed (v' - sz') 

instance (Size ix, Enum ix) => Eq (Signed ix) where
	(Signed a) == (Signed b) = a == b
instance (Size ix, Enum ix) => Ord (Signed ix) where
	(Signed a) `compare` (Signed b) = a `compare` b
instance (Size ix, Enum ix) => Show (Signed ix) where
	show (Signed a) = show a
instance (Size ix, Enum ix) => Integral (Signed ix) where
  	toInteger (Signed m) = m
	quotRem (Signed a) (Signed b) = 
		case quotRem a b of
		   (q,r) -> (mkSigned q,mkSigned r)
instance (Size ix, Enum ix) => Num (Signed ix) where
	(Signed a) + (Signed b) = mkSigned $ a + b
	(Signed a) - (Signed b) = mkSigned $ a - b
	(Signed a) * (Signed b) = mkSigned $ a * b
	abs (Signed n) = mkSigned $ abs n
	signum (Signed n) = mkSigned $ signum n
	fromInteger n = mkSigned n
instance (Size ix, Enum ix) => Real (Signed ix) where
	toRational (Signed n) = toRational n
instance (Size ix, Enum ix) => Enum (Signed ix) where
	fromEnum (Signed n) = fromEnum n
	toEnum n = mkSigned (toInteger n)	
instance (Size ix, Enum ix) => Bits (Signed ix) where
	bitSize s = f s undefined
	  where
		f :: (Size a) => Signed a -> a -> Int
		f _ ix = size ix
	complement = fromMatrix . fmap not . toMatrix
	isSigned _ = True
	a `xor` b = fromMatrix (M.zipWith (/=) (toMatrix a) (toMatrix b))
	a .|. b = fromMatrix (M.zipWith (||) (toMatrix a) (toMatrix b))
	a .&. b = fromMatrix (M.zipWith (&&) (toMatrix a) (toMatrix b))
	shiftL (Signed v) i = mkSigned (v * (2 ^ i))
	shiftR (Signed v) i = mkSigned (v `div` (2 ^ i))
 	rotate v i = fromMatrix (forAll $ \ ix -> m ! (toEnum ((fromEnum ix - i) `mod` M.length m)))
		where m = toMatrix v
        testBit u idx = toMatrix u ! (toEnum idx)

instance forall ix . (Size ix, Enum ix) => Bounded (Signed ix) where
	minBound = Signed (- maxMagnitude)
            where maxMagnitude = 2 ^ ((bitSize (undefined :: Signed ix)) -1)
        maxBound = Signed (maxMagnitude - 1)
            where maxMagnitude = 2 ^ ((bitSize (undefined :: Signed ix)) -1)


type S2 = Signed X2
type S3 = Signed X3
type S4 = Signed X4
type S5 = Signed X5
type S6 = Signed X6
type S7 = Signed X7
type S8 = Signed X8
type S9 = Signed X9
type S10 = Signed X10
type S11 = Signed X11
type S12 = Signed X12
type S13 = Signed X13
type S14 = Signed X14
type S15 = Signed X15
type S16 = Signed X16
type S17 = Signed X17
type S18 = Signed X18
type S19 = Signed X19
type S20 = Signed X20
type S21 = Signed X21
type S22 = Signed X22
type S23 = Signed X23
type S24 = Signed X24
type S25 = Signed X25
type S26 = Signed X26
type S27 = Signed X27
type S28 = Signed X28
type S29 = Signed X29
type S30 = Signed X30
type S31 = Signed X31
type S32 = Signed X32
