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

# Tesla Config --- /conf.d/networking.nix
# Konfiguracja networkmanagera oraz serwisów sieciowych.
{
    inputs, core, config, lib, pkgs, ...
}:

{
    # Konfiguracja sieciowa serwera za pomocą NetworkManagera.
    networking = {
      # Ustawnienie nazwy urządzenia, nazwa to jest widoczna innym urządzeniom w danej sieci lokalnej.
      hostName = "Tesla_EML_Server";
      networkmanager.enable = true;
      # Skonfiguruj firewall. 
      firewall = {
         enable = true;
      };
   };
}
