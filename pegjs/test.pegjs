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

Program "プログラム"
	= Body: ProgramRules {
    	return {
        	"type": "Program",
            Body
        }
    }
ProgramRules "プログラムルールの集まり"
	= (ProgramRule)*
    
ProgramRule "プログラムルール"
	= _ BreakStatement end _ {
    	return {
    		"type": "BreakStatement"
        }
    }
    / _ ReturnStatement end _ {
    	return {
        	"type": "ReturnStatement"
        }
    }
    / _ ExpressionStatement:Expr end _ {
    	return {
        	"type": "ExpressionStatement",
            ExpressionStatement
        }
    }
    
Expr "代入式"
	= right:Pipe _ AssignmentToken _ left:AssignmentFactor {
    	return sallow( left, right );
    }

AssignmentFactor "代入先"
	= ArrayElement
    / Iden

Pipe "パイプライン式"
	= Iden

Iden "識別子"
	= IdenToken: $(IdenToken) {
    	return { "type": "Identifier", "name": IdenToken }
    }

ArrayElement
	= Identifier: Iden "[" ArrayIndex: ArrayIndex "]" {
    	return {
        	Identifier,
            ArrayIndex
        }
    }
    
ArrayIndex
    = IntegerLiteral
    / ArrayElement
    / Iden

BreakStatement "break文"
	= BreakToken
    
ReturnStatement "return文"
	= ReturnToken
    
AssignmentToken "代入演算子"
	= "->"
    
PipelineToken "パイプライン演算子"
	= "|>"
    
BreakToken "breakトークン"
	= "break"   
    
ReturnToken "returnトークン"
	= "return"
    
IdenToken "識別子トークン"
	= [a-z][0-9a-zA-Z]*
    
ClassToken "クラストークン"
	= [A-Z][0-9a-zA-Z]*


NumericLiteral
	= FloatLiteral
	/ IntegerLiteral
  
IntegerLiteral
	= int:$(Integer) {
       		return { "type": "Literal", value: parseInt(int), class: "Number" }
       }

FloatLiteral
	= float:$(Float) {
        	return { "type": "Literal", value: parseFloat(float), class: "Number" }
       }


Integer "整数"
	= Signe? Digit19 Digits
    / Signe Digit09
    / Digit09

Float "浮動小数点数"
	= Integer Period Digits

Digit19
	= [1-9]
    
Digit09
	= [0-9]
    
Digits = Digit09+

Signe "符号"
	= "+"
    / "-"
    
Period "ピリオド"
	= "."

end "文の終端"
	= ";"
    
_ "空白"
	= [ \t\n\r]*
