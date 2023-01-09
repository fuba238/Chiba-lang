{function sallow( left, right ) {
	return {
		"type": "AssignmentExpression",
		"operator": "=",
		left,
		right
	}
}
  function buildBinaryExpression(head, tail) {
    return tail.reduce(function(result, element) {
      return {
        type: "BinaryExpression",
        operator: element[1],
        left: result,
        right: element[3]
      };
    }, head);
  }
  function buildPipelineExpression(head, tail) {
    return tail.reduce(function(result, element) {
      return {
        type: "PipelineExpression",
        operator: element[1],
        left: result,
        right: element[3]
      };
    }, head);
  }
}
program
	= body: compstmt{
		return{
			"type":  "Program",
			body
		}
	}

compstmt
	= stmt:stmt*

stmt
	= _ expression:expr _{
		return {
			"type": "ExpressionStatement",
            expression
		}
      }

_ "whitespace"
	= [ \t\n\r]*

end = ";"

period = "."
__ = _

expr
	= right:asr _"->"_ left:to end{
		return sallow( left, right );
	}
    / pipe end
    / method

asr
	= pipe
    / method
    
method
	= Object period callmethod Parameters

Object
	= ClassName
    / Literal
    / Block
    
callmethod
	= word
    
Parameters
	= BlockStatement 
    / Parameter*

ClassName
	= [A-Z][a-zA-ZZ0-9_]*
    
Block
	= _ "{" _ RelationExpression _ "}" _
    / _ "{" _ method _ "}" _
    
BlockStatement
	= _ "{" _ compstmt _ "}" _

Parameter
	= _ word  colon  Literal _ comma _
    /  _ word  colon  Literal _ end _
    / _ end _
  
colon = ":"

comma = "."

pipe
  = left:from right: (_ "|>" _ from)* {
    return buildPipelineExpression( left, right);
  }
     
from
  = method 
  / RelationExpression
  / MemberExpression
  / value:NumericLiteral{
    return{
			"type": "Literal",
			"value": value
		}
	}
    / name:iden{
    	return name
    }

to
	= name:iden{
		return name
	}

iden
	= word:$(word) {
		return { "type": "Identifier", name: word}
	}

word
	= word:[a-z][0-9a-zA-Z]*

NumericLiteral
  = float:$(float) {
  	return { "type": "Literal", value: parseFloat(float), class: "Number" }
  }
  / hexint:$(hexint) {
    return { "type": "Literal", value: parseInt(hexint), class: "Number" }
  }
  / int:$(int) {
    return { "type": "Literal", value: parseInt(int), class: "Number" }
  }

float
  = int frac digits

int
  = signe? digit19 digits
  / signe digit
  / digit

hexint
  = signe? "0x" hexdigits

digit19 = [1-9]
digit = [0-9]
digits = digit+
hexdigits = [0-9a-f]+

signe
  = "+"
  / "-"
frac = "."

// Token
FalseToken      = "false"      !IdentifierPart
NullToken       = "null"       !IdentifierPart
ThisToken       = "self"       !IdentifierPart
TrueToken       = "true"       !IdentifierPart

RelationExpression
  = head:Expression tail:(_ RelationalOperator _ Expression)*　{
      　　return buildBinaryExpression( head, tail);
     }

Expression
  = head:Term tail:(_ [+-] _ Term)* {
		return buildBinaryExpression(head, tail)
    }

MemberExpression
  = head:(
        PrimaryExpression
    )
    tail:(
        __ "[" __ property:Expression __ "]" {
          return { property: property, computed: true };
        }
      / __ "." __ property:IdentifierName {
          return { property: property, computed: false };
        }
    )*

PrimaryExpression
  = ThisToken { return { type: "ThisExpression" }; }
  / Identifier
  / Literal
  // ArrayLiteral
  // ObjectLiteral
  / "(" __ expression:Expression __ ")" { return expression; }

Term
  = head:Factor tail:(_ [*/] _ Factor)* {
		return buildBinaryExpression(head, tail)
    }

Factor
  = "(" _ expr:RelationExpression _ ")" { return expr; }
  / NumericLiteral
  / iden
  / StringLiteral


StringLiteral
  = '"' chars:DoubleQuoteCharacter* '"' {
    return { type: "Literal", value: chars.join(""), class: "String" };
  }

DoubleQuoteCharacter
  = !'"' SourceCharacter { return text(); }

SourceCharacter = .

RelationalOperator
  = "<="
  / ">="
  / "<"
  / ">"
  / "="

Identifier
  = !ReservedWord name:IdentifierName { return name; }

IdentifierName "identifier"
  = head:IdentifierStart tail:IdentifierPart* {
      return {
        type: "Identifier",
        name: head + tail.join("")
      };
    }

IdentifierStart
  = iden
  / "$"
  / "_"
  // "\\" sequence:UnicodeEscapeSequence { return sequence; }

IdentifierPart
  = IdentifierStart




ReservedWord
  = NullLiteral
  / BooleanLiteral

Literal
  = NullLiteral
  / BooleanLiteral
  / NumericLiteral
  / StringLiteral
  // RegularExpressionLiteral

NullLiteral
  = NullToken { return { type: "Literal", value: null, class: "Null" }; }

BooleanLiteral
  = TrueToken  { return { type: "Literal", value: true,  class: "True"  }; }
  / FalseToken { return { type: "Literal", value: false, class: "False" }; }
