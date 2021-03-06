#!/bin/bash

#Author : Tomislav Balabanov
#Version: 1.0 2018 Aug.
<< --Discription--
Script that will search in all direcotires and subdirectories for potential .ico malware files and injected php files and the script will print the results in console.
--Discription--
clear

mkdir report
mkdir report/additional_report
mkdir report/suspicious
echo "Script started!"
sleep 3
echo


#Find all malware files
echo -e ">Finding .ico malware files"
sleep 4
echo
find . -type f -name '*.ico' > foundMalware.txt
echo "Printing .ico malware files:"
echo
cat foundMalware.txt
echo

#Find all injected files
echo -e "Finding all injected php files"
sleep 4
echo
grep -rnw @import > injectedFiles.txt
echo "Printing all injected files:"
echo
cat injectedFiles.txt
echo


#Find other suspicius files
echo "Trying to find other suspicious files"
find . -type f | egrep './[a-z]{8}\.php' > suspicious.txt
echo "printing all suspicious files"
echo
cat suspicious.txt
echo


#Additional files check
echo "Additional files check started!"
	find . -type f -name '*.php' | xargs grep -l " *=PHP_VERSION *" > phpVersion.txt
	find . -type f -name '*.php' | xargs grep -l " *Phar::interceptFileFuncs() *" > pharser.txt
	find . -type f -name '*.php' | xargs grep -l " *@include *" > include.txt
	find . -type f -name '*.php' | xargs grep -l " *interceptFileFuncs *" > intercept.txt
	find . -type f -name '*.php' | xargs grep -l " *eval *( *gzinflate *( *base64_decode *( *" > base64.txt
	find . -type f -name '*.php' | xargs grep -l " *base64_decode *" >base64_decode.txt
	find . -type f -name '*.php' | xargs grep -l " *function *wscandir *" >  wscandir.txt
	find . -type f -name '*.php' | xargs grep -l " *HTTP/1.0 *404 *Not *Found *" > notfound.txt
	find . -type f -name '*.php' | xargs grep -l " *@gzuncompress *" > gzuncompress.txt
	find . -type f -name '*.php' | xargs grep -l " *Array *( *) *; *global *" > globalcheck.txt
	find . -type f -name '*.php' | xargs grep -l " *@unserialize *" > unserialize.txt
	find . -type f -name * | xargs grep -l " *basename/*t5b94*/*" > maybe.txt
echo

#Deleting malware
read -p "Do you want to delete malware (.ico) files? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	#delete all malware files
	echo -e  "Deleting all malware files started"
	sleep 4
	find . -name '*ico' -type f > deletedFiles.txt
	find . -name "*.ico" -type f -delete
	echo
	echo "Deleted files:"
	echo
	cat deletedFiles.txt
	sleep 5
	echo
	echo "All .ico malware files are deleted!"
	echo
	echo "All reports can be found inside /Report directory"
	mv foundMalware.txt injectedFiles.txt deletedFiles.txt report
	mv phpVersion.txt pharser.txt include.txt intercept.txt base64.txt base64_decode.txt wscandir.txt notfound.txt gzuncompress.txt globalcheck.txt unserialize.txt report/additional_report
	mv suspicious.txt maybe.txt report/suspicious
echo
fi



