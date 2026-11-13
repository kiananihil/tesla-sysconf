#  _____        _       ____
# |_   ____ ___| | __ _/ ___| _   _ ___
#   | |/ _ / __| |/ _` \___ \| | | / __|
#   | |  __\__ | | (_| |___) | |_| \__ \
#   |_|\___|___|_|\__,_|____/ \__, |___/
#                             |___/
# 
#               ver. 2.1
# [=======================================]
# 
# Upstream konfiguracji:
#    https://github.com/kiananihil/tesla-sysconf
#
# Kontakt:
#    Mail: kiananihil@gmail.com
#
#
# Deklaratywna konfiguracja systemu NixOS służąca do hostowania lokalnych zawodów e-sportowych Counter Strike 2.
#
# [=======================================]

# Tesla Config --- /srv/podman.d.nix
# Konfiguracja środowiska Podman i kontenera tmt2, będącego programem do monitorowania meczów truniejowych.
{
    inputs, core, config, lib, pkgs, ...
}:

{
    # Włącz serwis podman.
    virtualisation.podman = {
        enable = true;
        dockerCompat = true;
    };

    # Dodaj oraz skonfiguruj obraz kontenera tmt2.
    virtualisation.oci-containers = {
        backend = "podman";
        containers.tmt2 = {
            # Kontener źródłowy usługi tmt2.
            image = "docker.io/jensforstmann/tmt2:latest";
            # Zezwól kontenerowi na kontakt z siecią lokalną.
            extraOptions = [ "--network=host" ];
            # Ścieżka zapisu danych tmt2 ( /home/eml/tmt2_storage ).
            volumes = [ "/home/eml/tmt2_storage:/app/backend/storage:Z" ];
            environment = {
                # Porty usługi tmt2.
                PORT = "8080";
                LOG_PORT = "47931";
                # Prefiks wyświetlany w chacie gry dla operacji serwera.
                TMT_SAY_PREFIX = "[TSL-EML] ";
                TMT_LOG_ADDRESS = "http://127.0.0.1:8080";
            };
        };
    };

    systemd.tmpfiles.rules = [
        # Dodaj folder przechowujący pliki kontenera.
       "d /home/eml/tmt2_storage 0755 eml users - - "
        # Dodaj token dostępu do panelu tmt2.
        # Jest to hasło domyślne, warto je zmienić podczas konfiguracji serwera. 
        ''f+ /home/eml/tmt2_storage/access_tokens.json 0644 eml users - {"ZAQ!2wsx": { "comment": "eml_admin" } }''
    ];

    # Dodaj domyślnego użytkownika serwera do grupu zarządzającej kontenerami.
    users.users.eml.extraGroups = [ "podman" ];

    # Dodaj aliasy ułatwiające pracę z obrazem Podmana tmt2.
    programs.zsh.shellAliases = {
        srv_panel_start = "run0 systemctl start podman-tmt2.service";
        srv_panel_stop = "run0 systemctl stop podman-tmt2.service";
        srv_panel_restart = "run0 systemctl restart podman-tmt2.service";
        srv_panel_status = "run0 systemctl status podman-tmt2.service";
        srv_panel_show = "nohup firefox $(hostname -i | awk '{print $1;}'):8080  > /dev/null 2>&1 &";
    };

    # Poczekaj z uruchomieniem serwisu aż do poprawnego startu usługi steamcmd.
    systemd.services.podman-tmt2 = {
        after = [ "network.target" "steamcmd-server-cs2.service" ];
        requires = [ "steamcmd-server-cs2.service" ];
        unitConfig = {
            StartLimitIntervalSec = "30s";
            StartLimitBurst = 10;
        };
    };
}
