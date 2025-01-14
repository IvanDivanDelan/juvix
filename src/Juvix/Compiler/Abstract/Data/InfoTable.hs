module Juvix.Compiler.Abstract.Data.InfoTable where

import Juvix.Compiler.Abstract.Language
import Juvix.Compiler.Concrete.Data.ScopedName qualified as S
import Juvix.Prelude

newtype FunctionInfo = FunctionInfo
  { _functionInfoDef :: FunctionDef
  }
  deriving stock (Show)

data ConstructorInfo = ConstructorInfo
  { _constructorInfoInductive :: InductiveInfo,
    _constructorInfoType :: Expression
  }

newtype AxiomInfo = AxiomInfo
  { _axiomInfoType :: Expression
  }

newtype InductiveInfo = InductiveInfo
  { _inductiveInfoDef :: InductiveDef
  }

data InfoTable = InfoTable
  { _infoConstructors :: HashMap ConstructorRef ConstructorInfo,
    _infoAxioms :: HashMap AxiomRef AxiomInfo,
    _infoInductives :: HashMap InductiveRef InductiveInfo,
    _infoFunctions :: HashMap FunctionRef FunctionInfo,
    _infoCompilationRules :: HashMap S.Symbol [BackendItem]
  }

emptyInfoTable :: InfoTable
emptyInfoTable =
  InfoTable
    { _infoConstructors = mempty,
      _infoAxioms = mempty,
      _infoInductives = mempty,
      _infoFunctions = mempty,
      _infoCompilationRules = mempty
    }

makeLenses ''InfoTable
makeLenses ''InductiveInfo
makeLenses ''ConstructorInfo
makeLenses ''AxiomInfo
makeLenses ''FunctionInfo
