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

# Tesla Config --- /conf.d/security.nix
# Konfiguracja polityki zabezpieczeń.
{
    inputs, core, config, lib, pkgs, ...
}:

{
    # Zastąp sudo na rzecz run0, bezpieczniejszej alternatywy.
    security = {
        run0.enable = true;
        sudo.enable = false;
    };

    # Opcje kernela poprawiające bezpieczeństwo.
    boot.kernelParams = [
        "slab_nomerge"
        "page_poison=1"
        "page_alloc.shuffle=1"
        "debugfs=off" 
    ];

    # Blokuj dostęp niepowiązanych użytkowników do pamięci.
    security.forcePageTableIsolation = true;

    # Nadaj dostęp do daemona Nix tylko dla grupy administratora.
    nix.settings.allowed-users = [ "@wheel" ];

    # Nie pozówl na zmianę kernela podczas parcy maszyny.
    security.protectKernelImage = true;
}
