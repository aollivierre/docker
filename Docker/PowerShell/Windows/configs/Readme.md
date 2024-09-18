Host my_pwsh_container_20240703142218
    HostName 172.18.137.190
    User ssh
    Port 22
    AddKeysToAgent yes

    # I could not get private/public key pair to work with OpenSSH server running inside a Windows Docker Container
    # I need to do more testing by going back to the guide I create on SSH with WinSCP and PuTTY without Docker for now but use a newer version of OpenSSH like 9.5
    # IdentityFile C:\Users\Administrator\.ssh\id_rsa 

    # Windows Host defined after the first time you SSH into the user settings JSON file under remote platform section as an example:
    # "remote.SSH.remotePlatform": {
    #     "my_pwsh_container_20240703142218": "windows"
    # }
    RemoteCommand code --wait
    ForwardAgent yes
