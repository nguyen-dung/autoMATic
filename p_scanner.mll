(* autoMATic Compiler - Spring 2018 - COMS4115 PLT
 by Ivy Chen ic2389, Nguyen Chi Dung ncd2118,
 Nelson Gomez ng2573, Jimmy O'Donnell jo2474 *)

{ open P_parser }

let digit = ['0' - '9']
let digits = digit+
let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let id = ['A'-'Z' '_'] ['A'-'Z' '0'-'9' '_']*

rule token = parse
  white                     { WHITE }
| newline                   { ENDL }
| '"' ([^ '"']* as s) '"'   { STRLIT(s) }
| '#'                       { directive lexbuf }
| id as s                   { VAR(s) }
| digits as s               { INTLIT(int_of_string s) }
| _ as c                    { PASS(String.make 1 c) }
| eof                       { EOF }

and directive = parse
  white                     { directive lexbuf }
| "include"                 { INCLUDE }
| "define"                  { DEFINE }
| "undef"                   { UNDEF }
| "ifdef"                   { IFDEF }
| "ifndef"                  { IFNDEF }
| "end"                     { END }
