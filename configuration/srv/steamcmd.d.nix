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

# Tesla Config --- /srv/steamcmd.d.nix
# Zainstaluj klienta steamcmd, oraz skonfiguruj go. Utwórz lokalny serwer do turniejów CS2.
{
    inputs, core, config, lib, pkgs, ...
}:

{
   # Wstępna konfiguracja serwera gry.
   services.steamcmd-servers = {
      enable = true;
      openFirewall = true;
      servers.cs2 = {
         enable = true;
         appId = "730";
         autoUpdate = false;
         executable = "game/bin/linuxsteamrt64/cs2";
	      executableArgs = [
            # Konfiguracja dla meczu właściwego. Na ten port łączą się gracze turnieju do adresu IP serwera.
	         "-dedicated"
            "-port 27015"
            "-ip 0.0.0.0"
            "+sv_lan 1"
            "+map de_inferno"
	         "+hostname \"EML Tournament\""
            # Jest to hasło domyślne, warto je zmienić podczas konfiguracji serwera. 
            "+rcon_password eml_rcon"
            # Konfiguracja dla spectator'ów meczu, przydatna dla komentatorów meczu oraz tworzenia podglądu na potrzeby streama. 
            # Widok ten jest opóźniony o 35s względem rzeczywistej rozgrywki ze względu na potencjalne próby oszustwa z użyciem transmisji.
            # Zapisy są automatycznie zapisywane na serwerze pod /var/lib/steamcmd-servers/servers/cs2/game/csgo/ w plikach *.dem.
            "+tv_enable" "1"
            "+tv_port" "27020"
            "+tv_delay" "35"
            "+tv_autorecord" "1"
 	      ];
         # Gracze łączą się z W.X.Y.Z:27015 natomiast spectatorzy na W.X.Y.Z:27020.
      };
   };

   # Automatyczne czynności poinstalacyjne paketu steamcmd.
   systemd.services.steamcmd-server-cs2.serviceConfig = {
      # Naprawienie błedu permisji instalacji steamcmd. 
      ExecStartPre = lib.mkAfter [
         "+${pkgs.bash}/bin/bash -c 'test -f /var/lib/steamcmd-servers/servers/cs2/game/bin/linuxsteamrt64/cs2 && +${pkgs.coreutils}/bin/chmod +x -R /var/lib/steamcmd-servers/servers/cs2/game/bin/linuxsteamrt64/cs2 || true'"     
         "+${pkgs.bash}/bin/bash -c 'mkdir -p /var/lib/steamcmd-servers/.steam/sdk64 && ln -sf /var/lib/steamcmd-servers/.local/share/Steam/linux64/steamclient.so /var/lib/steamcmd-servers/.steam/sdk64/steamclient.so && chown -R steamcmd-servers:steamcmd-servers /var/lib/steamcmd-servers/.steam || true'"
      ];
      Environment = [
         "LD_LIBRARY_PATH=/var/lib/steamcmd-servers/servers/cs2/game/bin/linuxsteamrt64:/var/lib/steamcmd-servers/servers/cs2/game/bin/linuxsteamrt64"
      ];
      TimeoutStartSec = "infinity";
   };

   # FSH patch.
   programs.nix-ld = {
      enable = lib.mkForce true;
      libraries = with pkgs; [
         stdenv.cc.cc.lib
         zlib
         openssl
         curl
         icu
         libGL
         libX11
         freetype
         fontconfig      
      ];
   };

   # Otwórz porty do połączenia z serwerem gry.
   networking.firewall = {
      allowedTCPPorts = [ 27015 27020 ];
      allowedUDPPorts = [ 27015 27020 ];
   };

   # Dodaj aliasy ułatwiające pracę z steamcmd.
    programs.zsh.shellAliases = {
         srv_game_start = "run0 systemctl start steamcmd-server-cs2.service";
         srv_game_stop = "run0 systemctl stop steamcmd-server-cs2.service";
         srv_game_restart = "run0 systemctl restart steamcmd-server-cs2.service";
         srv_game_status = "run0 systemctl status steamcmd-server-cs2.service";
         srv_panel_update = "run0 systemctl stop steamcmd-server-cs2.service && run0 -u steamcmd-servers ${pkgs.steamcmd}/bin/steamcmd +force_install_dir /var/lib/steamcmd-servers/servers/cs2 +login anonymous +app_update 730 validate +quit && run0 systemctl start steamcmd-server-cs2.service";
    };
}
