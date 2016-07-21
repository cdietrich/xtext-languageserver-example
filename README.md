# Xtext Visual Studio Code Example

This is an Example showing the Visual Studio Code integration of Xtext using the Microsoft Language Server Protocol.


[![Build Status](https://travis-ci.org/cdietrich/xtext-languageserver-example.svg?branch=master)](https://travis-ci.org/cdietrich/xtext-languageserver-example)

## Quickstart

- run `./build-all.sh`
- `code vscode-extension-self-contained/mydsl-sc-0.0.1.vsix`

## Building in Details

- run `npm install` inside vscode-extension
- run `npm install` vscode-extension-self-contained
- run `./gradlew build shadowJar` inside org.xtext.example.mydsl.parent
- run `./gradlew run` inside org.xtext.example.mydsl.parent or launch RunServer from Eclipse
- open `vscode-extension` in VS Code and `F5` to launch new editor (you may need a Debug -> Start Debugging initally)
- open `demo` in the new editor

## Build VS Code Extension Package

- `npm install -g vsce`
- `cd vscode-extension`
- `vsce package`
- `cd ../vscode-extension-self-contained`
- `vsce package`

## Installing to VS Code

- `code mydsl-0.0.1.vsix` (in vscode-extension)
- this requires a separate server started via fat jar (see below)
or
- `code mydsl-sc-0.0.1.vsix` (in vscode-extension-self-contained)
- this is selfcontained

File Open inside VS Code does basically the same.

## Building FAT Jar

- `cd org.xtext.example.mydsl.parent/org.xtext.example.mydsl.ide/`
- `gradle shadowJar`

## Run separate Server from FAT Jar
- `cd org.xtext.example.mydsl.parent/org.xtext.example.mydsl.ide/`
- `java -jar build/libs/org.xtext.example.mydsl.ide-1.0.0-SNAPSHOT-http-all.jar`

