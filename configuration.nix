# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./remote.conf.nix
      ./sentry.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "helpwave"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  users.users.helpwave = {
    isNormalUser = true;
    description = "helpwave";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # Docker und Docker Compose aktivieren
  services.dockerRegistry.enable = true;
  virtualisation.docker.enable = true;

  # Docker-Services konfigurieren
  #virtualisation.docker = [
  #  {
  #    name = "sentry";
  #    image = "getsentry/sentry:latest";
  #    ports = [ "9000:9000" ];
  #    environment = {
  #      SENTRY_SECRET_KEY = "your_secret_key";
  #      SENTRY_DATABASE_URL = "postgres://sentry_user:password@localhost/sentry_db";
  #      SENTRY_REDIS_URL = "redis://localhost:6379";
  #    };
  #    volumes = [
  #      {
  #        hostPath = "/var/lib/sentry";
  #        containerPath = "/data";
  #      }
  #    ];
  #  }
  #  {
  #    name = "clickhouse";
  #    image = "clickhouse/clickhouse-server:latest";
  #    ports = [
  #      {
  #        containerPort = 8123;
  #        hostPort = 8123;
  #      }
  #      {
  #        containerPort = 9000;
  #        hostPort = 9000;
  #      }
  #    ];
  #    volumes = [
  #      {
  #        hostPath = "/var/lib/clickhouse";
  #        containerPath = "/var/lib/clickhouse";
  #      }
  #      {
  #        hostPath = "/var/log/clickhouse-server";
  #        containerPath = "/var/log/clickhouse-server";
  #      }
  #    ];
  #  }
  #  {
  #    name = "snuba-api";
  #    image = "getsentry/snuba:latest";
  #    ports = [ "1218:1218" ];
  #    environment = {
  #      SNUBA_SETTINGS = "docker";
  #      SNUBA_BROKER = "kafka://localhost:9092";
  #      SNUBA_CLICKHOUSE_HOST = "clickhouse";
  #      SNUBA_CLICKHOUSE_PORT = "8123";
  #      SNUBA_REDIS_HOST = "localhost";
  #      SNUBA_ZOOKEEPER_HOST = "localhost";
  #    };
  #  }
  #  {
  #    name = "snuba-consumer";
  #    image = "getsentry/snuba:latest";
  #    environment = {
  #      SNUBA_SETTINGS = "docker";
  #      SNUBA_BROKER = "kafka://localhost:9092";
  #      SNUBA_CLICKHOUSE_HOST = "clickhouse";
  #      SNUBA_CLICKHOUSE_PORT = "8123";
  #      SNUBA_REDIS_HOST = "localhost";
  #      SNUBA_ZOOKEEPER_HOST = "localhost";
  #    };
  #    command = "consumer --storage events --auto-offset-reset=latest --log-level=INFO";
  #  }
  #  {
  #    name = "snuba-replacer";
  #    image = "getsentry/snuba:latest";
  #    environment = {
  #      SNUBA_SETTINGS = "docker";
  #      SNUBA_BROKER = "kafka://localhost:9092";
  #      SNUBA_CLICKHOUSE_HOST = "clickhouse";
  #      SNUBA_CLICKHOUSE_PORT = "8123";
  #      SNUBA_REDIS_HOST = "localhost";
  #      SNUBA_ZOOKEEPER_HOST = "localhost";
  #    };
  #    command = "replacer --storage events --auto-offset-reset=latest --log-level=INFO";
  #  }
  #  {
  #    name = "symbolicator";
  #    image = "getsentry/symbolicator:latest";
  #    ports = [ "3021:3021" ];
  #    environment = {
  #      SYM_STORE_PATH = "/data";
  #      BIND = "0.0.0.0:3021";
  #    };
  #    volumes = [
  #      {
  #        hostPath = "/var/lib/symbolicator";
  #        containerPath = "/data";
  #      }
  #    ];
  #  }
  #  {
  #    name = "zookeeper";
  #    image = "zookeeper:latest";  # Offizielles ZooKeeper Docker-Image
  #    ports = [ "2181:2181" ];  # Standardport für ZooKeeper
  #    environment = {
  #      ZOO_MY_ID = "1";  # Beispielkonfiguration für eine ZooKeeper-Instanz
  #      ZOO_SERVERS = "server.1=0.0.0.0:2888:3888";
  #    };
  #    volumes = [
  #      {
  #        hostPath = "/var/lib/zookeeper";
  #        containerPath = "/data";
  #      }
  #    ];
  #  }
  #];


  # Systemd-Dienst für Docker-Compose
  systemd.services.sentry-compose = {
    description = "Sentry Docker-Compose service";
    after = [ "docker.service" ];
    wants = [ "docker.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f /etc/docker-compose/docker-compose.yml up";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f /etc/docker-compose/docker-compose.yml down";
      Restart = "always";
      WorkingDirectory = "/etc/docker-compose";
    };
  };
  
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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 9000 3000 9092 2181 8123 6379 ];
    allowedUDPPorts = [];
  };


  system.stateVersion = "24.05";
}