# 1. Use the official Tomcat image with JDK 21
FROM tomcat:11.0-jdk21

# 2. Clean the default Tomcat webapps folder
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. Create the ROOT folder manually to be safe
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# 4. Copy the CONTENTS of Webcontent into ROOT
# The "." at the end of the source ensures we copy the files, not the folder itself
COPY Webcontent/. /usr/local/tomcat/webapps/ROOT/

# 5. Copy your compiled classes
COPY build/classes/. /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

# 6. Command to start the Tomcat server with Render's dynamic port
# This line is essential for Render's Free tier to work
CMD sed -i "s/port=\"8080\"/port=\"$PORT\"/g" /usr/local/tomcat/conf/server.xml && catalina.sh run
