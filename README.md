 # docker-nifi-s3
Docker container for Apache NiFi that retrieves config from S3 location on launch. Container images published to https://hub.docker.com/r/dwpdigital/nifi-s3.

## Build Requirements
- Java 8
- Gradle
- AWSCLI

## To Build
```bash
make build-nifi-image
```

## To Run
Set the following environment variables for the AWS Account you want to use:
- AWS_REGION - All lower case (e.g. eu-west-2)
- AWS_REGION_JAVA - All caps (e.g. EU_WEST_2)
- S3_BUCKET - Source flow file Bucket name
- S3_KEY - File path of the flow file without leading `/` (e.g. my/path/flow.xml.gz)
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

```bash
make run-nifi-container
```

or to build and run in one commands

```bash
make build-and-run
```

## To Use
### UI
Navigate to [http://localhost:8080/nifi](http://localhost:8080/nifi) to view the GUI interface and view the configuration you have provided.


### To Send a File
Use the following command:
```bash
curl --data-binary @README.md http://localhost:7070/uploadCollection 
```
