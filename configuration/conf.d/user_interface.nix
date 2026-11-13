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

# Tesla Config --- /conf.d/user_interface.nix
# Elementarna konfiuracja potrzebna do używania systemu poprzez menu graficzne.
{
    inputs, core, config, lib, pkgs, ...
}:

{
    # Skonfiguruj serwer dzięku Pipewire.
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        pulse.enable = true;
    };

    # Dodaj dodatkowe wspacie dla serwera grafiki X11.
    services = {
        xserver.enable = true;
    };

    # Dodaj kodeki mediów.
    environment.systemPackages = with pkgs; [
        (ffmpeg-full.override {
            # Ustawienie tej falgi na " true " spowoduje dodanie non-open kodeków.
            # Spowoduje to wymóg lokalnej kompilacji przy każej aktualizacji ffmpeg.
            # Na potrzeby serwera kodeki te są zbędne.
            withUnfree = false;
        })
    ];

    # Dodaj XFCE desktop environment. 
    services.xserver = {
        displayManager.lightdm.enable = true;
        desktopManager.xfce.enable = true;
    };

    # Zainstaluj przeglądarke Firefox.
    programs.firefox = {
        enable = true;
        languagePacks = [ "pl" "en-US" ]; 
    };
}
