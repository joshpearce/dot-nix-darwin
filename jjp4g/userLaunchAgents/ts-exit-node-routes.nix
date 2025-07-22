{ lib, pkgs, ... }: 
let
  ts-exit-node-routes = "${(pkgs.writeShellScriptBin "ts-exit-node-routes" ''

    # -------------------- Configuration --------------------

    LOCAL_ROUTER_IP="10.13.84.1"
    TAILSCALE_EXIT_NODE="100.118.202.55"

    # List of IPs or subnets to route through the exit node
    ROUTE_VIA_EXIT_NODE=(
      "13.226.94.0/24"
    )

    # -------------------- Script Logic --------------------

    # Extract exit node IP from tailscale status JSON
    EXIT_NODE_IP=$(tailscale status --json 2>/dev/null \
      | jq -r '.ExitNodeStatus.TailscaleIPs[0] // empty' \
      | cut -d/ -f1)

    if [[ -z "$EXIT_NODE_IP" ]]; then
      echo "[INFO] No exit node currently in use. Cleaning up custom routes..."
      for ip in "''${ROUTE_VIA_EXIT_NODE[@]}"; do
        sudo route delete "$ip" 2>/dev/null
      done
      exit 0
    fi

    if [[ "$EXIT_NODE_IP" != "$TAILSCALE_EXIT_NODE" ]]; then
      echo "[INFO] Exit node in use ($EXIT_NODE_IP) does not match configured node ($TAILSCALE_EXIT_NODE). Cleaning up..."
      for ip in "''${ROUTE_VIA_EXIT_NODE[@]}"; do
        sudo route delete "$ip" 2>/dev/null
      done
      exit 0
    fi

    echo "[INFO] Using expected exit node: $EXIT_NODE_IP"

    ### TODO: Notice that 'route -n get default` doesn't have a 'gateway' entry when the exit node is in place
    ### So this logic fails.
    # Check current default route
    CURRENT_DEFAULT=$(route -n get default 2>/dev/null | awk '/gateway:/ {print $2}')
    if [[ "$CURRENT_DEFAULT" == "$EXIT_NODE_IP" ]]; then
      echo "[INFO] Default route is exit node. Restoring local router..."
      sudo route delete default
      sudo route add default "$LOCAL_ROUTER_IP"
    fi

    # Apply custom routes
    echo "[INFO] Adding selective routes via exit node..."
    for ip in "''${ROUTE_VIA_EXIT_NODE[@]}"; do
      sudo route delete "$ip" 2>/dev/null
      sudo route add "$ip" "$EXIT_NODE_IP"
    done

    echo "[INFO] Done."

      '')}/bin/ts-exit-node-routes";
in
{
  security.sudo.extraConfig = ''
    josh ALL=(ALL) NOPASSWD: /sbin/route
  '';

  environment.userLaunchAgents = {
    tsexitroute = {
      enable = false;
      target = "com.josh.tsexitroute.plist";
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>com.josh.tsexitroute</string>
            <key>ProgramArguments</key>
            <array>
                <string>${ts-exit-node-routes}</string>
            </array>
            <key>EnvironmentVariables</key>
            <dict>
                <key>PATH</key>
                <string>/opt/homebrew/bin:/opt/homebrew/sbin:/Users/josh/bin:/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Users/josh/.nix-profile/bin:/etc/profiles/per-user/josh/bin:/nix/var/nix/profiles/default/bin</string>
            </dict>
            <key>StandardInPath</key>
            <string>/Users/josh/log/josh.tsexitroute.stdin</string>
            <key>StandardOutPath</key>
            <string>/Users/josh/log/josh.tsexitroute.stdout</string>
            <key>StandardErrorPath</key>
            <string>/Users/josh/log/josh.tsexitroute.stderr</string>
            <key>WorkingDirectory</key>
            <string>/Users/josh</string>
            <key>StartInterval</key>
            <integer>60</integer>
            <key>RunAtLoad</key>
            <true/>
          </dict>
        </plist>
      '';
    };
  };
}