{ pkgs, ... }:

{
	programs.ssh = {
		enable = true;
		enableDefaultConfig = false;
		matchBlocks = {
			"*" = {
				addKeysToAgent = "yes";
				identitiesOnly = true;
				identityAgent = "$SSH_AUTH_SOCK";
			};

			"github.com" = {
				hostname = "github.com";
				user = "git";
				identitiesOnly = true;
				identityFile = [ "~/.ssh/id_ed25519_sk_rk" ];
			};
		};
	};
}
