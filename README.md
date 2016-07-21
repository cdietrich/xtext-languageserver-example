# Xtext Visual Studio Code Example

This is an Example showing the Visual Studio Code integration of Xtext using the Microsoft Language Server Protocol.


[![Build Status](https://travis-ci.org/cdietrich/xtext-languageserver-example.svg?branch=master)](https://travis-ci.org/cdietrich/xtext-languageserver-example)

## Quickstart

Requires Visual Studio Code (VS Code) to be on the path as `code`

- run `./gradlew startCode`

This will start VS Code and after a few seconds load the `demo` folder of this repository.
Right now VS Code does not allow a headless installation of extensions (see [#9585](https://github.com/Microsoft/vscode/issues/9585).)

## Project Structure

- `vscode-extension` (node based VS Code extension to run with a separate server using socket)
- `vscode-extension-self-contained` (node based VS Code extension to run with a embedded server using process io)
- `org.xtext.example.mydsl` (contains the dsl)
- `org.xtext.example.mydsl.ide` (contains the dsl specific customizations of the Xtext language server)
- `org.xtext.example.mydsl.tests`

## Building in Details

1. Run `./gradlew vscodeExtension` to build the DSL and the VS Code extensions.

### Scenario 1 (embedded server)

1. Install the self-contained extension into VS Code using
    `code vscode-extension-self-contained/build/vscode/vscode-extension-self-contained-0.0.1.vsix`
2. Run a second instance of vscode on the demo folder `code demo`

Note that there is currently no headless installation of vsix files - this is why we need to start the first instance.

### Scenario 2 (client-only with separate server process)

1. Run `./gradlew run` or launch RunServer from Eclipse.
2. Open `vscode-extension` in VS Code and `F5` to launch new editor (you may need a Debug -> Start Debugging initally).
1. Open folder `demo` in the new editor.


### Build VS Code Extension Package manually (manually Gradle)

```
npm install -g vsce
cd vscode-extension
vsce package
cd ../vscode-extension-self-contained
vsce package
```