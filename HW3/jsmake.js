const TARGET_PAT = /(.*):\s*(.*)/, //Company.class: Company.java Employee.class
      PHONY_PAT = /\.PHONY\s*:\s*(.*)/, //.PHONY: thisIsFake clean
      CMD_PAT = /^\t(.*)/, // javac Employee.java
      COMMENT_PAT = /#.*/, //#this is a comment
      ASSIGN_PAT = /\s*(.+?)\s*=\s*(.+)/, //JAR_FILE=test.jar
      VAR_PAT = /\$\{(.*?)\}/; //${JAR_FILE}

var fs = require('fs'),
    process = require('process'),
    eol = /\r?\n/,//require('os').EOL,
    execSync = require('child_process').execSync, //use this to execute system commands
    targets,//this is our list of targets that are in the makefile
    args,
    makeFileName = "Makefile",
    vars = {}; //hash of variable names to contents. Matches of ASSIGN_PAT

/**
 * Constructor function for a make target.
 * Every target has a name, a list of dependencies (that is, targets that
 * must be executed before this target), and a list of commands that must
 * be executed when the target is called.
 *
 * A phony target is invoked any time that it is called, unless it has
 * already been invoked for this call to make.  Other targets will be called
 * only when a file of the same name as the target does not exist, or if
 * the timestamp on the file is older than the timestamp of any file dependencies.
 *
 * Any command beginning with a '-' is tolerant of errors; if an error is encountered,
 * subsequent commands should still be executed.  If an error is encountered for
 * other commands, execution should terminate.
 */
function Target(name, dependencies, commands, phony) {
  this.name = name;
  this.dependencies = dependencies || []; //holds the string names of the dependencies. Get the Target objects from vars
  this.commands = commands || []; //commands are executed through execSync
  this.phony = phony || false;
}

// Recursively call every dependency of this target, and then apply
// the commands associated with the target.  You may find it worthwhile
// to add arguments to this function -- feel free to do so.
Target.prototype.invoke = function() {
  //
  // ***YOUR CODE HERE***
  //
  var variable = VAR_PAT.exec(this.name);
  if (variable != null){
    this.name = this.name.replace(VAR_PAT, vars[variable[1]]);
  }
  if (!this.phony){
    for (index in this.dependencies){
    for (index2 in targets){
      if (targets[index2].name === this.dependencies[index]){
        targets[index2].invoke();
      }
    }
   }
  var counter = 0;
  var real_dependencies = false;
  for (index in this.dependencies){
    if (fs.existsSync(this.name) && this.dependencies[index]!== ''){
      real_dependencies = true;
      cur_dep_stamp = fs.statSync(this.dependencies[index]).mtime.getTime();
      if (String(fs.statSync(this.name).mtime.getTime()) < String(cur_dep_stamp)){
        counter++;
      }
    }
  }
  if (counter == 0 && real_dependencies === true){
    console.log("jsmake: '" + this.name + "' is up to date");
    return;
  }
}
  //Call commands
  for (index2 in this.commands){
    var tolerant = this.commands[index2].startsWith('-');
    if (tolerant){
      this.commands[index2] = this.commands[index2].substring(1);
    }
    var variable = VAR_PAT.exec(this.commands[index2]);
    if (variable != null){
    this.commands[index2] = this.commands[index2].replace(VAR_PAT, vars[variable[1]]);
    }
    try {
      console.log(this.commands[index2]);
      var output = execSync(this.commands[index2]);
      if (output !== ''){
        console.log(output.toString().trim())
      }
    }
    catch(err){
      if (!tolerant){
        throw new Error('Intolerant command ' + this.commands[index2] + ' failed.');
        }
    }
  }
}

Target.prototype.addCommand = function(cmd) {
  //
  // ***YOUR CODE HERE***
  //
   this.commands.push(cmd)
}

// Read in a file and return a hash of targets.
function parse(fileName) {
  var i, lines, line, cmd, first, m, deps, target, targetName,
      phonies = [],
      makeTargets = {};
  lines = fs.readFileSync(fileName).toString().split(eol);
  for (i=0; i<lines.length; i++) { //loop through each line
    line = lines[i].replace(COMMENT_PAT, ''); //set "line" to be the current line and remove any comments
    if (line.match(PHONY_PAT)) { //everything with a "Real" value in javascript is considered true, so if there is a match
      phonies = line.match(PHONY_PAT)[1].split(/\s+/); //.match creates an array of strings that match the regex. m[0] is the actual match, m[1] is the first set of parentheses, m[2] is the second, and so on
    } else if (line.match(ASSIGN_PAT)) { //same situation as before
      m = line.match(ASSIGN_PAT);
      vars[m[1]] = m[2];
    } else if (line.match(CMD_PAT)) {//TODO
      if (!target) {//if there is no target object yet. This is possible because this is in a for loop
        console.error(fileName + ":" + (i+1) +
            ": *** commands commence before first target.  Stop.");
        process.exit(1); //there should never be commands that do not immediately follow a target, so abort
      }
      cmd = line.match(CMD_PAT)[1]; //it is [1] because that gets the contents of the first pair of parentheses instead of [0] which would get the actual regex match
      target.addCommand(cmd); //adds the command to the command list in the target object
    } else if (line.match(TARGET_PAT)) { //same again bit with the target pattern
      // Add previous target and start a new one
      if (target) makeTargets[target.name] = target; //makeTargets is a hash that stores the target objects by their names
      m = line.match(TARGET_PAT); //example: "Company.class: Company.java Employee.class".match(TARGET_PAT);
      targetName = m[1]; //m[1] = "Company.class"
      deps = m[2].split(/\s+/); //m[2] = "Company.java Employee.class"
      if (!first) first = targetName; //sets first to be the first TARGET_PAT found in the makefile. In example1, it should be "Employee.class"
      target = new Target(targetName, deps); //this is the only place in the loop that creates target. The other ifs are checking if this has happened yet.
    }
  }
  if (target) makeTargets[target.name] = target; 
  else {
    console.error("jsmake: *** No targets.  Stop.");
    process.exit(1);
  }
  return [makeTargets, first];
}

//***EXECUTION STARTS HERE***

// Handling command-line arguments
args = process.argv
if (args[0].match(/\bnode/)) args.shift(); // Drop node command
args.shift(); // drop script name
if (args[0] === '-f') {
  args.shift(); // drop '-f'
  makeFileName = args.shift();
}

fs.exists(makeFileName, function(exists) {
  var first, res, i, t;
  if (exists) {
    res = parse(makeFileName); 
    targets = res[0]; 
    first = res[1];
    if (args.length === 0) { 
      targets[first].invoke();
    } else { 
      for (i in args) { 
        t = args[i];
        if (targets.hasOwnProperty(t)) targets[t].invoke(); 
        else console.error("jsmake: *** No rule to make target `" + t + "'.  Stop.");
      }
    }
  } else {
    console.error('jsmake: *** No targets specified and no makefile found.  Stop.');
  }
});