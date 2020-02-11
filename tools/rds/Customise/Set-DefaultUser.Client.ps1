#   Windows 10

# Configure the default Start menu
If (!(Test-Path("$env:SystemDrive\Users\Default\AppData\Local\Microsoft\Windows"))) { New-Item -Value "$env:SystemDrive\Users\Default\AppData\Local\Microsoft\Windows" -ItemType Directory }
Import-StartLayout -LayoutPath .\Windows10StartMenuLayout.xml -MountPath "$($env:SystemDrive)\"
