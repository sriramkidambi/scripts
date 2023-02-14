import subprocess 
# ASCII art
art = """
         _nnnn_                      
        dGGGGMMb     ,"""""""""""""".
       @p~qp~~qMb    | Please wait  |
       M|@||@) M|   _;..............'
       @,----.JM| -'
      JS^\__/  qKL
     dZP        qKRb
    dZP          qKKb
   fZP            SMMb
   HZM            MMMM
   FqM            MMMM
 __| ".        |\dS"qML
 |    `.       | `' \Zq
_)      \.___.,|     .'
\____   )MMMMMM|   .'
     `-'       `--' hjm
"""

print(art)

# Update the package repository 
subprocess.run(["sudo", "apt-get", "update"])

# Install git 
subprocess.run(["sudo", "apt-get", "install", "-y", "git", "curl" ])

# Installs deb-get 
subprocess.run(["sudo", "curl", "-sL", "https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get" ])

subprocess.run(["sudo", "-E", "-s", "install", "deb-get" ])

subprocess.run(["deb-get", "install", "discord", "brave-browser", "google-chrome-stable", "obsidian", "spotify-client", "sublime-text", "code"])

