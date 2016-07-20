## Quickstart

- run `./gradlew build` inside org.xtext.example.mydsl.parent
- run `npm install` inside vscode-extension
- run `./gradlew run` inside org.xtext.example.mydsl.parent or launch RunServer from Eclipse
- open `vscode-extension` in VS Code and `F5` to launch new editor (you may need a Debug -> Start Debugging initally)
- open `demo` in the new editor

## Build VS Code Extension Package

- `npm install -g vsce`
- `cd scode-extension`
- `vsce package

## Installing to VS Code

- `code mydsl-0.0.1.vsix` 

## Building FAT Jar

- `cd org.xtext.example.mydsl.parent/org.xtext.example.mydsl.ide/`
- `gradle shadowJar`

## Run Server from FAT Jar
- `cd org.xtext.example.mydsl.parent/org.xtext.example.mydsl.ide/`
- `java -jar build/libs/org.xtext.example.mydsl.ide-1.0.0-SNAPSHOT-all.jar`


[![Build Status](https://travis-ci.org/cdietrich/xtext-languageserver-example.svg?branch=master)](https://travis-ci.org/cdietrich/xtext-languageserver-example)
