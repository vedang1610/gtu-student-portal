# Use Tomcat 9 with JDK 17
FROM tomcat:9.0-jdk17

# Set working directory inside container
WORKDIR /usr/local/tomcat

# Install curl and download MySQL JDBC Connector
RUN apt-get update && apt-get install -y curl && \
    curl -L -o /usr/local/tomcat/lib/mysql-connector-j-8.0.33.jar https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create target directories for the web app
RUN mkdir -p /usr/local/tomcat/webapps/GTUDemo/WEB-INF/classes

# Copy java source files to a temporary location
COPY src/main/java /tmp/java-src

# Compile the Java classes using the Tomcat libraries in classpath
RUN find /tmp/java-src -name "*.java" > /tmp/sources.txt && \
    javac -cp "/usr/local/tomcat/lib/*" -d /usr/local/tomcat/webapps/GTUDemo/WEB-INF/classes @/tmp/sources.txt && \
    rm -rf /tmp/java-src /tmp/sources.txt

# Copy webapp static files, JSPs, web.xml
COPY src/main/webapp/ /usr/local/tomcat/webapps/GTUDemo/

# Expose Tomcat default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
