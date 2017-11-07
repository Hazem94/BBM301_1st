%{
	
	#include<stdio.h>
	void yyerror (char *s);
	int yylex();
	
%}


%union{  // Later to be diccussed
	float			float_val;
	int			int_val;
	char			char_val;
	char			byte_val;// C has no byte type
	double			double_val;
	int 			bool_val;// C has no bool type
}

%start program

%token INT FLOAT BOOL VOID CHAR ARRAY BYTE STRING DOUBLE FE DIRECTORY
%token LONG_INT SHORT_INT LONG_FLOAT SHORT_FLOAT LONG_DOUBLE SHORT_DOUBLE
%token BLN_FALSE BLN_TRUE AND_OPT OR_OPT NOT_OPT IF ELSE SWITCH CASE DEFAULT ELIF IFNOT WHILE DO BREAK
%token CONTINUE FOR RETURN BLTIN_PRINT BLTIN_LIST_CONTENTS BLTIN_GET_SIZE
%token BLTIN_CREATE BLTIN_COPY BLTIN_COMPARE BLTIN_CONNECT_TO BLTIN_DELETE BLTIN_RENAME BLTIN_MOVE
%token BLTIN_SORT BLTIN_FILTRE_FILES BLTIN_BACKUP BLTIN_SYNCHRONIZE BLTIN_SEARCH BLTIN_CD BLTIN_BACK_UP
%token BLTIN_DOWNLOAD BLTIN_UPLOAD BLTIN_OPEN BLTIN_PROPERTIES BLTIN_MOVE_BACK BLTIN_MOVE_FORWARD
%token LESSEQ_OPT GREATEREQ_OPT NEQ_OPT EQ_OPT LESS_OPT GREATER_OPT ASSIGNMENT_OPT
%token MULTIPLY_ASSIGNMENT_OPT DIVIDE_ASSIGNMENT_OPT MODE_ASSIGNMENT_OPT ADD_ASSIGNMENT_OPT
%token SUB_ASSIGNMENT_OPT POW_ASSIGNMENT_OPT INCREMENT_OPT DECREMENT_OPT
%token DIVIDE_OPT MODE_OPT ADD_OPT SUB_OPT POW_OPT MULTIPLY_OPT
%token INT_LTRL FLT_LTRL DOUBLE_LTRL STR_LTRL CHR_LTRL IDNTF GOTO 
%token BITWISE_XOR BITWISE_NOR BITWISE_NOT BITWISE_OR BITWISE_AND BITWISE_LEFTSHIFT BITWISE_RIGHTSHIFT 
%token SEMICOLON LEFT_BRACKET RIGHT_BRACKET COMMA COLON LEFT_PARANTHESIS RIGHT_PARANTHESIS
%token LEFT_SQ_BRACKET RIGHT_SQ_BRACKET NEW_LINE WHITE_SPACE UNKNOWN_CHAR UNDER_SCORE BACK_SLASH ASTRIC COMMENT

/* Binary operators's precedence */
%left  BITWISE_NOR
%left  BITWISE_OR
%left  BITWISE_XOR
%left  BITWISE_AND
%left  BITWISE_LEFTSHIFT BITWISE_RIGHTSHIFT
%left  ADD_OPT SUB_OPT
%left  DIVIDE_OPT MODE_OPT MULTIPLY_OPT 
%right POW_OPT
%right BITWISE_NOT


%%
program : statement_list ;
statement_list : statement 
               | statement_list statement 
			   ;

statement : assignment SEMICOLON
		  | declaration SEMICOLON
		  | loop
		  | condition
		  | GOTO COLON flag SEMICOLON
		  | COMMENT
		  | function_call SEMICOLON
		  | BREAK SEMICOLON
		  | CONTINUE SEMICOLON                     // deleted RETURN factor SEMICOLON RETURN IDNTF SEMICOLON RETURN SEMICOLON
		  ;

block : LEFT_BRACKET statement_list RIGHT_BRACKET
	  | LEFT_BRACKET empty RIGHT_BRACKET
	  ;

declaration : data_type IDNTF 
			| declaration assignment_operator RHS
			| ARRAY data_type IDNTF LEFT_SQ_BRACKET INT_LTRL RIGHT_SQ_BRACKET ASSIGNMENT_OPT LEFT_BRACKET factor_list RIGHT_BRACKET
			;

factor_list : factor
			| factor_list COMMA factor
			;

RHS : arithmetic_expression
	| function_call
	| boolean_expression
	;

function_call 	:  BLTIN_PRINT LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//takes one parrameter
				| BLTIN_LIST_CONTENTS LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS// takes one parameter
				| BLTIN_GET_SIZE LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//takes one parameter
				| BLTIN_CREATE LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//takes one parameter
				| BLTIN_COPY LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//takes one paramter
				| BLTIN_COMPARE LEFT_PARANTHESIS identifier COMMA identifier RIGHT_PARANTHESIS// two parameter
				| BLTIN_CONNECT_TO LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS// one parameter
				| BLTIN_DELETE LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//one
				| BLTIN_RENAME LEFT_PARANTHESIS identifier COMMA identifier RIGHT_PARANTHESIS//two
				| BLTIN_MOVE LEFT_PARANTHESIS identifier COMMA identifier RIGHT_PARANTHESIS//two
				| BLTIN_SORT LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//one
				| BLTIN_FILTRE_FILES LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//one
				| BLTIN_BACK_UP LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//one
				| BLTIN_SYNCHRONIZE LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//one
				| BLTIN_SEARCH LEFT_PARANTHESIS identifier COMMA identifier RIGHT_PARANTHESIS//two
				| BLTIN_CD LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//one
				| BLTIN_DOWNLOAD LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//one
				| BLTIN_UPLOAD LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//one
				| BLTIN_OPEN LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS//one
				| BLTIN_PROPERTIES LEFT_PARANTHESIS identifier RIGHT_PARANTHESIS///one
				| BLTIN_MOVE_BACK LEFT_PARANTHESIS empty RIGHT_PARANTHESIS//zero
				| BLTIN_MOVE_FORWARD LEFT_PARANTHESIS empty RIGHT_PARANTHESIS//zero
				| error {                                   // for test purpose
			     yyerror1(" >>>> Undefeined function\n");
				 yyerrok;
				 yyclearin;}       //Check wheather a function is defined or not
		        ;
identifier :	 IDNTF 
				|STRING
				| error {                                   //Check wheather the parameter is acceptable or not
			     yyerror1(" >>>> Unacceptable function parameter\n");
				 yyerrok;yyclearin;}
				;

arithmetic_expression 	: operand
						| arithmetic_expression ADD_OPT operand
						| arithmetic_expression SUB_OPT operand
						| arithmetic_expression MULTIPLY_OPT operand
						| arithmetic_expression DIVIDE_OPT operand
						| arithmetic_expression POW_OPT operand
						| arithmetic_expression MODE_OPT operand
						| arithmetic_expression BITWISE_LEFTSHIFT operand
						| arithmetic_expression BITWISE_RIGHTSHIFT operand
						| arithmetic_expression BITWISE_AND operand
						| arithmetic_expression BITWISE_OR operand
						| arithmetic_expression BITWISE_XOR operand
						| arithmetic_expression BITWISE_NOR operand
						| BITWISE_NOT arithmetic_expression  
						;

operand : factor 
        | IDNTF 
		;

factor 	: INT_LTRL
		| FLT_LTRL 
		| STR_LTRL
		| CHR_LTRL
		| DOUBLE_LTRL	
		;

assignment_operator : ASSIGNMENT_OPT 
					| MULTIPLY_ASSIGNMENT_OPT 
					| DIVIDE_ASSIGNMENT_OPT 
					| ADD_ASSIGNMENT_OPT 
					| SUB_ASSIGNMENT_OPT 
					| MODE_ASSIGNMENT_OPT
					| POW_ASSIGNMENT_OPT
					;

assignment 	: LHS assignment_operator RHS
			| LHS INCREMENT_OPT 
			| LHS DECREMENT_OPT
			;

LHS : IDNTF
	| IDNTF LEFT_SQ_BRACKET INT_LTRL RIGHT_SQ_BRACKET
	;

loop 	: while_loop
		| do_while_loop 
		| for_loop
		;

while_loop : WHILE LEFT_PARANTHESIS boolean_expression RIGHT_PARANTHESIS block 
		   ;

do_while_loop : do_statement WHILE LEFT_PARANTHESIS boolean_expression RIGHT_PARANTHESIS SEMICOLON
			  ;

do_statement : DO block
			 ;

for_loop : FOR LEFT_PARANTHESIS for_statement RIGHT_PARANTHESIS block
		 ;

for_statement : declaration SEMICOLON boolean_expression SEMICOLON assignment // REMOVED INITILIZE, FOR ONLY WORKS WITH __ for(int x=1;....)__
			  ;


condition 	: if_statement
			| switch_statement
			;

if_statement 	: IF LEFT_PARANTHESIS boolean_expression RIGHT_PARANTHESIS block
				| IF LEFT_PARANTHESIS function_call RIGHT_PARANTHESIS block
				| IFNOT LEFT_PARANTHESIS boolean_expression RIGHT_PARANTHESIS block
				| IFNOT LEFT_PARANTHESIS function_call RIGHT_PARANTHESIS block                       //added notif block for function call
				| if_statement ELIF LEFT_PARANTHESIS boolean_expression RIGHT_PARANTHESIS block
				| if_statement ELIF LEFT_PARANTHESIS function_call RIGHT_PARANTHESIS block             // added an elif block for function  call  
				| if_statement ELSE block 
				;

boolean_expression 	: comparison                    // deleted IDNTF AND NOT IDNTF to solve issue with arithmetic_expression reduce conflict
					| BLN_FALSE 
					| BLN_TRUE
					;

comparison 	: 	boolean_expression boolean_operators compared // boolean operators only for boolean values (false and true, .....)
			| factor relational_operators factor		// relational operators only for factor values ( 1>2, 2==2, .....)
			| IDNTF relational_operators factor
			| factor relational_operators IDNTF
			| IDNTF relational_operators IDNTF
			;

compared	: IDNTF
			| BLN_FALSE 
			| BLN_TRUE
			| NOT_OPT IDNTF
			;

relational_operators 	: LESSEQ_OPT
						| GREATEREQ_OPT 
						| NEQ_OPT 
						| EQ_OPT 
						| LESS_OPT 
						| GREATER_OPT
						;

boolean_operators 	: AND_OPT 
					| OR_OPT
					;

switch_statement : SWITCH LEFT_PARANTHESIS IDNTF RIGHT_PARANTHESIS LEFT_BRACKET case_statement RIGHT_BRACKET 
				 ;

case_statement 	: CASE IDNTF COLON statement_list
				| CASE factor COLON statement_list
				| case_statement CASE IDNTF COLON statement_list
				| case_statement CASE factor COLON statement_list
			    | case_statement DEFAULT COLON statement_list
				;

data_type 	: CHAR 
			| INT 
			| FLOAT 
			| BOOL
			| BYTE
			| STRING
			| DOUBLE
			| FE
			| DIRECTORY
			| LONG_INT
			| SHORT_INT
			| LONG_FLOAT
			| SHORT_FLOAT
			| LONG_DOUBLE
			| SHORT_DOUBLE
		    | error {
				yyerror1(" >>>> unsupported data type\n");
				yyerrok;
				yyclearin;
			}
			;

flag : 	UNDER_SCORE UNDER_SCORE IDNTF UNDER_SCORE UNDER_SCORE
	 ;


empty : /* empty */
	  ;
%%
int main (void){
	yyparse();
	return 0;
}

void yyerror1 (char *s) {fprintf (stderr, "%s", s);}
