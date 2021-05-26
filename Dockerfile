FROM apache/nifi:1.13.2
COPY --chown=nifi:nifi build/libs/docker-nifi-s3.jar /
RUN chmod +x /docker-nifi-s3.jar

ENTRYPOINT ["sh", "-c", "java -jar /docker-nifi-s3.jar && /opt/nifi/scripts/start.sh"]
