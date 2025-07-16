{ lib, pkgs, ... }: 
let
  rsync = lib.getExe pkgs.rsync;
  josh-backup-script = "${(pkgs.writeShellScriptBin "josh-backup-script" ''
    export SSH_AUTH_SOCK=""
    ${rsync} -v -a -e "ssh -F none -i $HOME/.ssh/nas" "/Users/josh/Documents" josh@nas.jjpdev.com:/share/backup/JJP4G/
    ${rsync} -v -a -e "ssh -F none -i $HOME/.ssh/nas" "/Users/josh/Desktop" josh@nas.jjpdev.com:/share/backup/JJP4G/
    ${rsync} -v -a -e "ssh -F none -i $HOME/.ssh/nas" "/Users/josh/.ssh" josh@nas.jjpdev.com:/share/backup/JJP4G/home/
    ${rsync} -v -a -e "ssh -F none -i $HOME/.ssh/nas" "/Users/josh/.zshrc" josh@nas.jjpdev.com:/share/backup/JJP4G/home/
    ${rsync} -v -a -e "ssh -F none -i $HOME/.ssh/nas" "/Users/josh/.age" josh@nas.jjpdev.com:/share/backup/JJP4G/home/
    ${rsync} -v -a -e "ssh -F none -i $HOME/.ssh/nas" "/Users/josh/code" josh@nas.jjpdev.com:/share/backup/JJP4G/home/
    ${rsync} -v -a -e "ssh -F none -i $HOME/.ssh/nas" "/Users/josh/track-docs" josh@nas.jjpdev.com:/share/backup/JJP4G/home/
    ${rsync} -v -a -e "ssh -F none -i $HOME/.ssh/nas" "/Users/josh/Library/Containers/com.microsoft.onenote.mac/Data/Library/Application Support/Microsoft User Data/OneNote/15.0/Backup" josh@nas.jjpdev.com:/share/backup/JJP4G/OneNote/Backup/
  '')}/bin/josh-backup-script";
in
{
  environment.userLaunchAgents = {
    backup = {
      enable = true;
      target = "com.josh.backup-v2.plist";
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>com.josh.backup</string>
            <key>ProgramArguments</key>
            <array>
                <string>/usr/local/bin/runitor</string>
                <string>-slug</string>
                
                <string>jjp4g-rsync-to-nas</string>
                <string>--</string>
                <string>${josh-backup-script}</string>
            </array>
            <key>EnvironmentVariables</key>
            <dict>
                <key>HC_PING_KEY</key>
                <string>IzOqX2lVa9r4URR9Ir2NGQ</string>
            </dict>
            <key>StandardInPath</key>
            <string>/Users/josh/log/josh.backup.stdin</string>
            <key>StandardOutPath</key>
            <string>/Users/josh/log/josh.backup.stdout</string>
            <key>StandardErrorPath</key>
            <string>/Users/josh/log/josh.backup.stderr</string>
            <key>WorkingDirectory</key>
            <string>/Users/josh</string>
            <key>StartCalendarInterval</key>
            <dict>
                <key>Hour</key>
                <integer>8</integer>
                <key>Minute</key>
                <integer>0</integer>
            </dict>
          </dict>
        </plist>
      '';
    };
  };
}