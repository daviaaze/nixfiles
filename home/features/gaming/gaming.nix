{ pkgs, ... }: {
  home.packages = with pkgs; [
    prismlauncher # Minecraft launcher
    moonlight-qt  # Game streaming
    bottles      # Windows compatibility
    
    # Gaming utilities
    gamemode    # Optimize system for gaming
    mangohud    # Gaming performance overlay
  ];

  # Gaming-specific environment variables
  home.sessionVariables = {
    MANGOHUD = "1";
  };
}
