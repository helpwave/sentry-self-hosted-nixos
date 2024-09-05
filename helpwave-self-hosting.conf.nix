{ config, pkgs, ... }:

{
  # Docker und Docker Compose aktivieren
  services.dockerRegistry.enable = true;
  virtualisation.docker.enable = true;

  # Sentry Konfiguration
  environment.systemPackages = with pkgs; [
    git
    makeWrapper
    vim
    git
    wget
    nano
    sudo
    docker-compose
    docker_27
  ];

  #services
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    dataDir = "/var/lib/postgresql/data";
    extraConfig = ''
      max_connections = 100
    '';
  };
  services.redis = {
    enable = true;
    package = pkgs.redis;
    dataDir = "/var/lib/redis";
  };
  services.zookeeper = {
    enable = true;
    package = pkgs.zookeeper;
    dataDir = "/var/lib/zookeeper";
    clientPort = 2181;
  };
  services.kafka = {
    enable = true;
    package = pkgs.kafka;
    settings = {
      "log.dirs" = "/var/lib/kafka-logs";
      "zookeeper.connect" = "localhost:2181";
      "broker.id" = 0;
      "listeners" = "PLAINTEXT://localhost:9092";
      "log.retention.hours" = 168;  # Default to 7 days
    };
  };

  #conterner

}
