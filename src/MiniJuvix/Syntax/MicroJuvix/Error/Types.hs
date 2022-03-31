module MiniJuvix.Syntax.MicroJuvix.Error.Types where

import MiniJuvix.Prelude
import MiniJuvix.Syntax.MicroJuvix.Language

-- | the type of the constructor used in a pattern does
-- not match the type of the inductive being matched
data WrongConstructorType = WrongConstructorType
  { _wrongCtorTypeName :: Name,
    _wrongCtorTypeExpected :: Type,
    _wrongCtorTypeActual :: Type
  }

-- | the arguments of a constructor pattern do not match
-- the expected arguments of the constructor
data WrongConstructorAppArgs = WrongConstructorAppArgs
  { _wrongCtorAppApp :: ConstructorApp,
    _wrongCtorAppTypes :: [Type]
  }

-- | the type of an expression does not match the inferred type
data WrongType = WrongType
  { _wrongTypeExpression :: Expression,
    _wrongTypeExpectedType :: Type,
    _wrongTypeInferredType :: Type
  }

-- | The left hand expression of a function application is not
-- a function type.
data ExpectedFunctionType = ExpectedFunctionType
  { _expectedFunctionTypeExpression :: Expression,
    _expectedFunctionTypeApp :: Expression,
    _expectedFunctionTypeType :: Type
  }

-- | A function definition clause matches too many arguments
data TooManyPatterns = TooManyPatterns
  { _tooManyPatternsClause :: FunctionClause,
    _tooManyPatternsTypes :: [Type]
  }

makeLenses ''WrongConstructorType
makeLenses ''WrongConstructorAppArgs
makeLenses ''WrongType
makeLenses ''ExpectedFunctionType
makeLenses ''TooManyPatterns
