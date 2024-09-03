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

  # Sentry Self-Hosted Klonen und Setup
  systemd.services.sentry-setup = {
    description = "Setup Sentry Self-Hosted";
    after = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];

    script = ''
      if [ ! -d /var/lib/sentry-self-hosted ]; then
        # Sicherstellen, dass wir mit root-Rechten arbeiten
        sudo git clone https://github.com/getsentry/self-hosted /var/lib/sentry-self-hosted
        cd /var/lib/sentry-self-hosted
        sudo ./install.sh
      fi
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # Optional: Wenn du möchtest, dass Docker-Container automatisch beim Systemstart hochfahren
  systemd.services.sentry-up = {
    description = "Start Sentry Containers";
    after = [ "docker.service" "sentry-setup.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = '' 
        export PATH=$PATH:/usr/local/bin:/usr/bin:/bin
        cd /var/lib/sentry-self-hosted
        /usr/bin/docker-compose up -d
      '';
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };


  # Optional: Wenn du möchtest, dass Docker-Container automatisch beim System herunterfahren gestoppt werden
  systemd.services.sentry-down = {
    description = "Stop Sentry Containers";
    before = [ "shutdown.target" ];

    script = ''
      cd /var/lib/sentry-self-hosted
      sudo docker-compose down
    '';

    serviceConfig = {
      Type = "oneshot";
    };

    wantedBy = [ "shutdown.target" ];
  };
}
