# Use Tomcat 9 with JDK 17
FROM tomcat:9.0-jdk17

# Set working directory inside container
WORKDIR /usr/local/tomcat

# Install curl and download MySQL JDBC Connector
RUN apt-get update && apt-get install -y curl && \
    curl -L -o /usr/local/tomcat/lib/mysql-connector-j-8.0.33.jar https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Delete default Tomcat ROOT webapp to prevent conflicts
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy webapp static files, JSPs, web.xml
COPY src/main/webapp/ /usr/local/tomcat/webapps/ROOT/

# Remove any precompiled classes from host to avoid JDK version mismatch (UnsupportedClassVersionError)
RUN rm -rf /usr/local/tomcat/webapps/ROOT/WEB-INF/classes && \
    mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# Copy java source files to a temporary location
COPY src/main/java /tmp/java-src

# Compile the Java classes inside the container using JDK 17
RUN find /tmp/java-src -name "*.java" > /tmp/sources.txt && \
    javac -cp "/usr/local/tomcat/lib/*" -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes @/tmp/sources.txt && \
    rm -rf /tmp/java-src /tmp/sources.txt

# Copy database initialization SQL scripts
COPY db/ /usr/local/tomcat/db/

# Expose Tomcat default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
