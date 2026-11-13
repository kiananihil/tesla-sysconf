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

# Tesla Config --- /conf.d/core.nix
# Elementarna konfiuracja potrzebna do używania systemu poprzez TTY.
{
    inputs, core, config, lib, pkgs, ...
}:

{
    # Ustaw strefę czasową oraz język systemu (Europa/Warszawa, j.angielski US z polską klawiaturą).
    time.timeZone = "Europe/Warsaw";
    i18n = {
        defaultLocale = "pl_PL.UTF-8";
	    extraLocaleSettings = {
       		LC_ADDRESS = "pl_PL.UTF-8";
        	LC_IDENTIFICATION = "pl_PL.UTF-8";
        	LC_MEASUREMENT = "pl_PL.UTF-8";
        	LC_MONETARY = "pl_PL.UTF-8";
        	LC_NAME = "pl_PL.UTF-8";
        	LC_NUMERIC = "pl_PL.UTF-8";
        	LC_PAPER = "pl_PL.UTF-8";
        	LC_TELEPHONE = "pl_PL.UTF-8";
        	LC_TIME = "pl_PL.UTF-8";
	    };
    };
    console.keyMap = "pl2";

    # Pobierz zestaw przydatnych paczek i narzędzi.
    environment.systemPackages = with pkgs; [
        # Doaj wsparcie dla najczęściej używanych systemów plików. 
        btrfs-progs
        ntfs3g
        xfsprogs
        e2fsprogs
        dosfstools
        f2fs-tools
        zfs

        # Zainstaluj przydatne narzędzia administracyjne
        tree
        tldr
        pciutils
        traceroute
	    neovim
	    btop
        efibootmgr
        curl
   ];

   # Uruchom automatyczne montowanie dysków.
   services.udisks2.enable = true;

    # Zezwól na pakiety z nie-FOSS licjencjami ( wymagane do niektórych sterowników oraz Steam'a ).
    nixpkgs.config.allowUnfree = true;

    # Wersja systemu pierwszej instalacji. 
    # Jest to wartość generowana domyślnie przez system !! NIE ZMIENIAĆ. 
    system.stateVersion = "26.05";

    # Konfiguracja domyślnego użytkownika ( EML ).
    users.users."eml" = {
        isNormalUser = true;
        description = "EML";
        extraGroups = [ "networkmanager" "wheel" "input" ];
        shell = pkgs.zsh;
    }; 

    # Dodanie modułu umożliwającego poprawne używanie Flake'ów. 
    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
    };

    # Ustawnienia kompilacji lokalnych pakietów. 
    nix.settings = {
        max-jobs = "auto";
        # W tym przypadku wybór 0 rdzeni wybiera wszystkie dostępne na CPU.
        cores = 0;
    };

    # Włączenie automatycznej optymalizacji plików ścieżki /nix/store - zawierającym wszystkie pakiety instalowane przez system.
    nix.settings.auto-optimise-store = true;

    # Instalacja programu version control git.
    programs.git.enable = true;

    # Automatycznie usuwaj zbędne generacje systemu. 
    # System zawsze zachowa ostatnie 3 jako punkty bezpiecznego rolbacku w przypadku awarii.
    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-generations +3";
    };

    # Konfiguracja powłoki ZSH, domyślnej dla użytkowników systemowych.
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
            nano = "nvim";
            sys_update = "run0 nix flake update --flake /etc/nixos/ && run0 nixos-rebuild switch --flake /etc/nixos/#nixos";
            sys_rebuild = "run0 nixos-rebuild switch --flake /etc/nixos/#nixos";
            sys_performance = "btop";
        };
        ohMyZsh = {
            enable = true;
            plugins = [ "git" "history" ];
            theme = "evan";
        };
    };
}
