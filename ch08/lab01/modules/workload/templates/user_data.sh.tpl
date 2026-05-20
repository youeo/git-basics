#!/bin/bash
set -euo pipefail

# 1. JDK 21 + git 설치
dnf install -y java-21-amazon-corretto-headless git

# 2. 디렉토리 준비
APP_DIR=/opt/gallery
REPO_DIR=/home/ec2-user/workspace
mkdir -p "$${APP_DIR}"
chown -R ec2-user:ec2-user "$${APP_DIR}"

# 3. 소스 클론 + 빌드
sudo -u ec2-user bash -lc "
set -euo pipefail
cd /home/ec2-user
rm -rf workspace
git clone --filter=blob:none --sparse https://github.com/kickscar/learning-series.git workspace
cd workspace
git sparse-checkout init --no-cone
git sparse-checkout set Cloud/Workloads/gallery-spring-boot
cd Cloud/Workloads/gallery-spring-boot
chmod +x ./mvnw
./mvnw clean package -DskipTests -Dbuild.finalName=gallery
"

# 4. JAR 복사
cp "$${REPO_DIR}/Cloud/Workloads/gallery-spring-boot/target/gallery.jar" "$${APP_DIR}/gallery.jar"
chown ec2-user:ec2-user "$${APP_DIR}/gallery.jar"

# 5. systemd 서비스 등록
cat >/etc/systemd/system/gallery.service <<EOF
[Unit]
Description=Gallery Spring Boot
After=network.target

[Service]
Type=simple
User=ec2-user
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
WorkingDirectory=/opt/gallery
ExecStart=/usr/bin/java -jar /opt/gallery/gallery.jar --spring.profiles.active=${profile} --server.port=${server_port}
Restart=always
RestartSec=5
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now gallery.service