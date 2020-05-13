package uk.gov.dwp.dataworks;

import com.amazonaws.SdkClientException;
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;

public class GetTemplateFromS3 {

    private static final String DESTINATION = "/opt/nifi/nifi-current/conf/flow.xml.gz";

    public static void main(final String[] args) throws IOException {
        try {
            final String clientRegion = System.getenv("AWS_REGION");
            final String bucketName = System.getenv("S3_BUCKET");
            final String sourceKey = System.getenv("S3_KEY");

            final AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
                    .withCredentials(DefaultAWSCredentialsProviderChain.getInstance())
                    .withRegion(Regions.valueOf(clientRegion))
                    .build();

            final GetObjectRequest request = new GetObjectRequest(bucketName, sourceKey);
            final S3Object s3Object = s3Client.getObject(request);

            final S3ObjectInputStream inputStream = s3Object.getObjectContent();
            FileUtils.copyInputStreamToFile(inputStream, new File(DESTINATION));
        } catch (final SdkClientException e) {
            e.printStackTrace();
        }
    }
}
