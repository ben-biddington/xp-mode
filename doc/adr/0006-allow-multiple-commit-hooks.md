# 6. Allow multiple commit hooks

Date: 2025-08-16

## Status

Accepted

## Context

When you run `pair hooks`, `xp-mode` tries to write a file to `.git/hooks/commit-msg` containing logic to be run when a commit is made.

This file _only_ gets written if one does not already exist.

There may be cases where we need two completely different sets of behaviour which both require their own hook logic.

For example, you may have a script that automatically adds a ticket number to the commit message.

### Husky and `core.hookspath`

`Husky` uses the `core.hookspath` git config option to instruct git to use its custom hooks.

## Decision

Use `core.hookspath` to find the path to the `commit-msg` file, and then rather than embedding the entirety of the script in there, just call another file.

### Use `core.hookspath` when installing hook

Now when we install the hook, we find the file to update by inspecting `core.hookspath`.

```sh
# test/installing-hooks-checks.sh
test "it honours <core.hookspath> git configuration"
  mkdir custom-hooks-dir

  git config core.hookspath ./custom-hooks-dir

  pair hooks

  fileMustExist "$tempDir/custom-hooks-dir/commit-msg"

  fileMustContain "#xp-mode" "$tempDir/custom-hooks-dir/commit-msg"

  after_each
```

### Use script reference instead of inlining

The `commit-msg` hook file may contain other behaviour that we don't want to break, so if we can add a single line then it is easier to remove.

## Consequences

What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated.
