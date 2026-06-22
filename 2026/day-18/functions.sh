#!/bin/bash

greet() {
	echo "Hello, $1"
}

add () {
	result=$(( $1 + $2 ))
	echo "Sum of $1 + $2 = $result"
}

greet "vaibhav"
add 10 20
