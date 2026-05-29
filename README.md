# ArrowSyntaxRendering

[![CI](https://github.com/Gabriel-Darbord/arrow-syntax-rendering/actions/workflows/ci.yml/badge.svg)](https://github.com/Gabriel-Darbord/arrow-syntax-rendering/actions/workflows/ci.yml)

ArrowSyntaxRendering is a tiny Pharo package that renders Smalltalk assignment and return tokens as arrows in Rubric code editors.

It changes display only:

- `:=` is rendered as `←`
- `^` is rendered as `↑`
- the stored source text remains normal Smalltalk

## Load

```smalltalk
Metacello new
	baseline: 'ArrowSyntaxRendering';
	repository: 'github://Gabriel-Darbord/arrow-syntax-rendering:main/src';
	load.
```

To load tests too:

```smalltalk
Metacello new
	baseline: 'ArrowSyntaxRendering';
	repository: 'github://Gabriel-Darbord/arrow-syntax-rendering:main/src';
	load: 'development'.
```

## Use

Enable or disable it from the Pharo settings browser under code browsing, or evaluate:

```smalltalk
ASRArrowSyntaxInstaller enable.
ASRArrowSyntaxInstaller disable.
ASRArrowSyntaxInstaller toggle.
```

## Test

```smalltalk
ASRArrowSyntaxRenderingTest suite run.
```
