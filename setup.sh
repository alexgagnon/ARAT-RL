# sudo apt-get update && sudo apt-get install -y git && git clone https://gitlab.com/sooding93/rest-rl

# Install Common Utilities
sudo apt-get install -y software-properties-common \
unzip wget gcc git vim libcurl4-nss-dev tmux mitmproxy

# Install Java8
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y maven
sudo apt-get install -y openjdk-11-jdk

# Install Python3
python3 -m venv venv
. ./venv/bin/activate
pip install -r requirements.txt

# Install Docker
# sudo apt-get install -y docker.io

# Install Dotnet 6
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-runtime-6.0
sudo apt-get install -y dotnet-sdk-6.0
rm packages-microsoft-prod.deb

######RESTful Service#####
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
cd ./service/jdk8_1 && mvn clean install -DskipTests && mvn dependency:build-classpath -Dmdep.outputFile=cp.txt
cd ../jdk8_2/genome-nexus && mvn clean install -DskipTests && mvn dependency:build-classpath -Dmdep.outputFile=cp.txt
cd ../person-controller && mvn clean install -DskipTests && mvn dependency:build-classpath -Dmdep.outputFile=cp.txt
cd ../user-management && mvn clean install -DskipTests && mvn dependency:build-classpath -Dmdep.outputFile=cp.txt
export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
cd ../../jdk11/market && mvn clean install -DskipTests && mvn dependency:build-classpath -Dmdep.outputFile=cp.txt
cd ../project-tracking-system && mvn clean install -DskipTests && mvn dependency:build-classpath -Dmdep.outputFile=cp.txt
cd ../../..

docker pull genomenexus/gn-mongo
docker pull mongo
docker pull mysql

# Install EvoMaster 1.6.0
wget https://github.com/EMResearch/EvoMaster/releases/download/v1.6.0/evomaster.jar.zip
unzip evomaster.jar.zip
rm evomaster.jar.zip

# Install RESTler 9.1.1
. ./venv/bin/activate \
&& wget https://github.com/microsoft/restler-fuzzer/archive/refs/tags/v9.1.1.tar.gz \
&& tar -xvf v9.1.1.tar.gz \
&& rm v9.1.1.tar.gz \
&& mv restler-fuzzer-9.1.1 restler \
&& cd restler \
&& mkdir restler_bin \
&& python ./build-restler.py --dest_dir ./restler_bin
cd ..

wget https://repo1.maven.org/maven2/org/jacoco/org.jacoco.agent/0.8.7/org.jacoco.agent-0.8.7-runtime.jar
wget https://repo1.maven.org/maven2/org/jacoco/org.jacoco.cli/0.8.7/org.jacoco.cli-0.8.7-nodeps.jar

chmod u+x get_cov.sh

# install nodejs and npm dependencies
sudo snap install node --classic --channel=14
npm i

# install mockoon
sudo snap install mockoon