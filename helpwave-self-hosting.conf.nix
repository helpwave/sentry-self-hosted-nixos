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

  # PostgreSQL und Redis wie vorher
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

  # ZooKeeper und Kafka wie vorher
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

  # Clickhouse Service hinzufügen
  services.clickhouse = {
    enable = true;
    package = pkgs.clickhouse;
    settings = {
      "listen_host" = "::";
      "tcp_port" = 9000;
      "http_port" = 8123;
    };
  };

  # Symbolicator
  services.symbolicator = {
    enable = true;
    package = pkgs.symbolicator;
    settings = {
      "bind" = "0.0.0.0:3021";
    };
  };

  # Sentry Web und Worker
  services.sentry = {
    enable = true;
    package = pkgs.sentry;
    web = {
      enable = true;
      host = "0.0.0.0";
      port = 9000;
    };
    worker = {
      enable = true;
    };
    cron = {
      enable = true;
    };
  };

  # Snuba
  services.snuba = {
    enable = true;
    package = pkgs.snuba;
    settings = {
      "broker" = "kafka://localhost:9092";
      "clickhouse" = "http://localhost:8123";
      "redis" = "redis://localhost:6379";
      "zookeeper" = "localhost:2181";
    };
  };

  # Sentry Relay
  services.relay = {
    enable = true;
    package = pkgs.relay;
    settings = {
      "bind" = "0.0.0.0:3000";
      "upstream" = "http://localhost:9000";
    };
  };

  # sentry upgrade
  environment.variables = {
    SENTRY_SECRET_KEY = "secret-key";
    SENTRY_DATABASE_URL = "postgres://sentry_user:password@localhost/sentry_db";
    SENTRY_REDIS_URL = "redis://localhost:6379";
  };

  #conterner

}
