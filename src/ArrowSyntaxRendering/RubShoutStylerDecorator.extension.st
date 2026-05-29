Extension { #name : 'RubShoutStylerDecorator' }

{ #category : '*ArrowSyntaxRendering' }
RubShoutStylerDecorator >> resetArrowSyntaxRenderingStyler [

	| previousClassOrMeta |
	previousClassOrMeta := styler ifNotNil: [
		                       styler arrowSyntaxClassOrMetaClass ].
	styler := nil.
	previousClassOrMeta ifNotNil: [
		self styler classOrMetaClass: previousClassOrMeta ].
	self refreshStyling
]

{ #category : '*ArrowSyntaxRendering' }
RubShoutStylerDecorator >> styler [
	"Answer the Shout styler, optionally using arrow rendering when ASRArrowSyntaxInstaller enables it."

	^ styler ifNil: [
			  | selectedClassOrMeta |
			  selectedClassOrMeta := nil.
			  styler := (self model isNotNil and: [
				             (selectedClassOrMeta := self model
					                                     selectedClassOrMetaClass)
					             isNotNil ])
				            ifTrue: [
						            ASRArrowSyntaxInstaller
							            stylerForDecorator: self
							            selectedClassOrMetaClass: selectedClassOrMeta ]
				            ifFalse: [
						            ASRArrowSyntaxInstaller
							            stylerForDecorator: self
							            selectedClassOrMetaClass: nil ] ]
]
