package io.kickscar.cloud.workload.gallery.runtime;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Optional;

@Component
public class EC2InstanceIdentity {
    private static final String IMDS_BASE = "http://169.254.169.254";
    private volatile String cached;
    @Value("${app.runtime.instance-id:}")
    private String configuredId;
    public String getInstanceId() {
        if (cached != null) {
            return cached;
        }
        synchronized (this) {
            if (cached != null) {
                return cached;
            }
            cached = resolve();
            return cached;
        }
    }
    private String resolve() {
        if (configuredId != null && !configuredId.isBlank()) {
            return configuredId.trim();
        }
        String fromEnv = System.getenv("EC2_INSTANCE_ID");
        if (fromEnv != null && !fromEnv.isBlank()) {
            return fromEnv.trim();
        }
        return fetchFromImds().orElse("local");
    }
    /** IMDSv2: 토큰 발급 후 instance-id 조회. EC2·로컬 외 환경에서는 실패 → empty */
    private Optional<String> fetchFromImds() {
        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofMillis(800))
                .build();
        try {
            HttpRequest tokenReq = HttpRequest.newBuilder()
                    .uri(URI.create(IMDS_BASE + "/latest/api/token"))
                    .timeout(Duration.ofSeconds(2))
                    .method("PUT", HttpRequest.BodyPublishers.noBody())
                    .header("X-aws-ec2-metadata-token-ttl-seconds", "21600")
                    .build();
            HttpResponse<String> tokenRes = client.send(tokenReq, HttpResponse.BodyHandlers.ofString());
            if (tokenRes.statusCode() != 200 || tokenRes.body() == null || tokenRes.body().isBlank()) {
                return Optional.empty();
            }
            String token = tokenRes.body().trim();
            HttpRequest idReq = HttpRequest.newBuilder()
                    .uri(URI.create(IMDS_BASE + "/latest/meta-data/instance-id"))
                    .timeout(Duration.ofSeconds(2))
                    .header("X-aws-ec2-metadata-token", token)
                    .GET()
                    .build();
            HttpResponse<String> idRes = client.send(idReq, HttpResponse.BodyHandlers.ofString());
            if (idRes.statusCode() != 200 || idRes.body() == null || idRes.body().isBlank()) {
                return Optional.empty();
            }
            return Optional.of(idRes.body().trim());
        } catch (Exception ignored) {
            return Optional.empty();
        }
    }

}
