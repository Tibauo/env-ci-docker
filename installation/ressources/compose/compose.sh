prepareDockerCompose(){
cat > $DIR/ci/docker-compose.yml <<EOF
version: '3'

# define services
services:
  gitlab:
    container_name: ci_gitlab
    image: gitlab/gitlab-ce
    hostname: gitlab
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://localhost'
        gitlab_rails['lfs_enabled'] = true
        gitlab_rails['initial_root_password'] = '$PASSWORD'
    ports:
      - '80:80'
      - '443:443'
    networks:
      net:
        ipv4_address: 10.5.0.10
  jenkins:
    container_name: ci_jenkins
    image: jenkins-demo
    hostname: jenkins
    ports:
      - 8080:8080
      - 50000:50000
    links:
      - nexus
      - gitlab
    networks:
      net:
        ipv4_address: 10.5.0.20
  nexus:
    container_name: ci_nexus
    image: sonatype/nexus3
    hostname: nexus
    ports:
      - 8081:8081
    networks:
      net:
        ipv4_address: 10.5.0.30


networks:
  net:
    ipam:
      config:
        - subnet: 10.5.0.0/24
EOF
}
