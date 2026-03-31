# 1. Official Tomcat image with JDK 21
FROM tomcat:11.0-jdk21

# 2. Clean the default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. Copy WebContent (Check if your folder is WebContent or Webcontent!)
# This copies JSPs, CSS, JS, and the WEB-INF folder
COPY ./Webcontent/ /usr/local/tomcat/webapps/ROOT/

# 4. Copy compiled classes
# Make sure your 'build/classes' folder actually contains your .class files
COPY ./build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

# 5. Fix the Port for Render
# This line replaces Tomcat's default 8080 with the port Render assigns
CMD sed -i "s/port=\"8080\"/port=\"$PORT\"/g" /usr/local/tomcat/conf/server.xml && catalina.sh run
