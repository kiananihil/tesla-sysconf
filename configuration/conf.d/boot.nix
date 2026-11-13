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

# Tesla Config --- /conf.d/boot.nix
# Konfiguracja parametrów i argumentów startu systemu.
{
    inputs, core, config, lib, pkgs, ...
}:

{
    boot = {
        loader = {
            # Konfiguracja bootloader'a systemd-boot.
            systemd-boot = {
                enable = true;
                editor = false;
            };
            efi.canTouchEfiVariables = true;
            timeout = 5;
        };
        # Ustawienie outputu terminala przy starcie systemu. 
        consoleLogLevel = 3;
    };
}
