# Use Tomcat
FROM tomcat:11.0-jdk21

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Create ROOT
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# Copy WebContent (FIXED CASE)
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

# Copy compiled classes
COPY build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

# DEBUG
RUN ls -R /usr/local/tomcat/webapps/ROOT/WEB-INF/

# Start Tomcat
CMD sed -i "s/port=\"8080\"/port=\"$PORT\"/g" /usr/local/tomcat/conf/server.xml && catalina.sh run
