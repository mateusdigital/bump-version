# bump-version

A simple version bumper tool.

**Made with <3 by [mateus.digital](https://mateus.digital).**

## Description:

<p align="center">
    <img style="border-radius: 10px;" src="./resources/readme_game.gif"/>
</p>

```bump-version``` is a small utility that mimics the "npm version".

<br>

Unlike _"npm version"_, ```bump-version``` has the possibility of working 
with ```build``` numbers alongside the usual ```major```, ```minor``` and ```patch```.  

Also ```bump-version``` can operate in *any* _json file_, not only in the _"package.json"_.

<br>

As usual, you are **very welcomed** to **share** and **hack** it.


## Usage
```
Usage:
  bump-version -h | -v
  bump-version --major | --minor | --patch | --build [value]
  bump-version [path]

Options:
  *-h --help     : Show this screen.
  *-v --version  : Show app version and copyright.

  --major [value]: Increment or set major version number.
  --minor [value]: Increment or set minor version number.
  --patch [value]: Increment or set patch version number.
  --build [value]: Increment or set patch version number.

Notes:
  If [path] is blank the current ./package.json is assumed.
  If [path] is directory the current [path]/package.json is assumed.

  Options marked with * are exclusive, i.e. the bump-version will run that
  and exit after the operation.
```

## Install 

```powershell
git clone https://github.com/mateusdigital/bump-version
cd bump-version

npm install   ## Install npm dependencies.
npm run build ## Build the project
```

## License:

This software is released under [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).


## Others:

- Email: hello@mateus.digital
- Website: https://mateus.digital
- Itch.io: https://mateusdigital.itch.io
- Linkedin: https://www.linkedin.com/in/mateusdigital
- Twitter: https://www.twitter.com/_mateusdigital
- Youtube: https://www.youtube.com/@_mateusdigital

There's more FLOSS things at [mateus.digital](https://mateus.digital) :)
