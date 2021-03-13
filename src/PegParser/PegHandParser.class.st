"
# I am a *handmade* class for parsing PEGs and creating new, 
# automatically generated, PPCompositeParsers.  

# This entire class comment should be a valid PEG because lines starting 
# are comments in PEGs, as shown in the Grammar below. So if you reformat
# or add to this text, make sure each line starts with a hash! 

# Therefore: once I am working, running me with my own class as my input
# should yield an automatically generated parser, equivalent to myself,
# capable of parsing arbitrary valid PEGs (obviously including this one).

# From the PEG man page, the PEG for PEGs 
# 		(NB 'AND | NOT' has been changed to 'AND / NOT' )


		Grammar 			<- Spacing Definition+ EndOfFile

		Definition     <- Identifier LEFTARROW Expression
		Expression 		<- Sequence ( SLASH Sequence )*
           Sequence        <- Prefix*
           Prefix          <- AND Action
                            / ( AND / NOT )? Suffix
           Suffix          <- Primary ( QUERY / STAR / PLUS )?
           Primary         <- Identifier !LEFTARROW
                            / OPEN Expression CLOSE
                            / Literal
                            / Class
                            / DOT
                            / Action
                            / BEGIN
                            / END

           Identifier      <- < IdentStart IdentCont* > Spacing
           IdentStart      <- [a-zA-Z_]
           IdentCont       <- IdentStart / [0-9]
           Literal         <- ['] < ( !['] Char  )* > ['] Spacing
                            / [""] < ( ![""] Char  )* > [""] Spacing
           Class           <- '[' < ( !']' Range )* > ']' Spacing
           Range           <- Char '-' Char / Char
           Char            <- '\\' [abefnrtv'""\[\]\\]
                            / '\\' [0-3][0-7][0-7]
                            / '\\' [0-7][0-7]?
                            / '\\' '-'
                            / !'\\' .
           LEFTARROW       <- '<-' Spacing
           SLASH           <- '/' Spacing
           AND             <- '&' Spacing
           NOT             <- '!' Spacing
           QUERY           <- '?' Spacing
           STAR            <- '*' Spacing
           PLUS            <- '+' Spacing
           OPEN            <- '(' Spacing
           CLOSE           <- ')' Spacing
           DOT             <- '.' Spacing
           Spacing         <- ( Space / Comment )*
           Comment         <- '#' ( !EndOfLine . )* EndOfLine
           Space           <- ' ' / '\t' / EndOfLine
           EndOfLine       <- '\r\n' / '\n' / '\r'
           EndOfFile       <- !.
           Action          <- '{' < [^}]* > '}' Spacing
           BEGIN           <- '<' Spacing
           END             <- '>' Spacing
"
Class {
	#name : #PegHandParser,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'pegGrammar',
		'pegSpacing',
		'pegDefinition',
		'pegEndOfFile',
		'pegIdentifier',
		'pegLEFTARROW',
		'pegExpression',
		'pegSequence',
		'pegSLASH',
		'pegPrefix',
		'pegAND',
		'pegAction',
		'pegNOT',
		'pegSuffix',
		'pegPrimary',
		'pegQUERY',
		'pegSTAR',
		'pegPLUS',
		'pegOPEN',
		'pegLiteral',
		'pegClass',
		'pegDOT',
		'pegBEGIN',
		'pegEND',
		'pegCLOSE',
		'pegIdentStart',
		'pegIdentCont',
		'pegChar',
		'pegRange',
		'pegSpace',
		'pegComment',
		'pegEndOfLine'
	],
	#category : #PegParser
}

{ #category : #'grammar-operators' }
PegHandParser >> pegAND [
	^ $& asPParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegAction [
	^ ${ asPParser , $} asPParser negate star , $} asPParser , pegSpacing
	


]

{ #category : #'grammar-operators' }
PegHandParser >> pegBEGIN [
	^ $< asPParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegCLOSE [
	^ $) asPParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegChar [            
	^ ( $\ asPParser , '"''[\]abefnrtv' asSet asPParser )
 	/ ( $\ asPParser , '0123' asSet asPParser , '01234567' asSet asPParser , '01234567' asSet asPParser )
	/ ( $\ asPParser , '01234567' asSet asPParser , '01234567' asSet asPParser optional )
	/ ( $\ asPParser , $- asPParser )
	/ ( $\ asPParser not , #any asPParser )
]

{ #category : #grammar }
PegHandParser >> pegClass [
	^ $[ asPParser , ( $] asPParser not, pegRange ) star , $] asPParser , pegSpacing
]

{ #category : #'grammar-operators' }
PegHandParser >> pegComment [ 
	^ $# asPParser , ( pegEndOfLine not , #any asPParser ) star , pegEndOfLine 
	
	"NB could use starLazy: ?"

]

{ #category : #'grammar-operators' }
PegHandParser >> pegDOT [
	^ $. asPParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegDefinition [
	^ pegIdentifier , pegLEFTARROW , pegExpression
]

{ #category : #'grammar-operators' }
PegHandParser >> pegEND [
	^ $> asPParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegEndOfFile [
	^ #any asPParser not

]

{ #category : #'grammar-operators' }
PegHandParser >> pegEndOfLine [
	^ (String crlf asPParser
	/ Character lf asPParser 
	/ Character cr asPParser) plus

]

{ #category : #grammar }
PegHandParser >> pegExpression [
	^ pegSequence , ( pegSLASH , pegSequence ) star
]

{ #category : #grammar }
PegHandParser >> pegGrammar [
	^ pegSpacing , pegDefinition plus , pegEndOfFile
]

{ #category : #grammar }
PegHandParser >> pegIdentCont [
	^ PP2PredicateObjectNode anyOf: '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz'
	


]

{ #category : #grammar }
PegHandParser >> pegIdentStart [
	^ PP2PredicateObjectNode anyOf: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz'
]

{ #category : #grammar }
PegHandParser >> pegIdentifier [
	^ pegIdentStart , pegIdentCont star , pegSpacing

]

{ #category : #'grammar-operators' }
PegHandParser >> pegLEFTARROW [
	^ '<-' asPParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegLiteral [
	^ ( $' asPParser , ( $' asPParser not , pegChar ) star , $' asPParser , pegSpacing )
	/ ( $" asPParser , ( $" asPParser not , pegChar ) star , $" asPParser , pegSpacing )

]

{ #category : #'grammar-operators' }
PegHandParser >> pegNOT [
	^ $! asPParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegOPEN [
	^ $( asPParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegPLUS [
	^ $+ asPParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegPrefix [
	^ ( pegAND , pegAction )
   / ( ( pegAND / pegNOT ) optional , pegSuffix )

"NB AND|NOT replaced with AND/NOT for consistency, | not defined in PEG grammar"
]

{ #category : #grammar }
PegHandParser >> pegPrimary [
		^ ( pegIdentifier , pegLEFTARROW not )
      / ( pegOPEN , pegExpression , pegCLOSE )
      / pegLiteral
      / pegClass
      / pegDOT
      / pegAction
      / pegBEGIN
      / pegEND

]

{ #category : #'grammar-operators' }
PegHandParser >> pegQUERY [
	^ $? asPParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegRange [
	^ ( pegChar , $- asPParser , pegChar )
	/ pegChar

]

{ #category : #'grammar-operators' }
PegHandParser >> pegSLASH [
	^ $/ asPParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegSTAR [
	^ $* asPParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegSequence [
	^ pegPrefix star
]

{ #category : #'grammar-operators' }
PegHandParser >> pegSpace [ 
	^ Character space asPParser
	/ Character tab asPParser 
	/ pegEndOfLine
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegSpacing [
	^ ( pegSpace / pegComment ) star
 
]

{ #category : #grammar }
PegHandParser >> pegSuffix [
	^ pegPrimary , ( pegQUERY / pegSTAR / pegPLUS ) optional
]

{ #category : #accessing }
PegHandParser >> start [
	^ pegGrammar end
]
