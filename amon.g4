grammar amon;

TAB: '\t';
SP: ' ';
NUM: '#';
PLUS: '+';
AST: '*';
DOLLAR: '$';
GT: '>';
TILDE: '~';
COMMA: ',';
MINUS: '-';
COLON: ':';
DOT: '.';
SOL: '/';
BSOL: '\\';
GRAVE: '`';
HAT: '^';
LBRACK: '[';
RBRACK: ']';
LOWBAR: '_';
LPAR: '(';
RPAR: ')';
QUEST: '?';
COMMAT: '@';
EXCL: '!';
LF: '\n';
CR: '\r';

DIGIT: [0-9];
ALPHA: [a-zA-Z];

URL:
	'http' 's'? '://' [0-9a-zA-Z_-]+ '.' [0-9a-zA-Z_-]+ [0-9a-zA-Z_./&=?%-]*;
EMAIL: [0-9a-zA-Z._+-] '@' [0-9a-zA-Z_-] ( '.' [a-zA-Z])+;

Year: DIGIT DIGIT DIGIT DIGIT;
Month: '0'? [1-9] | '1' [0-2];
Day: [0-2]? [1-9] | '3' ( '0' | '1');
Hour12: '0'? [0-9] | '1' [0-2];
Hour24: [01]? [0-9] | '2' [0-4];
Minute: [0-5]? [0-9];
Am: 'am' | 'AM';
Pm: 'pm' | 'PM';

document: block*;

block: header | detail | paragraph | quote | list | blank;

header: ( h1 | h2 | h3 | h4 | h5 | h6) wsp? eol;
h1: NUM wsp inlines;
h2: NUM NUM wsp inlines;
h3: NUM NUM NUM wsp inlines;
h4: NUM NUM NUM NUM wsp inlines;
h5: NUM NUM NUM NUM NUM wsp inlines;
h6: NUM NUM NUM NUM NUM NUM wsp inlines;

detail: ( summary | summaryHeader) block?;
summary: PLUS+ wsp inlines wsp? eol;
summaryHeader: ( sH1 | sH2 | sH3 | sH4 | sH5 | sH6) eol;
sH1: AST wsp inlines;
sH2: AST AST wsp inlines;
sH3: AST AST AST wsp inlines;
sH4: AST AST AST AST wsp inlines;
sH5: AST AST AST AST AST wsp inlines;
sH6: AST AST AST AST AST AST wsp inlines;

paragraph: line+;
line: SP* inlines wsp? eol;

quote: pre | code | message | cite;

code:
	TAB DOLLAR wsp? lang (
		COMMA wsp? fileName ( COMMA wsp? lineNum)?
	)? nl pre;
lang: notBreaker+;
fileName: notBreaker+;
lineNum: DIGIT+;

message: TAB GT wsp? name ( COMMA wsp? dateTime)? nl pre;
name: notBreaker+;
dateTime: date | time | date SP time;
date: Year | Month MINUS Day | Year MINUS Month MINUS Day;
time: Hour24 COLON Minute | Hour12 COLON Minute ( Am | Pm);

cite:
	TAB TILDE wsp? name (COMMA wsp? ( dateTime | citation))? nl pre;
citation: notBreaker;

pre: ( TAB notEOL* eol)+;

list: ( unorderedList | orderedList);

unorderedList: ( ulItem eol)+;
ulItem: MINUS wsp inlines wsp? | MINUS ulItem;

orderedList: ( DIGIT ( DIGIT ( DIGIT)?)?)? ( olItem eol)+;
olItem: DOT wsp inlines wsp? | DOT ulItem;

inlines: inline ( wsp inline)*;
inline:
	word
	| strong
	| emphasis
	| literal
	| superscript
	| subscript
	| link
	| variable;

grouped: LBRACK inlines RBRACK;

word:
	notStarter (sstrong | semphasis | sliteral)* notBreaker*
	| AST+ (notBreaker* ~( AST | SP | TAB | CR | LF | COMMA))?
	| SOL+ (notBreaker* ~( SOL | SP | TAB | CR | LF | COMMA))?
	| GRAVE+ (notBreaker* ~( GRAVE | SP | TAB | CR | LF | COMMA))?;

escaped: BSOL .;

strong: AST inlines AST;
sstrong: AST strong AST;

emphasis: SOL inlines SOL;
semphasis: SOL emphasis SOL;

literal: GRAVE notEOL* GRAVE;
sliteral: GRAVE literal GRAVE;

superscript: HAT ( grouped | inline);
subscript: LOWBAR ( grouped | inline);

link: (URL | EMAIL)
	| LPAR ( URL | EMAIL) RPAR ( grouped | inline)?
	| contextName
	| listName
	| tagName;

contextName: COMMAT ( grouped | inline);
listName: PLUS ( grouped | inline);
tagName: NUM ( grouped | inline);

variable: varDef | varSub | varDefSub | varIf | varSubIf;

varDef: COLON varName ( grouped | inline);
varSub: DOLLAR varName;
varDefSub: DOLLAR COLON varName ( grouped | inline);
varIf: QUEST varName ( grouped | inline);
varSubIf: QUEST DOLLAR varName ( grouped | inline);

varName: ALPHA ( ALPHA | DIGIT)*;

notStarter:
	~(
		SP
		| TAB
		| CR
		| LF
		| BSOL
		| AST
		| SOL
		| COMMAT
		| LOWBAR
		| HAT
		| LPAR
		| EXCL
		| COLON
		| DOLLAR
		| QUEST
		| PLUS
		| NUM
		| LBRACK
		| MINUS
	)
	| escaped;
notBreaker: ~( SP | TAB | CR | LF | COMMA) | escaped;
notEOL: ~( CR | LF);

nl: CR? LF;
eol: nl | EOF;
wsp: ( SP | TAB)+;

blank: nl ( SP wsp? eol)*;
