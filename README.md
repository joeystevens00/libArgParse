## libargparse.sh
Provides faster and easier argument parsing by generating the getopts code on run time    

### Usage
import the bash script   
```shell
source libargparse.sh
```

Then define the flags using setFlags. The expected syntax for setFlags is a comma seperated list where:    
1. is the flag to use     
2. is the variable that the flag will manipulate.     
3. how the flag will manipulate the variable    
  * Options:     
      * val - sets the variable to the paramater passed    
      * bool - sets the variable equal to 1 (default 0)  

4. sets if the flag is required or not   
   * Options:   
      * 1 - Required    
      * 0 - Not Required    

An example setting a val flag:    
```shell
setFlags u,url,val,1
```

Where the flag -u puts the paramater into $url and is required     

An example settings a bool flag:    
```shell
setFlags v,isVerbose,bool,0
```

Where the flag -v manipulates the variable $isVerbose to be 1 (otherwise isVerbose is 0) and the flag is optional     

setFlags also allows for defining multiple flags on one line by delimiting flag definitions by a space. E.g.    
```shell
setFlags c,isCSet,bool,0 b,isBSet,bool,0 a,isASet,bool,0
```   

After defining the flags simply call parseFlags and pass all arguments given by the user     
```shell
parseFlags "$@"
```




