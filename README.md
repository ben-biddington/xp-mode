[![Status](https://api.travis-ci.org/ben-biddington/xp-mode.svg)](https://travis-ci.org/ben-biddington/xp-mode)

`xp-mode` makes it easier to record what pairs worked on what commits.

# Installation

On a POSIXish system:

```
curl https://raw.githubusercontent.com/ben-biddington/xp-mode/master/install.sh | bash && source ~/xp-mode.sh 
```

[Read what installer does](/install.sh)

For a windows cmd prompt:

```
curl https://raw.githubusercontent.com/ben-biddington/xp-mode/master/install.bat
curl https://raw.githubusercontent.com/ben-biddington/xp-mode/master/xp-mode.bat
.\install.bat
```

# Configuration

After installation you have a `~/.xp-mode/people` file.

Add authors to it in this format:

```
Ben; ben@gmail.com
Richard; richard@gmail.com
Denny; denny@gmail.com
```

# Options

[Configure a `commit-msg` hook](https://github.com/ben-biddington/xp-mode/blob/master/test/installing-hooks-checks.sh):

```
$ pair hooks
```

This adds `Co-authored-by` trailers to your commit messages. If you already have a `commit-msg` hook configured, `pair hooks` leaves it alone.

Turn hooks off with:

```
$ pair hooks -d
```

# Usage

```
$ pair Ben,Denny,Richard
```

* [Author name is the names of the people you selected](https://github.com/ben-biddington/xp-mode/blob/master/test/select-by-name-checks.sh)
* [Author email is the email address of the last person in the list you selected](https://github.com/ben-biddington/xp-mode/blob/master/test/select-by-name-checks.sh)
* [Committer is set to whatever you have set as git config `user.name` and `user.email`](https://github.com/ben-biddington/xp-mode/blob/master/test/select-by-name-checks.sh)

```
commit 402c410f89947c88e3d4e42aefe199cf06917056
Author: Ben, Richard, Denny <denny@gmail.com>
Commit: Ben Biddington <ben@gmail.com>

    Push to master

```

[When you have hooks enabled, you get extra `Co-authored-by` trailers in your commits](https://github.com/ben-biddington/xp-mode/blob/master/test/commit-msg-hook-usage-checks.sh):

Enable hooks with `pair hooks`. Disable them with `pair hooks -d`.

```
commit 7de767f5e59e154c705bee8de7413529dc287ab5
Author: Ben, Richard, Denny <denny@gmail.com>
Commit: Ben Biddington <ben@gmail.com>

    And use small batches
    
    Co-authored-by: Mob <ben@gmail.com>
    Co-authored-by: Mob <richard@gmail.com>
    Co-authored-by: Mob <denny@gmail.com>

```

To revert to normal operation:

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


