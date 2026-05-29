"
Metacello baseline for loading ArrowSyntaxRendering and its tests.
"
Class {
	#name : 'BaselineOfArrowSyntaxRendering',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfArrowSyntaxRendering-Baseline',
	#package : 'BaselineOfArrowSyntaxRendering',
	#tag : 'Baseline'
}

{ #category : 'baselines' }
BaselineOfArrowSyntaxRendering >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'ArrowSyntaxRendering';
				package: 'ArrowSyntaxRendering-Tests'
				with: [ spec requires: #( 'ArrowSyntaxRendering' ) ].
			spec
				group: 'default' with: #( 'ArrowSyntaxRendering' );
				group: 'tests' with: #( 'ArrowSyntaxRendering-Tests' );
				group: 'development' with: #( 'default' 'tests' ) ]
]
