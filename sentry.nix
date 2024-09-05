# /etc/nixos/sentry.nix
{ config, pkgs, ... }:

{
  ## DINSTE: Sentry, PostgreSQL, Redis, apache-kafka, Zookeeper, *Clickhouse*, Symbolicator, Relay.
  ## und nachtreglich hinzugefügt nginx

  # PostgreSQL
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    dataDir = "/var/lib/postgresql/data";
    extraConfig = ''
      max_connections = 100
    '';
  };

  # Redis
  services.redis = {
    enable = true;
    package = pkgs.redis;
    #dataDir = "/var/lib/redis";  # dataDir entfernt, da es nicht erforderlich ist
  };

  # ZooKeeper
  #services.zookeeper = {
  #  enable = true;
  #  package = pkgs.zookeeper;
  #  dataDir = "/var/lib/zookeeper";
  #  clientPort = 2181;
  #};

  # Apache Kafka
  services.apache-kafka = {
    enable = true;
    package = pkgs.apacheKafka;
    settings = {
      "log.dirs" = "/var/lib/kafka-logs";
      "zookeeper.connect" = "localhost:2181";
      "broker.id" = 0;
      "listeners" = "PLAINTEXT://localhost:9092";
      "log.retention.hours" = 168;  # Default to 7 days
    };
  };

  # Clickhouse
  #services.clickhouse = {
  #  enable = true;
  #  package = pkgs.clickhouse;
  #  httpPort = 8123;
  #  port = 9000;
  #};

  # Symbolicator
  #services.symbolicator = {
  #  enable = true;
  #  package = pkgs.symbolicator;
  #  settings = {
  #    "bind" = "0.0.0.0:3021";
  #  };
  #};

  # Sentry Web und Worker
  #services.sentry = {
  #  enable = true;
  #  package = pkgs.sentry;
  #  web = {
  #    enable = true;
  #    host = "0.0.0.0";
  #    port = 9000;
  #  };
  #  worker = {
  #    enable = true;
  #  };
  #  cron = {
  #    enable = true;
  #  };
  #};

  # Snuba
  #services.snuba = {
  #  enable = true;
  #  package = pkgs.snuba;
  #  settings = {
  #    "broker" = "kafka://localhost:9092";
  #    "clickhouse" = "http://localhost:8123";
  #    "redis" = "redis://localhost:6379";
  #    "zookeeper" = "localhost:2181";
  #  };
  #};

  # Sentry Relay
  #services.relay = {
  #  enable = true;
  #  package = pkgs.relay;
  #  settings = {
  #    "bind" = "0.0.0.0:3000";
  #    "upstream" = "http://localhost:9000";
  #  };
  #};

  # Sentry-Upgrade
  environment.variables = {
    SENTRY_SECRET_KEY = "secret-key";
    SENTRY_DATABASE_URL = "postgres://sentry_user:password@localhost/sentry_db";
    SENTRY_REDIS_URL = "redis://localhost:6379";
  };

  # Nginx Konfiguration
  services.nginx = {
    enable = true;
    virtualHosts."sentry.example.com" = {
      listen = [ { addr = "0.0.0.0"; port = 3000; } ];
      root = "/var/www/sentry";
      locations."/" = {
      proxyPass = "http://localhost:9000";
      proxySetHeader = [
        { name = "X-Relay-Host"; value = "relay.example.com"; }
      ];  # Optional
      };
    };
  };
}