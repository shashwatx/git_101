# Before you begin
1. __Enable WSL__.

Follow instructions [here](https://winaero.com/blog/enable-wsl-windows-10-fall-creators-update/).

2. __Install MobaXTerm__.

Follow instructions [here](https://mobaxterm.mobatek.net/download-home-edition.html).

3. __Install Ubuntu App__.

Follow instructions [here](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6).

4. __Fetch Gitlab Token__.

Follow instructions [here](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)

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

4. __Create__ symbolic link to parent windows folder.
```
cd ~
ln -s /mnt/c/Users/shashwat.mishra/Documents/repos
```

# Using Git

## Creating Repositories

1. __Create a new repository for a new project__.
```
cd ~/repos
mkdir my_first_git_repository
cd my_first_git_repository
git create -u shashwat.mishra -t <access_token> -i
touch my_first_file.txt
# edit my_first_file
git add my_first_file.txt
git commit -m "adding first version of files"
git push
```

2. __Create a new repository for an existing project__.
```
cd ~/repos
cd my_existing_project
git create -u shashwat.mishra -t <access_token> -i
# add all relevant files
# use .gitignore to prevent uploading large files
git add .
git commit -m "adding first version of files"
git push
```

3. __Clone an existing repository__.
```
cd ~/repos
git clone https://git.babel.es:4433/shashwat.mishra/my_first_git_repository.git
```

## Workflows   

1. __Simple Workflow__.
```
# assuming you are inside the parent directory of the repository.
# modify some file
git add -u
git commit -m "master: my super informative commit message"
git push
```

2. __Branch and Merge: Variant 1__

Create a branch and work on it.
```
git checkout -b branch_0
# modify some file
git commit -m "branch_0: another informative commit message"
git push
```
Merge branch _branch\_0_ onto branch _master_.
```
git checkout branch_0
git pull
git checkout master
git merge branch_0 --no-commit --no-ff
```

3. __Branch and Merge: Variant 2__
Create a branch and work on it.
```
git checkout -b branch_1
# modify some file
git commit -m "branch_1: another informative commit message"
git push
```
Meanwhile, branch _master_ has received some commits.
```
git checkout master
# modify some file
git commit -m "master: another informative commit message"
git push
```
Merge branch_1 onto branch _master_.
```
git checkout branch_1
git pull
git checkout master
git merge branch_1 --no-commit --no-ff
```
Automatic merge should fail.
Additionally, you must see some conflicts.
Resolve conflicts, commit, push.

