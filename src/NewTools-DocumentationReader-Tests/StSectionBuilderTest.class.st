"
A StHeaderNormalizationVisitorTest is a test class for testing the behavior of StHeaderNormalizationVisitor
"
Class {
	#name : #StSectionBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'sectionBuilder'
	],
	#category : #'NewTools-DocumentationReader-Tests'
}

{ #category : #running }
StSectionBuilderTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	sectionBuilder := StSectionBuilder 
]

{ #category : #tests }
StSectionBuilderTest >> testAccessSubSections [
	| root src |
	src :='#Header1
paragraph 1
## Header 1.1
paragraph 2

paragraph 3
### Header 1.1.1
#Header 2
### Header 2.0.1'.
	root := Microdown new parse: src .
	root := sectionBuilder from: root.
	self assert: root subSections size equals: 2.
	self assert: root subSections first subSections size equals: 1.
	self assert: root subSections first subSections first subSections size equals: 1
]

{ #category : #tests }
StSectionBuilderTest >> testAgnosticRichText [
	| root src text1 text2 |
	src :='paragraph 1

paragraph 2'.
	root := Microdown new parse: src .
	text1 := MicRichTextComposer new visit: root.
	root := sectionBuilder from: root.
	text2 := MicRichTextComposer new visit: root.
	self assert: text1 equals: text2
]

{ #category : #tests }
StSectionBuilderTest >> testAgnosticRichTextHeaderWithSubHeaders [
	| root1 root2 src text1 text2 |
	src :='#Header1
**paragraph 1**
## Header 1.1
paragraph 2
### _Header 1.1.1_
#Header 2
### Header 2.0.1'.
	root1 := Microdown new parse: src .
	text1 := MicRichTextComposer new visit: root1.
	root2 := sectionBuilder from: root1.
	text2 := MicRichTextComposer new visit: root2.
	self assert: text1 equals: text2
]

{ #category : #tests }
StSectionBuilderTest >> testEmptyRoot [
	| root |
	root := MicRootBlock new.
	root := sectionBuilder from: root.
	self assert: root children isEmpty 
]

{ #category : #tests }
StSectionBuilderTest >> testHeaderLevel1 [ 
	| root src |
	src :='#Header1'.
	root := Microdown new parse: src .
	self assert: root children size equals: 1.
	root := sectionBuilder from: root.
	self assert: root children size equals: 1 
]

{ #category : #tests }
StSectionBuilderTest >> testHeaderLevel1With2Paragraphs [
	| root src |
	src :='#Header1
paragraph 1

paragraph 2'.
	root := Microdown new parse: src .
	self assert: root children size equals: 3.
	root := sectionBuilder from: root.
	self assert: root children size equals: 1.
	self assert: root children first header header equals: 'Header1'
]

{ #category : #tests }
StSectionBuilderTest >> testHeaderWithSubHeaders [
	| root src |
	src :='#Header1
paragraph 1
## Header 1.1
paragraph 2
### Header 1.1.1
#Header 2
### Header 2.0.1'.
	root := Microdown new parse: src .
	self assert: root children size equals: 7.
	root := sectionBuilder from: root.
	self assert: root children size equals: 2
]

{ #category : #tests }
StSectionBuilderTest >> testHeaderWithSubHeaders2 [
	| root src |
	src :='#Header1
paragraph 1
## Header 1.1
paragraph 2
### Header 1.1.1
paragraph 3
#Header 2
### Header 2.0.1
paragraph 4'.
	root := Microdown new parse: src .
	root := sectionBuilder from: root.
	self assert: root children size equals: 2.
	self assert: root children second children size equals: 1
]

{ #category : #tests }
StSectionBuilderTest >> testNoHeaders [
	| root src |
	src :='paragraph 1

paragraph 2'.
	root := Microdown new parse: src .
	self assert: root children size equals: 2.
	root := sectionBuilder from: root.
	self assert: root children size equals: 2 
]
