var foldl = function (f, acc, array) {

	for (i = array.length-1; i >= 0; i--)
	{
		acc= f(acc, array[i]);
	}
	return acc;
}

console.log(foldl(function(x,y){return x+y}, 0, [1,2,3]));

var foldr = function (f, z, array) {
	for (i = 0; i < array.length ; i++)
	{
		z= f(z, array[i]);
	}
	return z;
}

console.log(foldl(function(x,y){return x/y}, 1, [2,4,8]));

var map = function (f, array) {
	var result = [];
	for (i = 0; i < array.length; i++)
	{
		result[i] = f(array[i]);
	}
	return result;
}

console.log(map(function(x){return x+x}, [1,2,3,5,7,9,11,13]));


// Write a curry function as we discussed in class.
// Create a `double` method using the curry function
// and the following `mult` function.
function mult(x,y) {
  return x * y;
}

function double(x){
	return function(){ 
		mult(x, 2);
	};
}




//Cat stuff

function Student(firstName, lastName, studentID)
{
	this.firstName = firstName;
	this.lastName = lastName;
	this.studentID = studentID;
	this.display = function(){console.log(firstName +' ' + lastName + ' ' + studentID);};
}

var students = [new Student('malik', 'khalil', 5), new Student('guy', 'haha', 2), new Student('dude', 'ecksDee', 1)];
students[0].graduated = false;

newStudent = {__proto__: students[1]};

newStudent.display();


console.log(students);
