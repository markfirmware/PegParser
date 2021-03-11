Class {
	#name : #ZigParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'zigRoot',
		'zig_skip',
		'zig_container_doc_comment',
		'zig_ContainerMembers',
		'zigTestDecl',
		'zigContainerMembers',
		'zigTopLevelComptime',
		'zigdoc_comment',
		'zigKEYWORD_pub',
		'zigContainerField',
		'zigCOMMA',
		'zigTopLevelDecl'
	],
	#category : #'PegParser'
}

{ #category : #accessing }
ZigParser >> start [
	"Answer the production to start this parser with."
	
	^ zigRoot end
]

{ #category : #grammar }
ZigParser >> zigRoot [
	^ zig_skip , zig_container_doc_comment optional , zig_ContainerMembers
]

{ #category : #grammar }
ZigParser >> zig_ContainerMembers [
	^ (zigTestDecl , zigContainerMembers)
		/ (zigTopLevelComptime , zigContainerMembers)
		/ (zigdoc_comment optional , zigKEYWORD_pub optional , zigTopLevelDecl , zigContainerMembers)
		/ (zigContainerField , zigCOMMA , zigContainerMembers)
		/ zigContainerField
		/ nil asParser
]

{ #category : #grammar }
ZigParser >> zig_container_doc_comment [
	^ 'zig_container_doc_comment' asParser
]

{ #category : #grammar }
ZigParser >> zig_skip [
	^ 'zig_skip' asParser
]
