{ pkgs, config, lib, ... }: 

{
    users = {
        users = {
            josh = {
                home = "/Users/josh";
                description = "Joshua Pearce";
           };
        };
    };
}