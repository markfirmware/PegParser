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
			spec repository: 'github://johnhwoods/PegParser'.
			spec package: 'PegParser'
		]

]

{ #category : #baselines }
BaselineOfPegParser >> petitParser: spec [
	spec
		baseline: 'PetitParser'
		with: [ spec repository: 'github://moosetechnology/PetitParser/releases/tag/v2.2.0' ]
]
