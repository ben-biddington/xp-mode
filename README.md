[![Status](https://api.travis-ci.org/ben-biddington/xp-mode.svg)](https://travis-ci.org/ben-biddington/xp-mode)

`xp-mode` makes it easier to record what pairs worked on what commits.

# Installation

On a POSIXish system:

```
curl https://raw.githubusercontent.com/ben-biddington/xp-mode/master/install.sh | bash && source ~/xp-mode.sh 
```

[Read what installer does](/install.sh)

## Automatic update

Run `pair update`

```
ben@bang:~/sauce/xp-mode$ pair update 
Running the following in 5s: curl https://raw.githubusercontent.com/ben-biddington/xp-mode/master/install.sh | bash && source ~/xp-mode.sh
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1481  100  1481    0     0    778      0  0:00:01  0:00:01 --:--:--   777
Installing xp-mode to </home/ben>
Deleting file at </home/ben/xp-mode.sh>
Downloading <https://raw.githubusercontent.com/ben-biddington/xp-mode/master/xp-mode.sh> to </home/ben/xp-mode.sh>
Pairs file already exists at </home/ben/.xp-mode/pairs>
People file already exists at </home/ben/.xp-mode/people>
```

# Configuration

After installation you have a `~/.xp-mode/people` file.

Add authors to it in this format:

```
Ben; ben@gmail.com
Lisa; lisa@gmail.com
Denny; denny@gmail.com
```

Include yourself to make it so you can just use the names of all the people in the group.

## Full names

You may also use full names by adding a second field.

```
Ben;                    ben@gmail.com
Lisa; Lisa Shickadance; lisa@gmail.com
Denny;                  denny@gmail.com
```

# Options

[Configure a `commit-msg` hook](https://github.com/ben-biddington/xp-mode/blob/master/test/installing-hooks-checks.sh):

```
$ pair hooks
```

This adds [`Co-authored-by` trailers](https://blog.github.com/2018-01-29-commit-together-with-co-authors) to your commit messages. [If you already have a `commit-msg` hook configured, it is left alone](https://github.com/ben-biddington/xp-mode/blob/master/test/installing-hooks-checks.sh).

Turn hooks off with:

```
$ pair hooks -d
```

# Usage

I am Ben and I am about to work with Lisa and Denny.

```
$ pair Ben,Lisa,Denny
```

* [Author name is the names of the people you selected](https://github.com/ben-biddington/xp-mode/blob/master/test/select-by-name-checks.sh)
* [Author email is the email address of the last person in the list you selected](https://github.com/ben-biddington/xp-mode/blob/master/test/select-by-name-checks.sh)
* [Committer is set to whatever you have set as git config `user.name` and `user.email`](https://github.com/ben-biddington/xp-mode/blob/master/test/select-by-name-checks.sh)

```
commit 402c410f89947c88e3d4e42aefe199cf06917056
Author: Ben, Lisa and Denny <denny@gmail.com>
Commit: Ben Biddington <ben@gmail.com>

    Push to master
```

or with full names:

```
commit 402c410f89947c88e3d4e42aefe199cf06917056
Author: Ben, Lisa Shickadance and Denny <denny@gmail.com>
Commit: Ben Biddington <ben@gmail.com>

    Push to master
```

[When you have hooks enabled, you get extra `Co-authored-by` trailers in your commits](https://github.com/ben-biddington/xp-mode/blob/master/test/commit-msg-hook-usage-checks.sh):

```
commit 7de767f5e59e154c705bee8de7413529dc287ab5
Author: Ben, Lisa and Denny <denny@gmail.com>
Commit: Ben Biddington <ben@gmail.com>

    And use small batches
    
    Co-authored-by: Mob <ben@gmail.com>
    Co-authored-by: Mob <lisa@gmail.com>
    Co-authored-by: Mob <denny@gmail.com>

```

To [revert to normal operation](https://github.com/ben-biddington/xp-mode/blob/master/test/select-by-name-checks.sh):

```
pair solo
```

# FAQ

* Setting persists only within the current terminal session

# Notes

* Bash function is the only practical way to set `GIT_AUTHOR_{NAME,EMAIL}`
* Also tried [git_scripts](https://github.com/ben-biddington/git_scripts/tree/f/optional_committer), but subshells are not suitable
* The only [git config](https://www.kernel.org/pub/software/scm/git/docs/git-config.html) options seem to be `user.name` and `user.email` which are used to set *both* author *and* committer. Temporarily setting them is not an option.
* Git hooks are no good either because they run in a child shell and cannot therefore affect the `GIT_AUTHOR_{NAME,EMAIL}` environment variables


