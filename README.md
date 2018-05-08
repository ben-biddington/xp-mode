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

After installation you have the `~/.xp-mode` directory. It contains a `people` file.

Add authors in the `people` file, for example:

```
Ben; ben.biddington@gmail.com
Richard; richard.fortune@gmail.com
Denny; denny@gmail.com
```

# Options

Configure a `commit-msg` hook:

```
$ pair hooks
```

When used with the pair-by-name mode, this adds co-authored-by trailers to your commit messages.

# Usage

```
$ pair Denny,Richard
```

* The person last in the list has their email address used, and everyone in the group has their name added.
* Committer is set to whatever you have set as git config `user.name` and `user.email`.

```

Set GIT_AUTHOR_NAME=Ben, Richard, Denny
Set GIT_AUTHOR_EMAIL=denny@gmail.com
Author is now <Ben, Richard, Denny; denny@gmail.com>
Committer is now <Ben Biddington; ben@gmail.com>
commit 402c410f89947c88e3d4e42aefe199cf06917056
Author: Ben, Richard, Denny <denny@gmail.com>
Commit: Ben Biddington <ben@gmail.com>

    Push to master

```      

# FAQ

* Setting persists only within the current terminal session

# Notes

* Bash function is the only practical way to set `GIT_AUTHOR_{NAME,EMAIL}`
* Also tried [git_scripts](https://github.com/ben-biddington/git_scripts/tree/f/optional_committer), but subshells are not suitable
* The only [git config](https://www.kernel.org/pub/software/scm/git/docs/git-config.html) options seem to be `user.name` and `user.email` which are used to set *both* author *and* committer. Temporarily setting them is not an option.
* Git hooks are no good either because they run in a child shell and cannot therefore affect the `GIT_AUTHOR_{NAME,EMAIL}` environment variables


