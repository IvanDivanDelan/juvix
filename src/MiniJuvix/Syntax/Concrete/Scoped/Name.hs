{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TemplateHaskell #-}

module MiniJuvix.Syntax.Concrete.Scoped.Name (
module MiniJuvix.Syntax.Concrete.Scoped.Name,
module MiniJuvix.Syntax.Concrete.Scoped.Name.NameKind
                                             ) where

import Data.Stream (Stream (Cons))
import Lens.Micro.Platform
import qualified MiniJuvix.Syntax.Concrete.Fixity as C
import qualified MiniJuvix.Syntax.Concrete.Name as C
import MiniJuvix.Syntax.Concrete.Loc
import MiniJuvix.Prelude
import MiniJuvix.Syntax.Concrete.Scoped.Name.NameKind
import qualified Data.Kind as GHC

--------------------------------------------------------------------------------
-- Names
--------------------------------------------------------------------------------

newtype NameId = NameId Word64
  deriving stock (Show, Eq, Ord, Generic)

data AbsModulePath = AbsModulePath
  { absTopModulePath :: C.TopModulePath,
    absLocalPath :: [C.Symbol]
  }
  deriving stock (Show, Eq, Generic)

topModulePathToAbsPath :: C.TopModulePath -> AbsModulePath
topModulePathToAbsPath p = AbsModulePath p []

instance Hashable AbsModulePath

-- | Tells whether the first argument is an immediate child of the second argument.
-- In other words, tells whether the first argument is a local module of the second.
isChildOf :: AbsModulePath -> AbsModulePath -> Bool
isChildOf child parent
  | null (absLocalPath child) = False
  | otherwise =
    init (absLocalPath child) == absLocalPath parent
      && absTopModulePath child == absTopModulePath parent

-- | Appends a local path to the absolute path
-- e.g. TopMod.Local <.> Inner == TopMod.Local.Inner
(<.>) :: AbsModulePath -> C.Symbol -> AbsModulePath
absP <.> localMod = absP {absLocalPath = absLocalPath absP ++ [localMod]}

allNameIds :: Stream NameId
allNameIds = NameId <$> ids
  where
    ids :: Stream Word64
    ids = aux minBound
    aux i = Cons i (aux (succ i))

instance Hashable NameId

data NameFixity
  = NoFixity
  | SomeFixity C.Fixity
  deriving stock (Show, Eq)

type Name = Name' C.Name

type Symbol = Name' C.Symbol

type TopModulePath = Name' C.TopModulePath

type ModuleNameId = NameId

data Name' n = Name'
  { _nameId :: NameId,
    _nameConcrete :: n,
    _nameDefined :: Interval,
    _nameKind :: NameKind,
    _nameDefinedIn :: AbsModulePath,
    _nameFixity :: NameFixity
  }
  deriving stock (Show)
makeLenses ''Name'

instance HasLoc n => HasLoc (Name' n) where
  getLoc = getLoc . _nameConcrete

hasFixity :: Name' s -> Bool
hasFixity Name' {..} = case _nameFixity of
  SomeFixity {} -> True
  NoFixity -> False

isConstructor :: Name' s -> Bool
isConstructor Name' {..} = case _nameKind of
  KNameConstructor {} -> True
  _ -> False

instance Eq (Name' n) where
  (==) = (==) `on` _nameId

instance Ord (Name' n) where
  compare = compare `on` _nameId

instance Hashable (Name' n) where
  hashWithSalt salt = hashWithSalt salt . _nameId

type family NameKindSymbolType (s :: NameKind) :: GHC.Type where
  NameKindSymbolType 'KNameTopModule = TopModulePath
  NameKindSymbolType 'KNameConstructor = Symbol
  NameKindSymbolType 'KNameInductive = Symbol
  NameKindSymbolType 'KNameFunction = Symbol
  NameKindSymbolType 'KNameLocal = Symbol
  NameKindSymbolType 'KNameAxiom = Symbol
  NameKindSymbolType 'KNameLocalModule = Symbol
