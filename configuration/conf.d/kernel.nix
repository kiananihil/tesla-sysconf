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

# Tesla Config --- /conf.d/kernel.nix
# Konfiguracja niestandardowego kernela linux-zen. 
{
    inputs, core, config, lib, pkgs, ...
}:

{
    # Ustaw systemowy kernel na linux-zen w przeciwieństwie do domyślnego linux/linux-lts.
    boot.kernelPackages = pkgs.linuxPackages_zen;
}
