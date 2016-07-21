# Xtext Visual Studio Code Example

This is an Example showing the Visual Studio Code integration of Xtext using the Microsoft Language Server Protocol.


[![Build Status](https://travis-ci.org/cdietrich/xtext-languageserver-example.svg?branch=master)](https://travis-ci.org/cdietrich/xtext-languageserver-example)

## Quickstart

- Run `./build-all.sh`
- `code vscode-extension-self-contained/mydsl-sc-0.0.1.vsix`

(see also Troubleshooting)

## Project Structure

- `vscode-extension` (node based VS Code extension to run with a separate server using socket)
- `vscode-extension-self-contained` (node based VS Code extension to run with a embedded server using process io)
- `org.xtext.example.mydsl.parent` (containing a example dsl)
 - `org.xtext.example.mydsl` (contains the dsl)
 - `org.xtext.example.mydsl.ide` (contains the ide part and the interesting parts)
 - `org.xtext.example.mydsl.tests`


## Building in Details

1. Run `npm install` inside folder `vscode-extension`.
1. Run `npm install` inside folder `vscode-extension-self-contained`.
1. Run `./gradlew build shadowJar` inside folder `org.xtext.example.mydsl.parent`.
1. Run `./gradlew run` inside `org.xtext.example.mydsl.parent` or launch RunServer from Eclipse.
1. Open `vscode-extension` in VS Code and `F5` to launch new editor (you may need a Debug -> Start Debugging initally).
1. Open folder `demo` in the new editor.

## Build VS Code Extension Package

```
npm install -g vsce
cd vscode-extension
vsce package
cd ../vscode-extension-self-contained
vsce package
```

## Installing to VS Code

- `code mydsl-0.0.1.vsix` (in vscode-extension)
- this requires a separate server started via fat jar (see below)
or
- `code mydsl-sc-0.0.1.vsix` (in vscode-extension-self-contained)
- this is selfcontained

Alternatively open one of the `.vsix` files with *File -> Open* in VS Code.

## Building FAT Jar

- `cd org.xtext.example.mydsl.parent/org.xtext.example.mydsl.ide/`
- `gradle shadowJar`

## Run separate server from FAT Jar
- `cd org.xtext.example.mydsl.parent/org.xtext.example.mydsl.ide/`
- `java -jar build/libs/org.xtext.example.mydsl.ide-1.0.0-SNAPSHOT-http-all.jar`

## Troubleshooting

### Permission problem on /usr/local/lib/node_modules
When executing `build_all.sh` on some systems you will have a permission problem on the `node_modules`. This will print the message

```
npm WARN checkPermissions Missing write access to /usr/local/lib/node_modules
```

In this case install vcse manually with the command

```
sudo npm install vsce -g
```
