## Real names in hooks

```
commit 3bb7a922d29be7c52634081cf040fb3580be657c (HEAD -> master)
Author: Ben, Lisa Shickadance and Denny <denny@gmail.com>
Date:   Sun May 17 10:03:35 2020 +1200

    Refactor: clarify
    
    Co-authored-by: Mob <lisa@gmail.com>
    Co-authored-by: Mob <denny@gmail.com>
```

It would be nice to have `Co-authored-by: Lisa Shickadance <lisa@gmail.com>`.

## Deduplicate trailers when amending

If you amend a commit, you get the trailers added twice.