{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.etc."profile.d/aliases.sh".text = ''
    alias vim="nvim"
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    meslo-lgs-nf
    fira-code
    kitty
    git
    htop
    firefox
    go-task
    fio
    font-awesome
    noto-fonts
    waybar
    wofi
    vscode
    nwg-displays
    hyprpaper
    cliphist

    # K8s
    kubectl
    k3s
    google-cloud-sdk
    # Install the Google Cloud SDK with the GKE auth plugin included
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
      ]
    ))
    
    # System Tools
    tlp
    networkmanagerapplet
    polkit_gnome
    cpupower-gui
    
    # Diagnostic Tools
    pavucontrol         # Graphical audio mixer
    cpufrequtils        # For cpufreq-info
    wl-clipboard        # Clipboard tool for Wayland
    udisks              # For USB auto-mounting

    # Volumes
    ntfs3g
    exfatprogs

    # # OhMyZsh
    # zsh-autosuggestions
    # zsh-syntax-highlighting
    # zsh-completions
    zsh-powerlevel10k
    atuin
    
    eza
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      k = "kubectl";
      vi = "nvim";
      vim = "nvim";
      ls = "eza";
    };
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "kubectl"
        "docker"
        "z"
        "copyfile"
      ];
    };
    shellInit = ''
      # Source Powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      # This checks if your custom config exists and sources it.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.thunar.enable = true;

  programs.nano = {
    enable = true;
    nanorc = ''
      set autoindent
    '';
  };

  # Thunar
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.udisks2.enable = true;

  # K8s & Docker
  virtualisation.docker.enable = true;
  users.groups.docker.members = [ "dandatran" ];

  # --- POLKIT (Permissions & Password Prompts) ---
  security.polkit.enable = true;

  services.displayManager.sddm.enable = true;

  services.displayManager.sessionPackages = [
    pkgs.hyprland
  ];
}
