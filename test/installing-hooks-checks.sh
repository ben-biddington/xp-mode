#!/bin/bash

source "$(dirname $0)/support.sh"
source "$(dirname $0)/support.git.sh"

function before_each {
    git config --global user.name "The Bizzz"
    git config --global user.email "the.emerald.bizz@gmail.com"

    clobber $filename
    clobber $peopleFilename

    tempDir=$(newTemporaryGitRepository)

    SKIP_DOWNLOAD=1 bash install.sh
    
    source xp-mode.sh

    cd $tempDir > /dev/null
}

function after_each {
    cd - >> /dev/null

    debug "Deleting <$tempDir>"; rm -r $tempDir

    debug "Current directory is now <$(pwd)>"
}

test "it makes a hook file and it has the #xp-mode tag in it"

  pair hooks

  cat "$tempDir/.git/hooks/commit-msg"

  fileMustExist "$tempDir/.git/hooks/commit-msg"

  fileMustContain "#xp-mode" "$tempDir/.git/hooks/commit-msg"
  
  after_each

# [!] Putting it at the start because Husky exits early, preventing subsequent scripts form running, so adding at the end does nothing
test "it appends to the beginning of an existing commit-msg hook"

  echo "#!/bin/bash" >> "$tempDir/.git/hooks/commit-msg"
  echo "ABC" >> "$tempDir/.git/hooks/commit-msg"
  echo "DEF" >> "$tempDir/.git/hooks/commit-msg"

  pair hooks

  expected="#!/bin/bash
$HOME/.xp-mode/git-hooks/commit-msg \$1 #xp-mode
ABC
DEF"

  fileMustEqual "$expected" "$tempDir/.git/hooks/commit-msg"
  
  after_each

test "it creates hook file in <\$HOME/.xp-mode> so we can reference it instead of inlining it"

  pair hooks

  fileMustExist "$HOME/.xp-mode/git-hooks/commit-msg"

  fileMustContain "#xp-mode" "$HOME/.xp-mode/git-hooks/commit-msg"
  
  after_each

test "it honours <core.hookspath> git configuration"
  mkdir custom-hooks-dir 
  
  git config core.hookspath ./custom-hooks-dir
  
  pair hooks

  fileMustExist "$tempDir/custom-hooks-dir/commit-msg"

  fileMustContain "#xp-mode" "$tempDir/custom-hooks-dir/commit-msg"
  
  after_each

test "it skips if it one is already present"

  touch "$tempDir/.git/hooks/commit-msg"

  result=$(pair hooks)

  mustMatch "You already have a commit-msg hook" "$result"
  
  after_each

test "Use \`hooks -d\` to remove xp-mode reference, leaving the rest of the file alone"

  echo "ABC" >> "$tempDir/.git/hooks/commit-msg"

  pair hooks

  pair hooks -d

  fileMustExist "$tempDir/.git/hooks/commit-msg"

  fileMustContain "ABC" "$tempDir/.git/hooks/commit-msg"
  fileMustNotContain "#xp-mode" "$tempDir/.git/hooks/commit-msg"

  after_each

test "it skips if the hook file does not exist"

  clobber "$tempDir/.git/hooks/commit-msg"

  result=$(pair hooks -d)

  mustMatch "nothing to delete" "$result"

  after_each
  
