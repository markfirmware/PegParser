Class {
	#name : #PegHandEvaluator,
	#superclass : #PegHandParser,
	#category : #PegParser
}

{ #category : #accessing }
PegHandEvaluator >> pegComment [
	^ super pegComment flatten
]

{ #category : #accessing }
PegHandEvaluator >> pegSpace [
	^ super pegSpace ==> [ :n | '' ]
]
