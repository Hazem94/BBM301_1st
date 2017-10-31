/* Project.l */
/* FOR LATTER DISCUSS             Long_float Short_double */
Digit [0-9]
Letter [a-zA-Z]
INT_LTRL [\-+]?{Digit}+ 				
FLT_LTRL [\-+]?{Digit}*"."{Digit}+		
STR_LTRL \"(\\.|[^\\"])*\"				
CHR_LTRL \'(\\.|[^\\'])+\'				
IDNTF {Letter}({Digit}|{Letter})*	
NEW_LINE (\r|\n|\r\n)				
WHITE_SPACE [ \t\v\f]+					
%%
 /* Literals and Identifiers */
({WHITE_SPACE}) ;
({IDNTF}) {
            return (IDNTF);
          }
({INT_LTRL}) {
            return (INT_LTRL);
          } 
({FLT_LTRL}) {
            return (FLT_LTRL);
          }
({STR_LTRL}) {
            return (STR_LTRL);
          }
({CHR_LTRL}) {
            return (CHR_LTRL);
          }

 /* Data Types */
int		  {
            return (INT);
    }

float    {
            return (FLOAT);
}						
bool	{
            return (BOOL);
}					
void    {
            return (VOID);
}						
char	{
            return (CHAR);
}					
array   {
            return (ARRAY);
}
byte	{
            return (BYTE);
}					
String  {
            return (STRING):
}
double  {
            return (DOUBLE);
}					
file	{
            return (FILE);
}					
directory {
            return (DIRECTORY);
}					
long_int  {
            return (LONG_INT);
}			
short_int {
            return (SHORT_INT);
}					
short_float {
            return (SHORT_FLOAT);
}					
long_double	{
            return (LONG_DOUBLE);
}
 /* Boolean Literals */
false       {
            return (BLN_FALSE);
}
true        {
            return (BLN_TRUE);
}      		

 /* Boolean Operators */
\&\&	    {
            return (AND_OPT);
}
\|\|        {
            return (OR_OPT);
}						
\#	{
		return (XOR_OPT);
}
\$	{
		return (NOR_OPT);
}


%%