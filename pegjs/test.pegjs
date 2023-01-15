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
	= ProgramRule*

ProgramRule "プログラムルール"
	= _ Statements:Stmt end _ { return Statements }

Stmt "文の種類"
	= _ BreakStatement _ {
    	return {
    		"type": "BreakStatement"
        }
    }
    / _ ReturnStatement _ {
    	return {
        	"type": "ReturnStatement"
        }
    }
    / _ ExpressionStatement:Expr _ {
    	return {
        	"type": "ExpressionStatement",
            ExpressionStatement
        }
    }
    
Expr "代入式"
	= right:Pipe _ AssignmentToken _ left:AssignmentFactor {
    	return sallow(left, right);
    }
    / Pipe

AssignmentFactor "代入先"
	= ArrayElement
    / Iden

Pipe "パイプライン式"
	= left:PipeFrom right:(_ "|>" _ PipeFrom)* {
    	return buildPipelineExpression(left,right);
    }

PipeFrom "パイプライン送信元"
	= LogicalExpression 
    / Factor:$(PipelineParameter) {
    	return {
        	"type":"Parameter",
            Factor
        }
    }
    
LogicalExpression "論理式"
	= left:RelationExpression right:(_ LogicalToken _ RelationExpression)* {
    	return buildBinaryExpression(left, right);
    }
    
RelationExpression "関係式"
	= left:Expression1 right:(_ RelationToken _ Expression1)* {
    	return buildBinaryExpression(left, right);
    }
    
Expression1 "加減式"
	= left:Expression2 right:(_ [+-] _ Expression2 )* {
    	return buildBinaryExpression(left,right);
    }
    
Expression2 "乗除式"
	= left:Factor right:(_ [*/] _ Factor )* {
    	return buildBinaryExpression(left,right);
    }

Factor "要素"
	= "(" _ expr:RelationExpression _ ")" { return expr; }
    / NumericLiteral
    / Iden
    
PipelineParameter "パイプライン引数"
	= "{" _ Parameters _ "}"
    / Parameter
    
Parameter "単数引数"
	= Keyword
	/ Iden
    / NumericLiteral

Keyword "キーワード引数"
	= Key Colon Para
    
Key "キーワード"
	= Iden
    
Para "引数"
	= Iden
    / NumericLiteral

Parameters "複数引数"
	= Parameter (_ Comma _ Parameter)* 
    
Iden "識別子"
	= IdenToken: $(IdenToken) {
    	return { "type": "Identifier", "name": IdenToken }
    }

ArrayElement "配列要素"
	= Identifier: Iden "[" ArrayIndex: ArrayIndex "]" {
    	return {
        	Identifier,
            ArrayIndex
        }
    }
    
ArrayIndex "配列中身"
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
    
LogicalToken "論理演算子"
	= "and"
    / "or"

RelationToken "比較演算子とチルダ演算子"
	= "="
    / "<"
    / ">"
    / "<="
    / ">="
    / "~"

BreakToken "breakトークン"
	= "break"   
    
ReturnToken "returnトークン"
	= "return"
    
IdenToken "識別子トークン"
	= [a-z][0-9a-zA-Z]*
    
ClassToken "クラストークン"
	= [A-Z][0-9a-zA-Z]*


NumericLiteral "数値リテラル"
	= FloatLiteral
	/ IntegerLiteral
    / StringLiteral
  
IntegerLiteral "整数リテラル"
	= int:$(Integer) {
       		return { "type": "Literal", value: parseInt(int), class: "Number" }
       }

FloatLiteral "浮動小数点数リテラル"
	= float:$(Float) {
        	return { "type": "Literal", value: parseFloat(float), class: "Number" }
       }

StringLiteral "文字列リテラル"
  = '"' chars:DoubleQuoteCharacter* '"' {
    return { type: "Literal", value: chars.join(""), class: "String" };
  }

DoubleQuoteCharacter
  = !'"' SourceCharacter { return text(); }
  
SourceCharacter = .

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
    
Colon "コロン"
	= ":"
Period "ピリオド"
	= "."

Comma "カンマ"
	= ","

end "文の終端"
	= ";"
    
_ "空白"
	= [ \t\n\r]*
