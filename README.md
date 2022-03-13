# freja-with-usages

A collection of "usages" of [freja's](https://github.com/saikyun/freja)
functions (specific inputs and outputs).

## Why

Improve mental models of how freja works by executing specific usages
of freja's functions and observing the results.  (See
[Background](#background) section for further details.)

## Status

It's a work-in-progress because coverage of freja's code is not
complete.  Additionally, as freja changes, this repository might need
adjustment.

## Setup

* `git clone --recursive https://github.com/sogaiu/freja-with-usages`
* `cd freja-with-usages`
* `jpm run setup`

## Use

### General Instructions

To examine and interact with a "usage" - say via emacs + bash - try:

* `cd freja-with-usages` -- if not already in the repository root
* `JANET_PATH=$(pwd)/freja/jpm_tree/lib emacs freja/usages/events.janet`
* Evaluate a form that is immediately before a `# =>`
* Compare the result with the value of the expression after the `# =>`
* Possibly notice a change in your mental model(s)

### Specific Example

Suppose we come across the following [code in freja](https://github.com/saikyun/freja/blob/8583fa1a73d3754fe465f108d49496cc6bc3d570/freja/layout.janet#L122):

```
 (when (c/in-rec? mp [;pos ;(measure-text+ text :pos pos)])
```

Suppose further that we want to understand `in-rec?` better.

Looking earlier in the file, we might [find](https://github.com/saikyun/freja/blob/8583fa1a73d3754fe465f108d49496cc6bc3d570/freja/layout.janet#L4):

```
(import ./collision :as c)
```

That corresponds to an import of `freja/collision.janet` in freja.

Looking at the file `usages/freja/collision.janet` in the `freja-with-usages` repository there is:

```
(c/in-rec? [5 5] [0 0 10 10])
# =>
true
```

Note the form preceding `# =>`:

```
(c/in-rec? [5 5] [0 0 10 10])
```

and an expression after the `# =>` representing the expected value:

```
true
```

Such individual usages can be executed via one's editor or REPL.  Usages can also be modified to experiment and explore as well.  The hope is that this type of activity is likely to improve one's understanding of freja's functions.

On a side note, invoking `jpm test` from the repository root directory should execute all usages and produce output summarizing successes / failures.  This can be used to increase the chance that the usages stay up-to-date.

## Background

Sometimes docs and/or source code leave a bit too much to one's faulty
imagination.  One possible mitigation is examining relevant code and
corresponding evaluated results.

However, finding and/or setting up such code appropriately can be work
which the interested party may not be well-suited to as they are
unfamiliar with the code.

Additionally, as an uninformed reader, it's not clear whether the
candidate code expressions are appropriate (e.g. are the chosen inputs
typical?) nor whether the examined results are what the original
author would intend (e.g. because one might have encountered a bug or
unanticipated case).

This repository is an attempt to partially address this situation for
freja's source code.  Specifically, it aims to provide specific
invocations of appropriate forms along with intended results.

The hope is to eventually have enough code such that it can be an aid
to reading freja's source from the main entry point along a variety of
code paths.  The idea is that if one finds some bit of freja's source
code to be unclear, that there's a good chance that examining an
appropriate usage in this repository might help clarify things.

## Credits

* elimisteve
* saikyun

