#!/bin/bash

source "./xp-mode.sh"
source "./test/support.sh"

test "how to join an array of strings"

  names=()

  names+=("A")
  names+=("B")
  names+=("C")
  
  result="$(join "," $names)"

  mustBe "A,B,C" "$result"

test "how to join an array of strings that contain spaces"

  names=()

  names+=("A 1")
  names+=("B 2")
  names+=("C 3")
  
  result="" 

  result="$(join "," $names)"

  mustBe "A 1,B 2,C 3" "$result"

test "How to slice arrays"

  # https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion "If parameter is an indexed array name subscripted by ‘@’ or ‘*’"

  names=("ONE" "TWO" "THREE")

  mustBe "ONE" "${names[@]:0}"
  mustBe "TWO" "${names[@]:1}"
  mustBe "THREE" "${names[@]:2}"
  mustBe "THREE" "${names[@]: -1}"
  mustBe ""  "${names[@]:4}"

test "How to get all but the last item in an array"

  names=("ONE" "TWO" "THREE" "FOUR" "FIVE" "SIX" "SEVEN" "EIGHT")

  mustBe "ONE TWO THREE FOUR FIVE SIX SEVEN" "${names[*]: 0: (${#names[@]} - 1)}"

  # WHAT DOES THE "*" and "@" mean? 

  mustBe "ONE" "${names[@]: 0: (${#names[@]} - 1)}"
