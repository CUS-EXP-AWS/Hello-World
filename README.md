Hello World! (WAR-style)
===============

This is the simplest possible Java webapp for testing servlet container deployments.  It should work on any container and requires no other dependencies or configuration.



CODE ==> mvn package ==> WAR ==> WEBAPPS (TOMCAT)



1. GitHUB <== CODE



2. AWS REDHAT  SERVER == >  [ GitHUB == CODE ]       ==> pre req install git 

       
    mvn package                                       ==> pre req maven install
    
    
3.  GitHUB CODE == Hello-World folder <==  mvn package  ==> .WAR [ target ] 


4. Install TOMCAT   == path: /opt/tomcat/apache-tomcat-8.5.37 ==> webapps 



5.   3 & 4 steps relate: 
     
     Goto Target folder== GitHUB CODE
     
     cp hello-world-war-1.0.8-\$\{env.BUILD_NUMBER\}-SNAPSHOT.war /opt/tomcat/apache-tomcat-8.5.37/webapps/
     
     
     
6. http://18.218.57.121:8080/manager/html










