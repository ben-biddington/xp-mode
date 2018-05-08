#!/bin/bash

function lastCommitMessageMustBe {
    theCommitMessage="$(git log --format=%B -n 1)"

    mustBe "$1" "$theCommitMessage"
}

# todo: assert this by only comparing the supplied lines
function lastCommitMustContain {
    expectedLines=$1
    theCommitMessage="$(git show --format=full)"

    echo "$theCommitMessage" 
    
    #mustBe "$1" "$theCommitMessage"
}
  
function commit {
    message=$1

    echo "No forks please" >> README.md

    $(git add README.md > /dev/null)
    $(git commit -am "$message" > /dev/null)
}
