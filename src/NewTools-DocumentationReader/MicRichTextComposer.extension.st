Extension { #name : #MicRichTextComposer }

{ #category : #'*NewTools-DocumentationReader' }
MicRichTextComposer >> visitSection: aHeader [
	self halt.
	canvas newLineIfNotAlready.
	canvas
		includeAttribute: (self class headerLevelFont: aHeader level)
		in: [ super visitHeader: aHeader ].
	canvas newLine
]
