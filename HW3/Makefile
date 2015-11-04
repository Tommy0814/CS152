JAR_FILE=test.jar
MAIN_CLASS=Company

.PHONY: clean spotless run

${JAR_FILE}: Employee.class Company.class manifest.txt
	echo "Building ${JAR_FILE}"
	jar cvfm ${JAR_FILE} manifest.txt Employee.class Company.class

Employee.class: Employee.java
	javac Employee.java

Company.class: Company.java Employee.class
	javac Company.java

NoSuchClass.class: NoSuchClass.java
	javac NoSuchClass.java

manifest.txt:
	echo "Main-Class: ${MAIN_CLASS}" > manifest.txt

clean:
	echo "Removing class files and manifest, if any"
	-rm *.class manifest.txt

spotless: clean
	echo "Removing jar"
	-rm ${JAR_FILE}

run: ${JAR_FILE}
	java -jar ${JAR_FILE}

