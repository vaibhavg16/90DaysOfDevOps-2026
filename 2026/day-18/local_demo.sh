#!/bin/bash

with_local() {
	local name="vaibhav" # exists ONLY inside this function
	echo "Inside with_local: name = $name" # prints: Vaibhav
}

without_local() {
	name="vaibhav"  # this sets a GLOBAL variable
	echo "Inside without_local name = $name" # prints: Vaibhav
}

echo "=== Testing Local Variable ==="

with_local
echo "Outside with_local: name: = ${name:-not set}" # if $name is empty or undefined, use "not set" as fallback.

echo ""

echo "=== Testing Without Local Variable ==="

without_local
echo "Outside local: name='$name'" # prints: Vaibhav   ← leaks out!


