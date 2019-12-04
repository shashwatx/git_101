# Before you begin
1. Enable WSL
[Instructions](https://winaero.com/blog/enable wsl windows 10 fall creators update/)
2. Install MobaXTerm
[Instructions](https://mobaxterm.mobatek.net/download-home-edition.html)_
3. Install Ubuntu App
[Link](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6)

# Install Dependencies in Ubuntu
1. Install git if not already installed.
```
sudo -i
apt-get update
apt-get install -y git
exit
```

2. Setup _gitconfig_.
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

3. Setup _git-create_.
```
wget https://raw.githubusercontent.com/shashwatx/git_101/master/scripts/git-create
sudo chmod 755 git-create
sudo cp git-create /usr/bin/git-create
```

## Git: Key Concepts.
1. What is git?
2. History
3. Install git
4. Create repository on gitlab.
5. Setup github account. Create repository web.
6. Create repository command line.

## Git: Basic Workflow.
1. status
2. add
3. commit
4. push

## Git: Diving Deeper
1. branches
2. pull
3. merge
  1. conflicts
4. rebase?

## Git: Final Notes.
1. Setup .gitconfig
2. Store password
