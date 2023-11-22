# DO NOT USE THIS REPO - MIGRATED TO GITLAB

[![Actions Status](https://github.com/dwp/docker-nifi-s3/workflows/Master/badge.svg)](https://github.com/dwp/docker-nifi-s3/actions)

 # docker-nifi-s3
Docker container for Apache NiFi that retrieves config from S3 location on launch. Container images published to https://hub.docker.com/r/dwpdigital/nifi-s3.

## Build Requirements
- Java 8
- Gradle
- AWSCLI

## To Generate Flow File and Store in S3
```bash
make s3-config
```

## To Build
```bash
make build
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
make run
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

Check the Nifi UI above, in addition, check the S3 bucket `dataworks-nifi-output` for your file to verify.

### Retrieve flow file from container
NiFi UI automatically saves changes to a flow file. When running on a container locally, you can get the flow file off the container using the following command, ensuring you have first set the environment variable `CONTAINER_ID` to the locally running docker container for NiFi:
```bash
make get-flow-file-locally-and-upload-to-s3
```

This will copy the flow file locally, and upload it to S3 in the location of `S3_BUCKET` and `S3_KEY` environment variables.
