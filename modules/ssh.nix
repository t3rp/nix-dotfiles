{ pkgs, ... }:

{
	home.packages = with pkgs; [
		openssh
		yubikey-manager
	];

	# Use a dedicated OpenSSH agent socket instead of the GNOME/GCR agent.
	home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";

	systemd.user.sockets.ssh-agent = {
		Unit = {
			Description = "OpenSSH agent socket";
		};
		Socket = {
			ListenStream = "%t/ssh-agent.socket";
			SocketMode = "0600";
		};
		Install = {
			WantedBy = [ "sockets.target" ];
		};
	};

	systemd.user.services.ssh-agent = {
		Unit = {
			Description = "OpenSSH agent";
		};
		Service = {
			Type = "simple";
			Environment = [ "SSH_AUTH_SOCK=%t/ssh-agent.socket" ];
			ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a %t/ssh-agent.socket";
		};
		Install = {
			WantedBy = [ "default.target" ];
		};
	};

	programs.ssh = {
		enable = true;

		extraConfig = ''
			Host *
				IdentityAgent ${"$SSH_AUTH_SOCK"}
				AddKeysToAgent yes
				IdentitiesOnly yes

			Host github.com
				HostName github.com
				User git
				IdentityFile ~/.ssh/id_ed25519_sk_rk
		'';
	};
}
