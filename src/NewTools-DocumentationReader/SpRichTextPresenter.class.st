"
I am a presenter for rich text. I can show and edit a string in microdown format, or show it in rendered text.

I am using a morphic component to show the text.
"
Class {
	#name : #SpRichTextPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'richTextString',
		'rendering',
		'wrappedTextMorph',
		'morphTextModel'
	],
	#category : #'NewTools-DocumentationReader'
}

{ #category : #specs }
SpRichTextPresenter class >> defaultSpec [
	
	 ^ SpBoxLayout newTopToBottom
			add: #wrappedTextMorph
			yourself
]

{ #category : #'instance creation' }
SpRichTextPresenter class >> openOn: aRTString [
	^ (self on:  aRTString)
		openWithSpec;
		yourself
]

{ #category : #'tools support' }
SpRichTextPresenter >> confirmDiscardChanges [

	^self confirm: 'Changes have not been saved.
Is it OK to discard changes?'
]

{ #category : #rendering }
SpRichTextPresenter >> editColor [
	^ self theme backgroundColor 
]

{ #category : #accessing }
SpRichTextPresenter >> editor [
	^ wrappedTextMorph morph
]

{ #category : #initialization }
SpRichTextPresenter >> initializePresenters [
	morphTextModel := RubScrolledTextModel new.
	morphTextModel text: richTextString.
	wrappedTextMorph := self newMorph
		morph: morphTextModel newScrolledText;
		yourself.
	self setRenderMode
]

{ #category : #hooks }
SpRichTextPresenter >> morphWriter [

	^ MicRichTextComposer new
]

{ #category : #hooks }
SpRichTextPresenter >> parserClass [ 
	^ MicroDownParser
]

{ #category : #rendering }
SpRichTextPresenter >> renderColor [
	| bgColor |
	bgColor := self theme backgroundColor.
	^ bgColor lightness < 0.5
		ifTrue: [ bgColor + (Color r: 0.0 g: 0.04 b:0.08 )]
		ifFalse: [ bgColor darker ]
]

{ #category : #rendering }
SpRichTextPresenter >> setEditMode [
	self editor 
		setText: richTextString;
		color: self editColor.
	self editor textArea readOnly: rendering.
]

{ #category : #initialization }
SpRichTextPresenter >> setModelBeforeInitialization: aRTString [
	"This method is the initialization method of Spec, initiated by the class side method on:"
	richTextString := aRTString.
	rendering := true.
]

{ #category : #rendering }
SpRichTextPresenter >> setRenderMode [

	| document |
	(self editor hasUnacceptedEdits and: [ self confirmDiscardChanges])
		ifFalse: [ richTextString := morphTextModel text asString. ].
	document := self parserClass parse: richTextString .
	self editor
			setText: (self morphWriter visit: document);	
			color: self renderColor.
	self editor textArea readOnly: rendering.
]

{ #category : #accessing }
SpRichTextPresenter >> title [
	self flag: #fixme. "I should use the name from the first header"
	^ 'RichText presenter'
]

{ #category : #rendering }
SpRichTextPresenter >> toggleRendering [
	rendering := rendering not.
	self update
]

{ #category : #rendering }
SpRichTextPresenter >> update [
	rendering
		ifTrue: [ self setRenderMode  ]
		ifFalse: [ self setEditMode  ]
	
]
