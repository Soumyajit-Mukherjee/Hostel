# 1. Use the official Tomcat image with JDK 21
FROM tomcat:11.0-jdk21

# 2. Clean the default Tomcat webapps to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. Copy your Webcontent (JSPs, CSS, WEB-INF) to the ROOT of the server
# This makes your index.jsp accessible at the main URL
COPY ./Webcontent/ /usr/local/tomcat/webapps/ROOT/

# 4. Copy your compiled .class files (Servlets/DAOs)
# This assumes Eclipse puts compiled classes in build/classes
COPY ./build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

# 5. Inform Railway that the app listens on port 8080
EXPOSE 8080

# 6. Command to start the Tomcat server
CMD ["catalina.sh", "run"]