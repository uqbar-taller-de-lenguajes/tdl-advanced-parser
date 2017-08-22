{
  const path = require('path')
  const { Bool, If, And, Or, Zero, Succ, Prev, IsZero, Registry, Access, BinaryOp } = require(path.resolve('src/model.js'))

  const reduceOperatorChain = (target, operations) => operations.reduce((left, [,op,,right]) => BinaryOp(left,op,right) , target)
}

_ = __?
__ = [ \t\n\r]+

expression = addition
addition = left:production rest:( _ ('+'/'-') _ production )* { return reduceOperatorChain(left, rest) }
production = left:registryAccess rest:( _ '*' _ registryAccess )* { return reduceOperatorChain(left, rest) }
registryAccess = exp:primaryExpression accessChain:(_ '.' _ id)* { return accessChain.reduce((target,[,,,id]) => Access(target, id) , exp) }

primaryExpression = 'if ' _ condition:expression _ 'then' _ thenExpression:expression _ 'else' _ elseExpression:expression { return If(condition,thenExpression,elseExpression) }
                  / 'isZero' _ value:expression { return IsZero(value) }
                  / value
                  / '(' _ value:expression _ ')' {return value }

value = booleanValue
      / numericValue
      / registry

booleanValue = value:('true' / 'false') { return Bool(value === 'true') }

numericValue = '0' { return Zero }
             / 'succ' _ value:expression { return Succ(value) }
             / 'prev' _ value:expression { return Prev(value) }

registry = '{' _ entries:(id _ ':' _ expression _ ';' _)* '}' {return Registry(entries.map(([key,,,,value]) => ({key, value}) )) }

id = id:[a-zA-Z_]+ { return id.join('') }