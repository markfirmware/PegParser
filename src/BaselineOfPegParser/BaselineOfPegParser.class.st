Class {
	#name : #BaselineOfPegParser,
	#superclass : #BaselineOf,
	#category : #BaselineOfPegParser
}

{ #category : #baselines }
BaselineOfPegParser >> baseline: spec [
	<baseline>
	spec 
		for: #common
		do: [
			self petitParser2: spec.
			spec package: 'PegParser'
		]

]

{ #category : #baselines }
BaselineOfPegParser >> petitParser2: spec [
	spec
		baseline: 'PetitParser2'
		with: [ spec repository: 'github://kursjan/petitparser2' ]
]
