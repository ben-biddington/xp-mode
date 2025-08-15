# 6. Allow multiple commit hooks

Date: 2025-08-16

## Status

Accepted

## Context

When you run `pair hooks`, `xp-mode` tries to write a file to `.git/hooks/commit-msg` containing logic to be run when a commit is made.

This file _only_ gets written if one does not already exist.

There may be cases where we need two completely different sets of behaviour which both require their own hook logic.

For example, you may have a script that automatically adds a ticket number to the commit message.

## Decision

The change that we're proposing or have agreed to implement.

## Consequences

What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated.
