# PLEASE READ!


-------------------------------------
INSTALLATION INSTRUCTIONS

btw if you dont have git install on linux run these commands

- FOR DEBAIN BASED DISTROS (apt)
```bash
sudo apt install git
```
- FOR DISTROS LIKE FEDORA RUN THIS COMMAND
```bash
sudo dnf install git
```
- FOR DISTROS BASED ON ARCH LIKE ENDEVOUR OS RUN THIS COMMAND
```bash
sudo pacman -S git
```
- DISTRONS THAT USE YUM (like centOS
```bash
sudo yum install git 
```

Now that you have git installed you can continue with installing xtype :D

First clone the repository:
```bash
git clone https://github.com/RandomLinuxUser1/Xtype.git
```

now run this command

```bash
cd Xtype
```

once your in there run this command 

```bash
chmod +x bootstrapper.sh
```

after running the command above run this command :D

```bash
    sudo ln -sf $(pwd)/bootstrapper.sh /usr/local/bin/xtype
```


now once youve installed the game run the following command:

```bash
xtype
```



Your typing stats are saved here:

~/.xtype_stats


To uninstall run this command :D

```bash
sudo rm /usr/local/bin/xtype ~/.xtype_stats
```

# why to use Xtype

No ads

No tracking

No JavaScript

No subscriptions

Just pure typing practice
