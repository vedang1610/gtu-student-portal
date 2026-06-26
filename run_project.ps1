$ErrorActionPreference = "Stop"

# Paths (Dynamically detected relative to this script's directory)
$projectDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Item -Path ".").FullName }
$workspaceDir = Split-Path -Parent $projectDir
$tomcatDir = Join-Path $workspaceDir "tomcat"
$libDir = Join-Path $projectDir "src\main\webapp\WEB-INF\lib"
$classesDir = Join-Path $projectDir "src\main\webapp\WEB-INF\classes"

# 0. JDK Detection / Auto-Installation
$jdkUrl = "https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jdk/hotspot/normal/eclipse"
$portableJdkDir = Join-Path $workspaceDir "jdk-21"
$detectedJavaHome = ""

# Check existing JAVA_HOME
if ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME "bin\javac.exe"))) {
    $detectedJavaHome = $env:JAVA_HOME
    Write-Host "Found JDK via JAVA_HOME env variable: $detectedJavaHome"
}
# Check if javac is in PATH
if (-not $detectedJavaHome) {
    $javacPath = Get-Command javac -ErrorAction SilentlyContinue
    if ($javacPath) {
        $binDir = Split-Path -Parent $javacPath.Source
        $possibleJavaHome = Split-Path -Parent $binDir
        if (Test-Path (Join-Path $possibleJavaHome "bin\javac.exe")) {
            $detectedJavaHome = $possibleJavaHome
            Write-Host "Found JDK via PATH: $detectedJavaHome"
        }
    }
}
# Check if portable JDK was already downloaded previously
if (-not $detectedJavaHome -and (Test-Path (Join-Path $portableJdkDir "bin\javac.exe"))) {
    $detectedJavaHome = $portableJdkDir
    Write-Host "Found previously downloaded portable JDK: $detectedJavaHome"
}
# Check standard installation directories
if (-not $detectedJavaHome) {
    $searchPaths = @(
        "C:\Program Files\Eclipse Adoptium",
        "C:\Program Files\Java"
    )
    foreach ($path in $searchPaths) {
        if (Test-Path $path) {
            # Find any folder containing 'jdk-21' or 'jdk-17' or similar
            $jdks = Get-ChildItem -Path $path -Directory | Where-Object { $_.Name -like "jdk*" } | Sort-Object Name -Descending
            foreach ($jdk in $jdks) {
                if (Test-Path (Join-Path $jdk.FullName "bin\javac.exe")) {
                    $detectedJavaHome = $jdk.FullName
                    Write-Host "Found JDK in standard path: $detectedJavaHome"
                    break
                }
            }
            if ($detectedJavaHome) { break }
        }
    }
}

# If still not found, download portable JDK
if (-not $detectedJavaHome) {
    Write-Host "No JDK 21 installation detected on this system."
    Write-Host "Downloading portable OpenJDK 21 (Eclipse Temurin) from Adoptium..."
    
    $jdkZipPath = Join-Path $workspaceDir "jdk21.zip"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $jdkUrl -OutFile $jdkZipPath
    
    Write-Host "JDK zip downloaded. Extracting..."
    $tempExtractDir = Join-Path $workspaceDir "jdk-temp"
    if (Test-Path $tempExtractDir) {
        Remove-Item -Recurse -Force $tempExtractDir
    }
    Expand-Archive -Path $jdkZipPath -DestinationPath $tempExtractDir -Force
    
    # Locate the extracted directory and move to portableJdkDir
    $extractedFolder = Get-ChildItem -Path $tempExtractDir -Directory | Select-Object -First 1
    if (Test-Path $portableJdkDir) {
        Remove-Item -Recurse -Force $portableJdkDir
    }
    Move-Item -Path $extractedFolder.FullName -Destination $portableJdkDir
    
    # Cleanup temp
    Remove-Item -Path $jdkZipPath -Force
    Remove-Item -Recurse -Force $tempExtractDir
    
    $detectedJavaHome = $portableJdkDir
    Write-Host "Portable JDK 21 installed successfully at: $detectedJavaHome"
}

# URL Links
$tomcatUrl = "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89-windows-x64.zip"
$h2Url = "https://repo1.maven.org/maven2/com/h2database/h2/2.2.224/h2-2.2.224.jar"

Write-Host "============================================="
Write-Host " Starting GTU Student Portal Local Runner"
Write-Host "============================================="

# 1. Ensure Directories Exist
if (!(Test-Path $libDir)) {
    New-Item -ItemType Directory -Path $libDir -Force | Out-Null
}
if (!(Test-Path $classesDir)) {
    New-Item -ItemType Directory -Path $classesDir -Force | Out-Null
}

# 2. Download H2 JAR
$h2JarPath = "$libDir\h2-2.2.224.jar"
if (!(Test-Path $h2JarPath)) {
    Write-Host "Downloading H2 Database Driver..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $h2Url -OutFile $h2JarPath
    Write-Host "H2 Database Driver downloaded successfully."
}

# 3. Download and Extract Tomcat
if (!(Test-Path "$tomcatDir\bin\bootstrap.jar")) {
    Write-Host "Downloading Apache Tomcat 9..."
    $tomcatZipPath = "$workspaceDir\tomcat.zip"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $tomcatUrl -OutFile $tomcatZipPath
    Write-Host "Tomcat zip downloaded. Extracting..."
    
    $tempExtractDir = "$workspaceDir\tomcat-temp"
    if (Test-Path $tempExtractDir) {
        Remove-Item -Recurse -Force $tempExtractDir
    }
    Expand-Archive -Path $tomcatZipPath -DestinationPath $tempExtractDir -Force
    
    # Move the extracted Tomcat folder to the target directory
    $extractedFolder = Get-ChildItem -Path $tempExtractDir -Directory | Select-Object -First 1
    Move-Item -Path $extractedFolder.FullName -Destination $tomcatDir
    
    # Clean up temp files
    Remove-Item -Path $tomcatZipPath -Force
    Remove-Item -Recurse -Force $tempExtractDir
    Write-Host "Apache Tomcat 9 installed successfully."
}

# 4. Compile Java files
Write-Host "Compiling Java source files..."
$javaFiles = Get-ChildItem -Path "$projectDir\src\main\java" -Filter *.java -Recurse | ForEach-Object { $_.FullName }
if ($javaFiles.Count -eq 0) {
    Write-Error "No Java source files found!"
}

# Setup classpath (Tomcat lib + WEB-INF lib)
$classpath = "$tomcatDir\lib\*`;$libDir\*"
& javac -encoding UTF-8 -cp $classpath -d $classesDir $javaFiles
Write-Host "Java source files compiled successfully."

# 5. Deploy Web Application to Tomcat
Write-Host "Deploying web application to Tomcat..."
$deployDir = "$tomcatDir\webapps\GTUDemo"
if (Test-Path $deployDir) {
    Remove-Item -Recurse -Force $deployDir
}
# Copy all webapp files (including classes, lib, index.jsp, WEB-INF, etc.)
Copy-Item -Recurse -Force "$projectDir\src\main\webapp" $deployDir
Write-Host "Web application deployed."

# 6. Run Tomcat Server
Write-Host "Starting Tomcat Server on http://localhost:8080/GTUDemo/"
$env:PROJECT_DIR = $projectDir
$env:CATALINA_HOME = $tomcatDir
$env:CATALINA_BASE = $tomcatDir
$env:JAVA_HOME = $detectedJavaHome

# Database configuration (Local H2 database)
$env:JDBC_DRIVER = "org.h2.Driver"
$env:DB_URL = "jdbc:h2:~/gtu_student_db;MODE=MySQL;DATABASE_TO_UPPER=FALSE"
$env:DB_USER = "sa"
$env:DB_PASS = ""

# Launch Tomcat using catalina.bat run
& "$tomcatDir\bin\catalina.bat" run

