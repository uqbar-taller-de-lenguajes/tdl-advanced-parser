{
  const path = require('path')
  const { Bool, If, And, Or, Zero, Succ, Prev, IsZero } = require(path.resolve('src/model.js'))
}

_ = __?
__ = [ \t\n\r]+

expression = 'if ' _ condition:expression _ 'then' _ thenExpression:expression _ 'else' _ elseExpression:expression { return If(condition,thenExpression,elseExpression) }
           / 'isZero' _ value:expression { return IsZero(value) }
           / value

value = booleanValue
      / numericValue

booleanValue = value:('true' / 'false') { return Bool(value === 'true') }

numericValue = '0' { return Zero }
             / 'succ' _ value:expression { return Succ(value) }
             / 'prev' _ value:expression { return Prev(value) }