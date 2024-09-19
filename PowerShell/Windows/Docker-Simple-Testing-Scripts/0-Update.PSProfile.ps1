#Add the following function to your $Profile

function rpd {
    param (
        [string]$localScriptPath
    )
    
    # Dot-source the Docker script to make the 'runpsindocker' function available in the current session
    . "C:\code\docker\PowerShell\Windows\Docker-Simple-Testing-Scripts\0.1-RunPSwithDocker.ps1"

    # Call the 'runpsindocker' function with the provided script path
    runpsindocker $localScriptPath
}


#Example usage

# rpd "C:\code\M365Fullv6-Timer2\Install.ps1"
