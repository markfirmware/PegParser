Class {
	#name : #ManifestPegParser,
	#superclass : #PackageManifest,
	#category : #PegParser
}

{ #category : #'code-critics' }
ManifestPegParser class >> ruleGRParensFormattingRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#PegHandParser)) #'2021-03-11T00:07:07.716306+00:00') )
]

{ #category : #'code-critics' }
ManifestPegParser class >> ruleRBLiteralArrayCharactersRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#PegHandParser #pegChar #false)) #'2021-03-11T01:05:12.43336+00:00') )
]
