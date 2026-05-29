"
Smalltalk text styler that delegates normal Shout styling to SHRBTextStyler and then adds font substitutions for assignment and return tokens.
"
Class {
	#name : 'ASRArrowSyntaxTextStyler',
	#superclass : 'SHRBTextStyler',
	#category : 'ArrowSyntaxRendering-Core',
	#package : 'ArrowSyntaxRendering',
	#tag : 'Core'
}

{ #category : 'private' }
ASRArrowSyntaxTextStyler class >> attributesFor: aSymbol [

	^ SHRBTextStyler attributesFor: aSymbol
]

{ #category : 'initialization' }
ASRArrowSyntaxTextStyler class >> resetTextAttributesCaches [

	^ SHRBTextStyler resetTextAttributesCaches
]

{ #category : 'accessing' }
ASRArrowSyntaxTextStyler class >> styleTable [

	^ SHRBTextStyler styleTable
]

{ #category : 'styles' }
ASRArrowSyntaxTextStyler class >> styleTableName [

	^ SHRBTextStyler styleTableName
]

{ #category : 'accessing' }
ASRArrowSyntaxTextStyler class >> textAttributes [

	^ SHRBTextStyler textAttributes
]

{ #category : 'styling' }
ASRArrowSyntaxTextStyler >> addArrowRenderingTo: aText ast: ast [

	ast allChildren do: [ :node |
			node isAssignment ifTrue: [
				self addAssignmentRenderingFor: node in: aText ].
			node isReturn ifTrue: [ self addReturnRenderingFor: node in: aText ] ]
]

{ #category : 'styling' }
ASRArrowSyntaxTextStyler >> addAssignmentRenderingFor: anAssignmentNode in: aText [

	| start operator stop font |
	start := anAssignmentNode assignmentPosition.
	operator := anAssignmentNode assignmentOperator.
	operator = ':=' ifFalse: [ ^ self ].
	stop := start + operator size - 1.
	(self intervalFrom: start to: stop fitsIn: aText) ifFalse: [ ^ self ].
	font := ASRSubstitutionFont assignmentFontFor:
		        (self baseFontAt: start in: aText).
	aText
		addAttribute: (TextFontReference toFont: font)
		from: start
		to: stop
]

{ #category : 'styling' }
ASRArrowSyntaxTextStyler >> addReturnRenderingFor: aReturnNode in: aText [

	| start font |
	start := aReturnNode start.
	(self intervalFrom: start to: start fitsIn: aText) ifFalse: [ ^ self ].
	(aText at: start) = $^ ifFalse: [ ^ self ].
	font := ASRSubstitutionFont returnFontFor:
		        (self baseFontAt: start in: aText).
	aText
		addAttribute: (TextFontReference toFont: font)
		from: start
		to: start
]

{ #category : 'private' }
ASRArrowSyntaxTextStyler >> baseFontAt: anInteger in: aText [

	| style font |
	style := self textStyleForArrowRendering.
	font := aText fontAt: anInteger withStyle: style.
	^ ASRSubstitutionFont baseFontFor: font
]

{ #category : 'private' }
ASRArrowSyntaxTextStyler >> defaultTextStyle [

	^ ASRSubstitutionFont defaultBaseFont textStyle
]

{ #category : 'private' }
ASRArrowSyntaxTextStyler >> intervalFrom: start to: stop fitsIn: aText [

	^ start isInteger and: [
		  stop isInteger and: [ start >= 1 and: [ stop <= aText size ] ] ]
]

{ #category : 'private' }
ASRArrowSyntaxTextStyler >> style: aText ast: ast [

	| result |
	result := super style: aText ast: ast.
	self addArrowRenderingTo: aText ast: ast.
	^ result
]

{ #category : 'private' }
ASRArrowSyntaxTextStyler >> textStyleForArrowRendering [

	view ifNotNil: [ ^ view textStyle ].
	^ self defaultTextStyle
]
