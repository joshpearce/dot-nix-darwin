{ pkgs, config, lib, ... }: {

  age.secrets = {
    calibre-smb-credentials = {
      file = ./calibre-smb-credentials.age;
      owner = "josh";
      mode = "0440";
    };
  };
}