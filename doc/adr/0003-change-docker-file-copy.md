# 3. Change docker file copy

Date: 2020-05-16

## Status

Accepted

## Context

I am getting errors when running this to copy test failures:

```
ben@bang:~/sauce/xp-mode$ sudo docker cp xp-mode-test:test-failures .tmp
unlinkat /home/ben/sauce/xp-mode/.tmp: permission denied
```

## Decision

try copying to pipe:

```
ben@bang:~/sauce/xp-mode$ sudo docker cp xp-mode-test:test-failures - >> .tmp
```

## Consequences

What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated.
