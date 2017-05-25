# cogstack-getting-started

# Step-by-step guide to install and configure CogStack

## Environment

1. OS: Ubuntu Linux 16.04
2. Database: dockerized Microsoft SQL Server (please note its license requirement)
3. Search engine: Elastic Search 5.4

## Configure dependency

1. Update dependency
```
sudo apt-get update
```
1. Install Java 8
```
sudo apt-get install openjdk-8-jdk-headless
```
1. Install Tesseract
```
sudo apt-get install tesseract-ocr
```
1. Install Imagemagick
```
sudo apt-get install imagemagick
```
1. Install unzip
```
sudo apt-get install unzip
```
1. Install Docker (for dockerized MS SQL Server), follow https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository
```
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce
# Enable docker without sudo
sudo usermod -aG docker $(whoami)
```
**Then log-out and log-in again**
1. Install Microsoft SQL server for Linux (ref: https://hub.docker.com/r/microsoft/mssql-server-linux/)
```
docker pull microsoft/mssql-server-linux
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=yourStrong(!)Password' -p 1433:1433 -d microsoft/mssql-server-linux
```
1. Create DB schema for CogStack job status and sample demo data
```
# CogStack job status tables
wget https://raw.githubusercontent.com/spring-projects/spring-batch/master/spring-batch-core/src/main/resources/org/springframework/batch/core/schema-sqlserver.sql
docker cp schema-sqlserver.sql <container-id>:/schema-sqlserver.sql
docker exec -it <container-id> /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'yourStrong(!)Password' -i /schema-sqlserver.sql
# Create sample input table
wget https://raw.githubusercontent.com/hkkenneth/cogstack-getting-started/master/create-input-table.sql
docker cp create-input-table.sql <container-id>:/create-input-table.sql
docker exec -it <container-id> /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'yourStrong(!)Password' -i /create-input-table.sql
# Populate sample input table
wget https://raw.githubusercontent.com/hkkenneth/cogstack-getting-started/master/insert-to-input-table.sql
docker cp insert-to-input-table.sql <container-id>:/insert-to-input-table.sql
docker exec -it <container-id> /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'yourStrong(!)Password' -i /insert-to-input-table.sql
```
1. Elastic Search (ref: https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-targz.html)
```
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.0.zip
unzip elasticsearch-5.4.0.zip
cd elasticsearch-5.4.0
./bin/elasticsearch -d -p pid
# Create Elastic search index
curl -XPUT 'localhost:9200/demo_index?pretty' -H 'Content-Type: application/json' -d'
{
    "settings" : {
        "index" : {
            "number_of_shards" : 3,
            "number_of_replicas" : 0
        }
    }
}
'
```
1. Install Kibana
```
wget https://artifacts.elastic.co/downloads/kibana/kibana-5.4.0-linux-x86_64.tar.gz
tar xzpf kibana-5.4.0-linux-x86_64.tar.gz
cd kibana-5.4.0-linux-x86_64
# Update `server.host` in config/kibana.yml if you want any host other than localhost to access Kibana
vi config/kibana.yml
./bin/kibana
```

## Configure CogStack
1. Install
```
wget https://github.com/KHP-Informatics/cogstack/archive/master.zip
unzip master.zip
```
2. Build with gradle
```
cd cogstack-master/
./gradlew build
```
3. Download demo configuration file
```
mkdir demo-config
cd demo-config
wget https://raw.githubusercontent.com/hkkenneth/cogstack-getting-started/master/demo.properties
```
4. Run CogStack
```
cd ..
wget https://raw.githubusercontent.com/hkkenneth/cogstack-getting-started/master/run-cogstack.sh
./run-cogstack.sh
```

## Verify results

* You can go to Kibana at `<your_ip>:5601` and check the documents in the demo_index . The file content should be in the `tikaOutput` field.
* Alternatively, you can call Elastic Search REST API to check the result.
