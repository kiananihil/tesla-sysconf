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

# Tesla Config --- /srv/ssh.d.nix
# Konfiguracja serwera SSH.
{
    inputs, core, config, lib, pkgs, ...
}:

{
   # Konfiguracja serwisu SSH.
    services.openssh = {
      enable = true;
      ports = [ 5588 ];
      settings = {
         # Zezwól na połączenie tylko za pomocą par kluczy ( publiczny i prywatny ).
         PasswordAuthentication = false;
         UseDns = true;
         PermitRootLogin = "no";
      };
   };

   # Otwórz port przypisany połączeniom SSH.
   networking.firewall = {
      allowedTCPPorts = [ 5588 ];
      allowedUDPPorts = [ 5588 ];
   };
}
