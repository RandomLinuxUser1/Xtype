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
chmod +x game.bash
```

after running the command above run this command :D

```bash
find ~ -name game.bash -exec sudo ln -sf {} /usr/local/bin/xtype \; -exec chmod +x {} \; -exec bash -c 'clear; echo "Installed! to play type 'xtype' in your terminal and click enter."' \; -quit
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
