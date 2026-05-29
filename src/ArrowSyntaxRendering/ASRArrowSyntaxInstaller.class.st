"
Global entry point for installing and toggling arrow syntax rendering in Rubric Smalltalk editors.
"
Class {
	#name : 'ASRArrowSyntaxInstaller',
	#superclass : 'Object',
	#classVars : [
		'Enabled'
	],
	#category : 'ArrowSyntaxRendering-Core',
	#package : 'ArrowSyntaxRendering',
	#tag : 'Core'
}

{ #category : 'settings' }
ASRArrowSyntaxInstaller class >> disable [

	self enabled: false.
	^ self enabled
]

{ #category : 'settings' }
ASRArrowSyntaxInstaller class >> enable [

	self enabled: true.
	^ self enabled
]

{ #category : 'settings' }
ASRArrowSyntaxInstaller class >> enabled [

	^ Enabled ifNil: [ false ]
]

{ #category : 'settings' }
ASRArrowSyntaxInstaller class >> enabled: aBoolean [

	Enabled := aBoolean.
	self refreshOpenEditors.
	^ self
]

{ #category : 'examples' }
ASRArrowSyntaxInstaller class >> exampleMorph [

	| model morph decorator |
	model := RubScrolledTextModel new.
	model setInitialText: self sampleSource asText.
	morph := RubScrolledTextMorph new.
	morph model: model.
	morph beForSmalltalkCode.
	morph textArea withDecoratorNamed: #shoutStyler.
	decorator := self installOnScrolledTextMorph: morph.
	decorator classOrMetaClass: Object.
	decorator refreshStyling.
	^ morph
]

{ #category : 'installing' }
ASRArrowSyntaxInstaller class >> installOnScrolledTextMorph: aScrolledTextMorph [

	^ self installOnTextArea: aScrolledTextMorph textArea
]

{ #category : 'installing' }
ASRArrowSyntaxInstaller class >> installOnTextArea: aTextArea [

	| decorator |
	aTextArea withDecoratorNamed: #shoutStyler.
	decorator := aTextArea decoratorNamed: #shoutStyler.
	decorator styler: ASRArrowSyntaxTextStyler new.
	decorator refreshStyling.
	^ decorator
]

{ #category : 'examples' }
ASRArrowSyntaxInstaller class >> openExample [

	^ self exampleMorph openInWindow
]

{ #category : 'styling' }
ASRArrowSyntaxInstaller class >> refreshOpenEditors [

	RubShoutStylerDecorator allInstancesDo: [ :decorator |
		decorator resetArrowSyntaxRenderingStyler ]
]

{ #category : 'examples' }
ASRArrowSyntaxInstaller class >> sampleSource [

	^ String streamContents: [ :stream |
			  stream
				  nextPutAll: 'example';
				  cr.
			  stream
				  nextPut: Character tab;
				  nextPutAll: '| x |';
				  cr.
			  stream
				  nextPut: Character tab;
				  nextPutAll: 'x := 1.';
				  cr.
			  stream
				  nextPut: Character tab;
				  nextPutAll: '^ x' ]
]

{ #category : 'settings' }
ASRArrowSyntaxInstaller class >> settingsOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #arrowSyntaxRendering)
		parent: #codeBrowsing;
		label: 'Render assignment and return as arrows';
		target: self;
		getSelector: #enabled;
		setSelector: #enabled:;
		default: false;
		description:
			'Display := as a left arrow and ^ as an up arrow in Smalltalk code editors without changing the stored source text.'
]

{ #category : 'styling' }
ASRArrowSyntaxInstaller class >> stylerForDecorator: aRubShoutStylerDecorator selectedClassOrMetaClass: aBehaviorOrNil [

	| textStyler |
	textStyler := self enabled
		              ifTrue: [ ASRArrowSyntaxTextStyler new ]
		              ifFalse: [
				              aBehaviorOrNil
					              ifNil: [ SHRBTextStyler new ]
					              ifNotNil: [ aBehaviorOrNil syntaxHighlighter ] ].
	aBehaviorOrNil ifNotNil: [
		textStyler classOrMetaClass: aBehaviorOrNil ].
	textStyler view: aRubShoutStylerDecorator.
	^ textStyler
]

{ #category : 'settings' }
ASRArrowSyntaxInstaller class >> toggle [

	| newValue |
	newValue := self enabled not.
	self enabled: newValue.
	^ newValue
]
