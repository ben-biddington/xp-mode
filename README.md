`xp-mode` makes it easier to record what pairs worked on what commits.

# Installation

On a POSIXish system:

```
curl https://raw.githubusercontent.com/ben-biddington/xp-mode/master/install.sh | bash && source xp-mode.sh
```

[Read what installer does](/install.sh)

For a windows cmd prompt:

```
curl https://raw.githubusercontent.com/ben-biddington/xp-mode/master/install.bat
curl https://raw.githubusercontent.com/ben-biddington/xp-mode/master/xp-mode.bat
.\install.bat
```

# Configuration

Add a `.pairs` file in your home directory.

Each row has two columns: author names and email address.

It is important to use one of your guests' email address so they are recorded as the author. As the host, you'll be recorded as the committer.
Author name may be whatever you like.

```
Ben Biddington        ; ben.biddington@gmail.com
Ben and Richard       ; richard.fortune@gmail.com
Ben and Gareth        ; gareth.keenan@aol.com
Ben and Danny         ; dan.ordinal@aol.com
Ben, Danny and Gareth ; gareth.keenan@aol.com
```

# Usage

Show your pairs by calling `pair` with no arguments:

```
$ pair
You have the following <5> pairs in file </home/ben/.pairs>:

[1] Ben Biddington; ben.biddington@gmail.com
[2] Ben and Richard; richard.fortune@gmail.com
[3] Ben and Gareth; gareth.keenan@aol.com
[4] Ben and Danny; dan.ordinal@aol.com
[5] Ben, Danny and Gareth; gareth.keenan@aol.com
```

The numbers indicate how to choose a pair.

## Example

To select `Ben and Richard`, use `pair 2`.

```
$ pair 2
Set GIT_AUTHOR_NAME=Ben and Richard
Set GIT_AUTHOR_EMAIL=richard.fortune@gmail.com

```

Next time you make a commit you'll see something like:

```
$ git show --format=full
commit e387396c587f9850a232cfbf66e7741a476737c4
Author: Ben and Richard <richard.fortune@gmail.com>
Commit: Ben Biddington <ben.biddington@gmail.com>

    Who says famine has to be depressing?

```

You can see that the pair has been recorded in the commit by setting author to `Ben and Richard <richard.fortune@gmail.com>` and the commiter to `Ben Biddington <ben.biddington@gmail.com>`. Handily it appears like this in github, too:

![](/toast.png)

# FAQ

* Setting persists only within the current terminal session

# Notes

* Bash function is the only practical way to set `GIT_AUTHOR_{NAME,EMAIL}`
* Also tried [git_scripts](https://github.com/ben-biddington/git_scripts/tree/f/optional_committer), but subshells are not suitable
* The only [git config](https://www.kernel.org/pub/software/scm/git/docs/git-config.html) options seem to be `user.name` and `user.email` which are used to set *both* author *and* committer. Temporarily setting them is not an option.
* Git hooks are no good either because they run in a child shell and cannot therefore affect the `GIT_AUTHOR_{NAME,EMAIL}` environment variables
