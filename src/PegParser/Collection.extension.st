Extension { #name : #Collection }

{ #category : #'*PegParser' }
Collection >> asPParser [    
	^ PP2PredicateObjectNode anyOf: self
]
