#!/usr/bin/tcsh

echo "gpl-apply [-author <author name> ] [-open <open comment string>] [-close <close comment string>] [-license <license file name>] [-ext <ext of files>] [target dir]"

set OPEN="/*"
set CLOSE="*/"
set AUTHOR=""
set DIR="."
set LICENSE="LICENSE"
set COP="Copyright (C) 2012 -- "
set EXT=""
set CHAR=""

while ( "$1" != "" )
   if ( "$1" == "-author" ) then
      shift
      set AUTHOR="$1" 
      shift
      continue
   endif
   if ( "$1" == "-openchar" ) then
      shift
      set CHAR="$1"
      shift
      continue
   endif
   if ( "$1" == "-open" ) then
      shift
      set OPEN="$1"
      shift
      continue
   endif
   if ( "$1" == "-close" ) then
      shift
      set CLOSE="$1"
      shift
      continue
   endif
   if ( "$1" == "-license" ) then
      shift
      set LICENSE="$1"
      shift
      continue
   endif
   if ( "$1" == "-ext" ) then
      shift
      set EXT=$1
      shift
      continue
   endif
    set DIR=$1
   shift
end
   if ( $EXT == "" ) then
      echo "******* Que tipo de arquivo?"
      exit
   endif

   set x=0
   foreach f (`find $DIR -name \*$EXT -print`)
      set firstL=`head -n 1 $f`
#      echo "$firstL"
#      echo "$OPEN $COP$AUTHOR"
#      @ x="$firstL" == "$OPEN $COP$AUTHOR"
#      echo ">>> $x"
      if ( "$firstL" == "$OPEN $COP$AUTHOR" ) then
         echo "****** Arquivo $f ja assinado"
         continue
      endif
      set aux=$DIR/xxx
      echo -n "$OPEN " >$aux
      echo "$COP$AUTHOR" >>$aux
      set x="'"'{print "'$CHAR'", $0\'"'"
      awk '{print "#", $0}' ./GPL.txt >>$aux
      echo "$CLOSE" >>$aux
      echo "" >>$aux
      echo "" >>$aux
      cat $f >>$aux  
      rm $f
      mv $aux $f
      echo "Gerado $f"
   end

cp LICENSE $DIR/$LICENSE
cp README $DIR



