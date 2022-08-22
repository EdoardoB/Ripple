# Ripple 🌊

Welcome to **Ripple** - a command line tool that reports unused localization strings in your Xcode project.

## Install

### Clone from repo

```bash
git clone 
cd Ripple
swift build -c release
sudo cp .build/release/Ripple /usr/local/bin/ripple
```

## Usage

Navigate to your project folder, then:

```shell
ripple
```

This command will scan current folder to find unused localized strings.

To get help you can use:

```shell
ripple --help

   -p, --project: 
       Root path of your Xcode project. Default is current folder.
   -e, --exclude:
     Exclude paths from search.
   --version:
       Print tool version.
   -h, --help:
       HELP ME!
```

### Command line example

```shell
 ripple --exclude Pods
```

This command will search in current folder and skip `Pods` folder. It is recommended that you exclude third party folders.

### Use in Xcode build phase
You can integrate Ripple into your Xcode build process, so every time you build your project Ripple informs you about all unused localized strings.

Add a "Run Script" phase in the Build Phases tab:
![image](https://user-images.githubusercontent.com/11717088/185915297-5244d438-a884-4d94-99ba-71e5f3bed78c.png)

And add this:

```bash
if which Ripple > /dev/null; then
  Ripple -e Pods
else
  echo "warning: Ripple not installed, download from https://github.com/EdoardoB/Ripple"
fi
```
