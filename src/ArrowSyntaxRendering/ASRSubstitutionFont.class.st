"
Wraps a real font and substitutes selected source characters while preserving source text. It is used by the arrow syntax styler to render := and ^ with display glyphs only.
"
Class {
	#name : 'ASRSubstitutionFont',
	#superclass : 'AbstractFont',
	#instVars : [
		'baseFont',
		'characterMap',
		'hiddenCharacters'
	],
	#category : 'ArrowSyntaxRendering-Core',
	#package : 'ArrowSyntaxRendering',
	#tag : 'Core'
}

{ #category : 'instance creation' }
ASRSubstitutionFont class >> assignmentFontFor: aFont [

	| map |
	map := Dictionary new.
	map at: $: put: (Character value: 16r2190).
	^ self
		  baseFont: (self baseFontFor: aFont)
		  characterMap: map
		  hiddenCharacters: (Set with: $=)
]

{ #category : 'instance creation' }
ASRSubstitutionFont class >> baseFont: aFont characterMap: aDictionary hiddenCharacters: aCollection [

	^ self new
		  baseFont: aFont;
		  characterMap: aDictionary;
		  hiddenCharacters: aCollection;
		  yourself
]

{ #category : 'instance creation' }
ASRSubstitutionFont class >> baseFontFor: aFont [

	aFont ifNil: [ ^ self defaultBaseFont ].
	^ aFont asArrowSyntaxBaseFont
]

{ #category : 'accessing' }
ASRSubstitutionFont class >> defaultBaseFont [

	^ StandardFonts codeFont
]

{ #category : 'instance creation' }
ASRSubstitutionFont class >> returnFontFor: aFont [

	| map |
	map := Dictionary new.
	map at: $^ put: (Character value: 16r2191).
	^ self
		  baseFont: (self baseFontFor: aFont)
		  characterMap: map
		  hiddenCharacters: Set new
]

{ #category : 'comparing' }
ASRSubstitutionFont >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	^ anObject class == self class and: [
			  self baseFont = anObject baseFont and: [
					  self characterMap = anObject characterMap and: [
						  self hiddenCharacters = anObject hiddenCharacters ] ] ]
]

{ #category : 'converting' }
ASRSubstitutionFont >> asArrowSyntaxBaseFont [

	^ self baseFont
]

{ #category : 'accessing' }
ASRSubstitutionFont >> ascent [

	^ self baseFont ascent
]

{ #category : 'accessing' }
ASRSubstitutionFont >> baseFont [

	^ baseFont ifNil: [ self defaultBaseFont ]
]

{ #category : 'accessing' }
ASRSubstitutionFont >> baseFont: aFont [

	baseFont := aFont ifNil: [ self defaultBaseFont ]
]

{ #category : 'accessing' }
ASRSubstitutionFont >> baseKern [

	^ self baseFont baseKern
]

{ #category : 'glyph lookup' }
ASRSubstitutionFont >> characterFormAt: aCharacter [

	^ self baseFont characterFormAt:
		  (self displayCharacterFor: aCharacter)
]

{ #category : 'accessing' }
ASRSubstitutionFont >> characterMap [

	^ characterMap ifNil: [ Dictionary new ]
]

{ #category : 'accessing' }
ASRSubstitutionFont >> characterMap: aDictionary [

	characterMap := aDictionary ifNil: [ Dictionary new ]
]

{ #category : 'accessing' }
ASRSubstitutionFont >> defaultBaseFont [

	^ self class defaultBaseFont
]

{ #category : 'accessing' }
ASRSubstitutionFont >> descent [

	^ self baseFont descent
]

{ #category : 'accessing' }
ASRSubstitutionFont >> descentKern [

	^ self baseFont descentKern
]

{ #category : 'mapping' }
ASRSubstitutionFont >> displayCharacterFor: aCharacter [

	^ self characterMap at: aCharacter ifAbsent: [ aCharacter ]
]

{ #category : 'displaying' }
ASRSubstitutionFont >> displayString: aString on: aDisplayContext from: startIndex to: stopIndex at: aPoint kern: kernDelta baselineY: baselineY scale: scale [
	"Required AbstractFont display protocol; Rubric calls this selector directly."

	| destination widthAndKernedWidth char mappedString nextChar unscaledAdvance advance |
	destination := aPoint.
	widthAndKernedWidth := Array new: 2.
	startIndex to: stopIndex do: [ :index |
			char := aString at: index.
			(self hides: char) ifFalse: [
					mappedString := String with: (self displayCharacterFor: char).
					self baseFont
						displayString: mappedString
						on: aDisplayContext
						from: 1
						to: 1
						at: destination
						kern: 0
						baselineY: baselineY
						scale: scale ].
			nextChar := index < stopIndex ifTrue: [ aString at: index + 1 ].
			self
				widthAndKernedWidthOfLeft: char
				right: nextChar
				into: widthAndKernedWidth.
			unscaledAdvance := (widthAndKernedWidth at: 2) + kernDelta.
			advance := unscaledAdvance * scale.
			destination := destination x + advance @ destination y ].
	^ destination x @ baselineY
]

{ #category : 'emphasis' }
ASRSubstitutionFont >> emphasized: emphasisCode [

	emphasisCode = 0 ifTrue: [ ^ self ].
	^ self class
		  baseFont: (self baseFont emphasized: emphasisCode)
		  characterMap: self characterMap copy
		  hiddenCharacters: self hiddenCharacters copy
]

{ #category : 'accessing' }
ASRSubstitutionFont >> familyName [

	^ self baseFont familyName
]

{ #category : 'comparing' }
ASRSubstitutionFont >> hash [

	^ (self baseFont hash bitXor: self characterMap hash) bitXor:
		  self hiddenCharacters hash
]

{ #category : 'accessing' }
ASRSubstitutionFont >> height [

	^ self baseFont height
]

{ #category : 'accessing' }
ASRSubstitutionFont >> hiddenCharacters [

	^ hiddenCharacters ifNil: [ Set new ]
]

{ #category : 'accessing' }
ASRSubstitutionFont >> hiddenCharacters: aCollection [

	hiddenCharacters := aCollection
		                    ifNil: [ Set new ]
		                    ifNotNil: [ aCollection asSet ]
]

{ #category : 'mapping' }
ASRSubstitutionFont >> hides: aCharacter [

	^ self hiddenCharacters includes: aCharacter
]

{ #category : 'initialization' }
ASRSubstitutionFont >> initialize [

	super initialize.
	baseFont := self defaultBaseFont.
	characterMap := Dictionary new.
	hiddenCharacters := Set new
]

{ #category : 'displaying' }
ASRSubstitutionFont >> installOn: aDisplayContext foregroundColor: foregroundColor backgroundColor: backgroundColor scale: scale [

	^ self baseFont
		  installOn: aDisplayContext
		  foregroundColor: foregroundColor
		  backgroundColor: backgroundColor
		  scale: scale
]

{ #category : 'measuring' }
ASRSubstitutionFont >> kerningLeft: leftCharacter right: rightCharacter [

	(self hides: leftCharacter) ifTrue: [ ^ 0 ].
	rightCharacter ifNil: [ ^ 0 ].
	(self hides: rightCharacter) ifTrue: [ ^ 0 ].
	^ self baseFont
		  kerningLeft: (self displayCharacterFor: leftCharacter)
		  right: (self displayCharacterFor: rightCharacter)
]

{ #category : 'accessing' }
ASRSubstitutionFont >> lineGrid [

	^ self baseFont lineGrid
]

{ #category : 'accessing' }
ASRSubstitutionFont >> pointSize [

	^ self baseFont pointSize
]

{ #category : 'printing' }
ASRSubstitutionFont >> printOn: aStream [

	aStream
		nextPutAll: self class name asString;
		nextPutAll: '(';
		print: self baseFont;
		nextPutAll: ')'
]

{ #category : 'measuring' }
ASRSubstitutionFont >> widthAndKernedWidthOfLeft: leftCharacter right: rightCharacterOrNil into: aTwoElementArray [

	| width kernedWidth |
	width := self widthOf: leftCharacter.
	kernedWidth := rightCharacterOrNil ifNil: [ width ] ifNotNil: [
		               width
		               +
		               (self
			                kerningLeft: leftCharacter
			                right: rightCharacterOrNil) ].
	aTwoElementArray
		at: 1 put: width;
		at: 2 put: kernedWidth.
	^ aTwoElementArray
]

{ #category : 'measuring' }
ASRSubstitutionFont >> widthOf: aCharacter [

	(self hides: aCharacter) ifTrue: [ ^ 0 ].
	^ self baseFont widthOf: (self displayCharacterFor: aCharacter)
]
