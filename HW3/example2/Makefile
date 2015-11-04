
.PHONY: thisIsFake clean

Employee.class: Employee.java
	javac Employee.java

Company.class: Company.java Employee.class
	javac Company.java

thisIsFake:
	echo "Called fake target"

clean:
	rm *.class

