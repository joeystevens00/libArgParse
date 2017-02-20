## libargparse.sh
Provides faster and easier argument parsing by generating the getopts code on run time    

### Usage
import the bash script   
```shell
source libargparse.sh
```
Then define the flags using setFlags and execute parseFlags 

### setFlags
setFlags expects a comma seperated list with 4 fields.    
#### Field 1
Specifies the flag to use     

#### Field 2
 Specifies the variable that the flag will manipulate.   

#### Field 3
 Specifies how the flag will manipulate the variable    
  * Options:     
      * val - sets the variable to the paramater passed    
      * bool - sets the variable equal to 1 (default 0)   

#### Fields 4
Sets if the flag is required or not   
   * Options:   
      * 1 - Required    
      * 0 - Not Required    

#### setFlags examples
An example defining a val flag
In this example a flag -u is defined that manipulates the variable $url with the value of the paramater passed to it and is a required field.  

Defining   
```shell
setFlags u,url,val,1
```

Now if the user executes      
```shell
./myexamplescript -u https://www.google.com
```
The variable $url will contain "https://www.google.com"

But if the user executes   
```shell
./myexamplescript 
```
'-u is required.' will be printed to STDOUT

An example settings a bool flag
In this example the flag -v is defined that manipulates the $isVerbose variable with the value of 1 

Defining      
```shell
setFlags v,isVerbose,bool,0
```

Now if the user executes   
```shell
./myexamplescript -v
```
The variable $isVerbose will contain 1

And if the user executes
```shell
./myexamplescript 
```
The variable $isVerbose will contain 0 and the script will continue normally as -v isn't a required flag


#### Multiline definitions 
setFlags also allows for defining multiple flags on one line by delimiting flag definitions by a space. E.g.    
```shell
setFlags c,isCSet,bool,0 b,isBSet,bool,0 a,isASet,bool,0
```   

### parseFlags 
parseFlags actually does the parsing of the flags. After the flags have been set with setFlags simply call parseFlags and pass all arguments given by the user     
```shell
parseFlags "$@"
```




