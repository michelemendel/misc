
@set JAVA_HOME=C:\j2sdk1.4.2_02
set PATH=%PATH%;%JAVA_HOME%\bin

cd source

javac -d ../class/ mm/Hello.java

cd ..

cd class

jar -cvf mm.jar mm/*.class

cd..

mv class/mm.jar .

pause