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
	= _ expression:expr end{
		return {
			"type": "ExpressionStatement",
            expression
		}
      }
	/ _ method:meth _ optionalparameter:para{
    	return {
        	"type": "MethodStatement",
            "operator": "CallMethod"
            method,
            optionalparameter
        }
    }

meth
	= object:obj "." callmethod:call

para
	= block
    / colons end
    / expr end 

colons 
	= colon*
    
colon
	= keyword:key _ ":" _ word _ ","
    / keyword:key _ ":" _ word _ end

block
	= "{" _ stmt _ "}"
    
expr
	= assignmentexpression:asex
    / pipelineexpression:piex
    / relationexpression:reex
    / binaryexpression:biex
    
end
	= ";"

_ "whitespace"
	= [ \t\n\r]*

word 
	= word:[a-zA-z][0-9a-zA-Z]*
