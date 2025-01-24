let
  jjp4g = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINU9tIvUF2WU4Fsov/7/3pcmWJYXdsXh8oOAUDvQxVLm josh@JJP4G";
  backup_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF4a0q3EjFbIgz4kOeS24UTObOXUj6tn9VgbTy5gek49";
  jjp4g_plus_backup = [jjp4g backup_key];

in
{
  "calibre-smb-credentials.age".publicKeys = jjp4g_plus_backup;
}