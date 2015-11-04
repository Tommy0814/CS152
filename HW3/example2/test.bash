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

echo "---Changing timestamp of source should require jsmake to rebuild Employee.class"
sleep 1 # Calling sleep to make sure there is a difference in system time.
touch Employee.java
node jsmake.js
echo
ls *.class | more
echo

echo "---Calling jsmake to delete all class files"
node jsmake.js clean
echo
ls *.class | more
echo

echo "---Calling phony target"
node jsmake.js thisIsFake
echo

echo "---Calling phony target should still work if there is a file of the same name"
touch thisIsFake
node jsmake.js thisIsFake
echo

rm thisIsFake

