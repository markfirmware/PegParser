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
			self petitParser: spec.
			spec package: 'PegParser'
		]

]

{ #category : #baselines }
BaselineOfPegParser >> petitParser: spec [
	spec
		baseline: 'PetitParser'
		with: [ spec repository: 'github://moosetechnology/PetitParser/src' ]
]
