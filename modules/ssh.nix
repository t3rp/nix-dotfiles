{ pkgs, ... }:

{
	programs.ssh = {
		enable = true;
		enableDefaultConfig = false;
		matchBlocks = {
			"*" = {
				# Fixes yubikey SSH "agent refused operation" errors
				# https://discussion.fedoraproject.org/t/ssh-agent-refused-operation-with-non-resident-pin-protected-key/94206/3
				identityAgent = "none";
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
