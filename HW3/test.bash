#!/bin/bash
touch tmp.class manifest.txt example.jar
rm *.class manifest.txt example.jar

echo "---Building jar file"
node jsmake.js
echo
ls *.class *.jar manifest.txt | more
echo

echo "---Executing jar"
node jsmake.js run
echo
ls *.class *.jar manifest.txt | more
echo

echo "---Cleaning"
node jsmake.js spotless
echo
ls *.class *.jar manifest.txt | more
echo

echo "---Redundant cleaning should not be an error"
node jsmake.js clean
echo

echo "---However, other errors should NOT be ignored"
node jsmake.js NoSuchClass.class
echo

echo "---Executing jar"
node jsmake.js run
echo

echo "---Cleaning"
node jsmake.js spotless
echo




