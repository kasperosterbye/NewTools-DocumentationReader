"
The result of the Microdown parser is a root object with a large number of children, where in particular all headers are at the same level as other nodes. 

I will build a hierarchical _sectioned_ microdown document based on a root document obtained from the microdown parser.

For each header I introduce _sections_ (`StSectionBlock`). A section has a header and a body. The header is a `MicHeaderBlock`, and the body are children of the section.

The structure of the new document (the original is not changed, I make a copy) is like this:
- The root become a section level 0. This root section has no header element.
- Each header become a section - the section has the same level as header
- Consider the children of the orginal root
   - Non-header nodes are added under the secction of the header closest to the left of its position
   - Header nodes are added under the section with a lower level closest to the left of its position

Notice the last two bullet points state that nodes are inserted in sections ""closest to the left of its position"". Implementation is done using a currentSection, that represent the section we are currently inserting elements into.

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
StSectionBuilder class >> from: aRoot [
	"Return a hierarchical document with sections"
	^ self new from: aRoot
]

{ #category : #'as yet unclassified' }
StSectionBuilder >> build: node [
	(node isKindOf: MicHeaderBlock)
		ifTrue: [ self buildHeader: node ]
		ifFalse: [ node copy parent: currentSection ]
]

{ #category : #running }
StSectionBuilder >> buildHeader: header [
	| subSection |
	[header level <= currentSection level ] whileTrue: [ currentSection := currentSection parent ].
	subSection := StSectionBlock new header: header; level: header level.
	subSection parent: currentSection.
	currentSection  := subSection
]

{ #category : #running }
StSectionBuilder >> from: aRoot [
	"I reorganize the document of aRoot so it is normalized - see class comment"
	|rootSection|
	currentSection := rootSection := StSectionBlock new header: aRoot; level: 0.
	aRoot children do: [:node | self build: node].
	^ rootSection
]
