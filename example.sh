#!/bin/bash
source libargparse.sh

setFlags u,url,val,1
setFlags a,isASet,bool,0
setFlags b,isBSet,bool,0
setFlags c,isCSet,bool,0
parseFlags "$@" 

echo "$url"
echo "$isASet"
echo "$isBSet"
echo "$isCSet"
