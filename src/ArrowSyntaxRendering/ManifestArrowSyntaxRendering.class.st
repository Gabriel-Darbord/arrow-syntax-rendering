"
Package manifest for ArrowSyntaxRendering. The package renders assignment and return tokens as arrows in Rubric Smalltalk editors without changing stored source text.
"
Class {
	#name : 'ManifestArrowSyntaxRendering',
	#superclass : 'PackageManifest',
	#category : 'ArrowSyntaxRendering-Manifest',
	#package : 'ArrowSyntaxRendering',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestArrowSyntaxRendering class >> ruleExcessiveArgumentsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #( #( #( #RGMethodDefinition #( #ASRSubstitutionFont
	              #displayString:on:from:to:at:kern:baselineY:scale:
	              #false ) )
	        #'2026-05-29T17:22:21.289599+02:00' ) )
]
