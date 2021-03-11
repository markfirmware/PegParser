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
	#superclass : #PPCompositeParser,
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
	#category : #'PegParser'
}

{ #category : #'grammar-operators' }
PegHandParser >> pegAND [
	^ $& asParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegAction [
	^ ${ asParser , $} asParser negate star , $} asParser , pegSpacing
	


]

{ #category : #'grammar-operators' }
PegHandParser >> pegBEGIN [
	^ $< asParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegCLOSE [
	^ $) asParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegChar [            
	^ ( $\ asParser , '"''[\]abefnrtv' asArray asParser )
 	/ ( $\ asParser , '0123' asArray asParser , '01234567' asArray asParser , '01234567' asArray asParser )
	/ ( $\ asParser , '01234567' asArray asParser , '01234567' asArray asParser optional )
	/ ( $\ asParser , $- asParser )
	/ ( $\ asParser not , #any asParser )
]

{ #category : #grammar }
PegHandParser >> pegClass [
	^ $[ asParser , ( $] asParser not, pegRange ) star , $] asParser , pegSpacing
]

{ #category : #'grammar-operators' }
PegHandParser >> pegComment [ 
	^ $# asParser , ( pegEndOfLine not , #any asParser ) star , pegEndOfLine 
	
	"NB could use starLazy: ?"

]

{ #category : #'grammar-operators' }
PegHandParser >> pegDOT [
	^ $. asParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegDefinition [
	^ pegIdentifier , pegLEFTARROW , pegExpression
]

{ #category : #'grammar-operators' }
PegHandParser >> pegEND [
	^ $> asParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegEndOfFile [
	^ #any asParser not

]

{ #category : #'grammar-operators' }
PegHandParser >> pegEndOfLine [
	^ (String crlf asParser
	/ Character lf asParser 
	/ Character cr asParser) plus

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
	^ PPPredicateObjectParser anyOf: '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz'
	


]

{ #category : #grammar }
PegHandParser >> pegIdentStart [
	^ PPPredicateObjectParser anyOf: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz'
]

{ #category : #grammar }
PegHandParser >> pegIdentifier [
	^ pegIdentStart , pegIdentCont star , pegSpacing

]

{ #category : #'grammar-operators' }
PegHandParser >> pegLEFTARROW [
	^ '<-' asParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegLiteral [
	^ ( $' asParser , ( $' asParser not , pegChar ) star , $' asParser , pegSpacing )
	/ ( $" asParser , ( $" asParser not , pegChar ) star , $" asParser , pegSpacing )

]

{ #category : #'grammar-operators' }
PegHandParser >> pegNOT [
	^ $! asParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegOPEN [
	^ $( asParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegPLUS [
	^ $+ asParser , pegSpacing
 
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
	^ $? asParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegRange [
	^ ( pegChar , $- asParser , pegChar )
	/ pegChar

]

{ #category : #'grammar-operators' }
PegHandParser >> pegSLASH [
	^ $/ asParser , pegSpacing
 
]

{ #category : #'grammar-operators' }
PegHandParser >> pegSTAR [
	^ $* asParser , pegSpacing
 
]

{ #category : #grammar }
PegHandParser >> pegSequence [
	^ pegPrefix star
]

{ #category : #'grammar-operators' }
PegHandParser >> pegSpace [ 
	^ Character space asParser
	/ Character tab asParser 
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
