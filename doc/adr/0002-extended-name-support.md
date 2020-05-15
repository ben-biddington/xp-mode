# 2. Extended name support

Date: 2020-05-16

## Status

Possible

## Context

It would be nice to be able to support unambiguous full names in commit messages.

Our current format is:

```
Ben; ben@gmail.com
Lisa; lisa@gmail.com
Denny; denny@gmail.com
```

## Decision

Add support for a `.pairs` file in this format:

```
Ben; Ben Biddingtoin; ben@gmail.com
Lisa; Lisa Shickadance; lisa@gmail.com
Denny; Dan O'Donnell; denny@gmail.com
```

## Consequences

Adding the above format means enabling full names in commit messages.

instead of:

```
pair Ben,Lisa,Denny

gitAuthorMustEqual "Ben, Lisa and Denny" "denny@gmail.com"
```

You can have:

```
pair Ben,Lisa,Denny

gitAuthorMustEqual "Ben Biddington, Lisa Shikadance and Dan O'Donnell" "denny@gmail.com"

```
