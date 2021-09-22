# 5. Use the interpret-trailers git command

Date: 2021-09-22

## Status

Accepted

## Context

The [`interpret-trailers` command](`https://www.git-scm.com/docs/git-interpret-trailers`) is intended for adding trailers so I thought I'd try it.

It is a good thing to try because it supports flags like `--if-exists`.

Not sure what version of git is required, though.

## Decision

Add the trailers with `git interpret-trailers` and see if it works everywhere.

## Consequences

We now don't get duplicate trailers added when doing interactive amend, due to the `--if-exists="addIfDifferent"` flag.

```sh
# ./xp-mode.sh
git interpret-trailers --trim-empty --in-place --if-exists="addIfDifferent" --trailer "Co-authored-by: $(get-full-name "$email") <$email>" "$1" >> $commitMsg
```

This means we don't have to implement it ourselves.
