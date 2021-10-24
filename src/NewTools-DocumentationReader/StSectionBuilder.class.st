"
I am a visitor which will do header _normalization_.

The visitor visits the nodes in order - view this order as a sequence of nodes. 

A document is header normalized if
1. The root is defined as a header level 0, and is defined to be header normalized
2. A non header node _N_ is a child of the header _H_ where H is the closest left header to _N_
3. A header _h_ of level X is a child of the header H, where  H is the closest left header with a level < X
"
Class {
	#name : #StSectionBuilder,
	#superclass : #Object,
	#instVars : [
		'currentSection'
	],
	#category : #'NewTools-DocumentationReader'
}

{ #category : #running }
StSectionBuilder class >> normalize: aRoot [
	^ self new normalize: aRoot
]

{ #category : #running }
StSectionBuilder >> buildHeader: header [
	(header level <= currentSection level) 
		ifTrue: [ self setNewSection: header ]
		ifFalse: [ self setAsSubsection: header  ].
]

{ #category : #running }
StSectionBuilder >> includeInCurrentSection: aNode [

	| newNode |
	(aNode isKindOf: MicInlineElement) ifTrue: [ ^ self ].
	aNode parent = currentSection ifTrue: [ ^ self ].
	newNode := aNode copy parent: currentSection.
]

{ #category : #running }
StSectionBuilder >> normalize: aRoot [
	"I reorganize the document of aRoot so it is normalized - see class comment"
	|rootSection|
	currentSection := rootSection := StSectionBlock new header: aRoot; level: 0.
	aRoot children do: [:node | self normalizeNode: node].
	^ rootSection
]

{ #category : #'as yet unclassified' }
StSectionBuilder >> normalizeNode: node [
	(node isKindOf: MicHeaderBlock)
		ifTrue: [ self buildHeader: node ]
		ifFalse: [ node copy parent: currentSection ]
]

{ #category : #initialization }
StSectionBuilder >> setAsSubsection: header [
	"header is a sub-section of currentSection"
	|subSection|
	subSection := StSectionBlock new header: header; level: header level.
	subSection parent: currentSection.
	currentSection  := subSection
]

{ #category : #initialization }
StSectionBuilder >> setNewSection: header [
	"header is a sibling or uncle (sibling to parent) of current header."
	"Notice - per invariant currentHeader is now normalized"
	[header level <= currentSection level ] whileTrue: [ currentSection := currentSection parent ].
	self setAsSubsection: header.
]
