FROM apache/nifi:1.9.0
COPY --chown=nifi:nifi build/libs/docker-nifi-s3.jar /
RUN chmod +x /docker-nifi-s3.jar

#ENTRYPOINT ["/docker-nifi-s3.jar $AWS_REGION $S3_BUCKET $S3_KEY && /opt/nifi/scripts/start.sh"]
ENTRYPOINT ["/opt/nifi/scripts/start.sh"]