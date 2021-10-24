"
I am a visitor which will do header _normalization_.

The visitor visits the nodes in order - view this order as a sequence of nodes. 

A document is header normalized if
1. The root is defined as a header level 0, and is defined to be header normalized
2. A non header node _N_ is a child of the header _H_ where H is the closest left header to _N_
3. A header _h_ of level X is a child of the header H, where  H is the closest left header with a level < X
"
Class {
	#name : #StHeaderNormalizationVisitor,
	#superclass : #Object,
	#instVars : [
		'currentHeader'
	],
	#category : #'NewTools-DocumentationReader'
}

{ #category : #running }
StHeaderNormalizationVisitor >> normalize: aRoot [
	"I reorganize the document of aRoot so it is normalized - see class comment"
	currentHeader := aRoot.
	self visit: aRoot.
]

{ #category : #initialization }
StHeaderNormalizationVisitor >> setAsSubsection: header [
	"header is a sub-header of currentHeader"
	header parent: currentHeader.
	currentHeader addChild: header.
	currentHeader := header
]

{ #category : #initialization }
StHeaderNormalizationVisitor >> setNewSection: header [
	"header is a sibling or uncle (sibling to parent) of current header."
	"Notice - per invariant currentHeader is now normalized"
	[header level >= currentHeader level ] whileTrue: [ currentHeader := currentHeader parent ].
	self setAsSubsection: header.
]

{ #category : #running }
StHeaderNormalizationVisitor >> visit: aNode [
	aNode parent: currentHeader.
	currentHeader addChild: aNode.
	aNode visitAll: aNode children.
]

{ #category : #running }
StHeaderNormalizationVisitor >> visitHeader: header [
	self flag: #fixSuper. "My super visit assumes headers not to have children"
	(header level <= currentHeader level) 
		ifTrue: [ self setNewSection: header ]
		ifFalse: [ self setAsSubsection: header  ].
	"Visit the children of the header - necessary if document is already normalized"
	header visitAll: header children.
]
