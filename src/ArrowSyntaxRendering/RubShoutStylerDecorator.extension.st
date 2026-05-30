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
			  styler := ASRArrowSyntaxInstaller
				            stylerForDecorator: self
				            selectedClassOrMetaClass:
				            (self model ifNotNil: [ :theModel |
					             theModel selectedClassOrMetaClass ]) ]
]
