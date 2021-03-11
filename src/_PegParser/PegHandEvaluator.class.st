Class {
	#name : #PegHandEvaluator,
	#superclass : #PegHandParser,
	#category : #'_PegParser'
}

{ #category : #accessing }
PegHandEvaluator >> comment [
	^ super comment flatten
]

{ #category : #accessing }
PegHandEvaluator >> pegComment [
	^ super pegComment flatten
]

{ #category : #accessing }
PegHandEvaluator >> pegSpace [
	^ super pegSpace ==> [ :n | '' ]
]
