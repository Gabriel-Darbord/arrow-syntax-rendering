"
SUnit coverage for the arrow syntax font adapter, styler, installer, and global toggle behavior.
"
Class {
	#name : 'ASRArrowSyntaxRenderingTest',
	#superclass : 'TestCase',
	#category : 'ArrowSyntaxRendering-Tests-Tests',
	#package : 'ArrowSyntaxRendering-Tests',
	#tag : 'Tests'
}

{ #category : 'fixtures' }
ASRArrowSyntaxRenderingTest >> newScrolledTextMorphForSample [

	| model morph |
	model := RubScrolledTextModel new.
	model setInitialText: self sampleMethodSource asText.
	morph := RubScrolledTextMorph new.
	morph model: model.
	morph beForSmalltalkCode.
	^ morph
]

{ #category : 'fixtures' }
ASRArrowSyntaxRenderingTest >> newSmalltalkCodeDecorator [

	| morph |
	morph := self newScrolledTextMorphForSample.
	morph textArea withDecoratorNamed: #shoutStyler.
	^ morph textArea decoratorNamed: #shoutStyler
]

{ #category : 'fixtures' }
ASRArrowSyntaxRenderingTest >> newSmalltalkMethodDecoratorForObject [

	| morph decorator |
	morph := self newScrolledTextMorphForSample.
	morph textArea withDecoratorNamed: #shoutStyler.
	decorator := morph textArea decoratorNamed: #shoutStyler.
	decorator classOrMetaClass: Object.
	^ decorator
]

{ #category : 'fixtures' }
ASRArrowSyntaxRenderingTest >> parsedSampleMethod [

	^ OCParser parseFaultyMethod: self sampleMethodSource
]

{ #category : 'fixtures' }
ASRArrowSyntaxRenderingTest >> sampleAssignment [

	^ self parsedSampleMethod allChildren detect: [ :node |
		  node isAssignment ]
]

{ #category : 'fixtures' }
ASRArrowSyntaxRenderingTest >> sampleMethodSource [

	^ ASRArrowSyntaxInstaller sampleSource
]

{ #category : 'fixtures' }
ASRArrowSyntaxRenderingTest >> sampleReturn [

	^ self parsedSampleMethod allChildren detect: [ :node |
		  node isReturn ]
]

{ #category : 'fixtures' }
ASRArrowSyntaxRenderingTest >> styledSampleText [

	| text styler |
	text := self sampleMethodSource asText.
	styler := ASRArrowSyntaxTextStyler new.
	styler classOrMetaClass: Object.
	styler style: text ast: self parsedSampleMethod.
	^ text
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testArrowStylerDoesNotForceLightThemeDefaultColor [

	| attributes |
	attributes := ASRArrowSyntaxTextStyler attributesFor: #default.
	self assert: attributes notEmpty.
	self
		assert: attributes first
		equals: (SHRBTextStyler attributesFor: #default) first
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testArrowStylerUsesActiveShoutStyleTable [

	self
		assert: ASRArrowSyntaxTextStyler styleTableName
		equals: SHRBTextStyler styleTableName.
	self
		assert: (ASRArrowSyntaxTextStyler attributesFor: #default)
		equals: (SHRBTextStyler attributesFor: #default).
	self
		assert: (ASRArrowSyntaxTextStyler attributesFor: #selector)
		equals: (SHRBTextStyler attributesFor: #selector)
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testAssignmentOperatorGetsArrowFont [

	| text assignment font |
	text := self styledSampleText.
	assignment := self sampleAssignment.
	font := text
		        fontAt: assignment assignmentPosition
		        withStyle: ASRSubstitutionFont defaultBaseFont textStyle.
	self
		assert: (font displayCharacterFor: $:)
		equals: (Character value: 16r2190).
	self assert: (font widthOf: $=) equals: 0.
	self assert: (font widthOfString: ':=') equals: (font widthOf: $:)
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testGlobalToggleCanDisableForNewRubricDecorator [

	self withArrowRenderingEnabled: false do: [
			| decorator |
			decorator := self newSmalltalkCodeDecorator.
			self assert: decorator styler class equals: SHRBTextStyler ]
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testGlobalToggleCreatesArrowStylerForNewRubricDecorator [

	self withArrowRenderingEnabled: true do: [
			| decorator |
			decorator := self newSmalltalkCodeDecorator.
			self
				assert: decorator styler class
				equals: ASRArrowSyntaxTextStyler ]
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testGlobalTogglePreservesMethodClassWhenRefreshingExistingDecorator [

	self withArrowRenderingEnabled: false do: [
			| decorator text assignment assignmentFont |
			decorator := self newSmalltalkMethodDecoratorForObject.
			self assert: decorator styler class equals: SHRBTextStyler.
			ASRArrowSyntaxInstaller enabled: true.
			decorator refreshStyling.
			text := decorator text.
			assignment := self sampleAssignment.
			assignmentFont := text
				                  fontAt: assignment assignmentPosition
				                  withStyle:
				                  ASRSubstitutionFont defaultBaseFont textStyle.
			self
				assert: decorator styler class
				equals: ASRArrowSyntaxTextStyler.
			self
				assert: (assignmentFont displayCharacterFor: $:)
				equals: (Character value: 16r2190) ]
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testGlobalToggleRefreshesExistingRubricDecorator [

	self withArrowRenderingEnabled: false do: [
			| decorator |
			decorator := self newSmalltalkCodeDecorator.
			self assert: decorator styler class equals: SHRBTextStyler.
			ASRArrowSyntaxInstaller enabled: true.
			self
				assert: decorator styler class
				equals: ASRArrowSyntaxTextStyler.
			ASRArrowSyntaxInstaller enabled: false.
			self assert: decorator styler class equals: SHRBTextStyler ]
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testGlobalToggleRendersArrowsInMethodEditor [

	self withArrowRenderingEnabled: true do: [
			| decorator text assignment return assignmentFont returnFont |
			decorator := self newSmalltalkMethodDecoratorForObject.
			decorator refreshStyling.
			text := decorator text.
			assignment := self sampleAssignment.
			return := self sampleReturn.
			assignmentFont := text
				                  fontAt: assignment assignmentPosition
				                  withStyle:
				                  ASRSubstitutionFont defaultBaseFont textStyle.
			returnFont := text
				              fontAt: return start
				              withStyle:
				              ASRSubstitutionFont defaultBaseFont textStyle.
			self assert: text asString equals: self sampleMethodSource.
			self
				assert: (assignmentFont displayCharacterFor: $:)
				equals: (Character value: 16r2190).
			self
				assert: (returnFont displayCharacterFor: $^)
				equals: (Character value: 16r2191) ]
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testInstallerUsesArrowStyler [

	| morph decorator |
	morph := self newScrolledTextMorphForSample.
	decorator := ASRArrowSyntaxInstaller installOnScrolledTextMorph:
		             morph.
	self deny: decorator isNil.
	self assert: decorator styler class equals: ASRArrowSyntaxTextStyler.
	self assert: morph text asString equals: self sampleMethodSource
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testReturnGetsArrowFont [

	| text return font |
	text := self styledSampleText.
	return := self sampleReturn.
	font := text
		        fontAt: return start
		        withStyle: ASRSubstitutionFont defaultBaseFont textStyle.
	self
		assert: (font displayCharacterFor: $^)
		equals: (Character value: 16r2191)
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testSettingsDeclarationIsDiscoverable [

	self assert:
		((ASRArrowSyntaxInstaller class >> #settingsOn:) pragmas
			 anySatisfy: [ :pragma | pragma keyword = #systemsettings ])
]

{ #category : 'tests' }
ASRArrowSyntaxRenderingTest >> testStylingPreservesSourceString [

	| text |
	text := self styledSampleText.
	self assert: text asString equals: self sampleMethodSource
]

{ #category : 'fixtures' }
ASRArrowSyntaxRenderingTest >> withArrowRenderingEnabled: aBoolean do: aBlock [

	| oldValue |
	oldValue := ASRArrowSyntaxInstaller enabled.
	^ [
		  ASRArrowSyntaxInstaller enabled: aBoolean.
		  aBlock value ] ensure: [
		  ASRArrowSyntaxInstaller enabled: oldValue ]
]
