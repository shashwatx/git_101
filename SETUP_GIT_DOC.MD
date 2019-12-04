# Before you begin
1. __Enable WSL__.

Follow instructions [here](https://winaero.com/blog/enable-wsl-windows-10-fall-creators-update/).

2. __Install MobaXTerm__.

Follow instructions [here](https://mobaxterm.mobatek.net/download-home-edition.html).

3. __Install Ubuntu App__.

Follow instructions [here](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6).


# Install Dependencies in Ubuntu

1. __Install__ git if not already installed.
```
sudo -i
apt-get update
apt-get install -y git
exit
```

2. __Setup__ _gitconfig_.
```
cd ~
mkdir scratch
cd ~/scratch
wget https://raw.githubusercontent.com/shashwatx/git_101/master/resources/gitconfig_sample 
```
Modify the file _gitconfig\_sample_ with your details and copy it to your home.
```
cp gitconfig_sample ~/.gitconfig
```

3. __Setup__ _git-create_.
```
wget https://raw.githubusercontent.com/shashwatx/git_101/master/scripts/git-create
sudo chmod 755 git-create
sudo cp git-create /usr/bin/git-create
```

