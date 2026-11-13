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

# Tesla Config --- /flake.nix
# Główny plik zarządzajacy modułami systemowymi. 
{
  description = "Kiana's Tesla config flake";

  inputs = {
    # Deklaracja wersji źródeł instalowanych pakietów. 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Importowanie SteamCMD. 
    steamcmd-servers = {
      url = "github:kagurazaka-ayano/steamcmd-servers";
    };
  };

  outputs = { self, nixpkgs, steamcmd-servers, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      # Przyłączenie plików konfiguracyjnych systemu.
      modules = [
        # Skan montowania dysków w hierarchii plików systemowych.
          ./hdwr/hardware-configuration.nix

        # Moduły stałe. 
          ./conf.d/core.nix
          ./conf.d/kernel.nix
          ./conf.d/networking.nix
          ./conf.d/user_interface.nix
          ./conf.d/boot.nix
          ./conf.d/security.nix
        
        # Moduły zmienne ( daemony / serwisy ).
          ./srv/ssh.d.nix
          # Moduły zmienne odpowiedzialne za serwer gry. 
          ./srv/steamcmd.d.nix
          ./srv/podman.d.nix
        
        steamcmd-servers.nixosModules.default
      ];
    };
  };
}
