Class {
	#name : #SpSectionPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'documentRoot',
		'sectionTree',
		'documentPresentation'
	],
	#category : #'NewTools-DocumentationReader'
}

{ #category : #specs }
SpSectionPresenter class >> defaultSpec [
	
	 ^ SpPanedLayout newLeftToRight 
			add: #sectionTree;
			add: #documentPresentation
			yourself
]

{ #category : #specs }
SpSectionPresenter class >> openOn: document [
	^ (self on:  document)
		openWithSpec;
		yourself
]

{ #category : #accessing }
SpSectionPresenter >> documentRoot [

	^ documentRoot
]

{ #category : #accessing }
SpSectionPresenter >> documentRoot: anObject [

	documentRoot := anObject.
	sectionTree roots: { documentRoot  }.
]

{ #category : #initialization }
SpSectionPresenter >> initializePresenters [

	super initializePresenters.
	sectionTree := self newTree.
	sectionTree 
		roots: { self documentRoot };
		children: [ :aNode | aNode subSections ];
		display: [ :each | each printString];
		whenSelectedItemChangedDo: [:node | self showNode: node].
	documentPresentation := self newMorph 
		morph: (RubScrolledTextModel new text: '' asText) newScrolledText; yourself.
]

{ #category : #initialization }
SpSectionPresenter >> setModelBeforeInitialization: document [
	"This method is the initialization method of Spec, initiated by the class side method on:"
	documentRoot := StSectionBuilder from: document
]

{ #category : #'as yet unclassified' }
SpSectionPresenter >> showNode: node [
	| text |
	text := MicRichTextComposer new visit: node.
	documentPresentation morph model: (RubScrolledTextModel new text: text)
]
