#!/bin/bash
touch tmp.class # Creating a class file so that there is always one to delete
rm *.class

echo "---Calling jsmake with no arguments"
node jsmake.js
echo
ls *.class | more
echo

echo "---Calling jsmake again; nothing should happen"
node jsmake.js
echo
ls *.class | more
echo

echo "---Calling jsmake to delete all class files"
node jsmake.js clean
echo
ls *.class | more
echo

echo "---Calling jsmake to build Company.class"
node jsmake.js Company.class
echo
ls *.class | more
echo

java Company
echo

echo "---Calling jsmake to delete all class files"
node jsmake.js clean
echo
ls *.class | more
echo


