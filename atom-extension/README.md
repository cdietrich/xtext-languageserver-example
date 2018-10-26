# Xtext Atom example

This is a simple example showing the [Xtext](https://www.eclipse.org/Xtext/) integration into [Atom](https://atom.io/) based on the Microsoft [Language Server Protocol](https://github.com/Microsoft/language-server-protocol) and the [Atom Language Client](https://github.com/atom/atom-languageclient).

First build the vscode extension in parent. `./gradlew clean build vscodeExtension`.
Then copy the language server from there `cp -r ../vscode-extension-self-contained/src/mydsl/ lib/mydsl`.
Build the extension `npm install`.
Start the extension in atom dev model with `apm link --dev; atom -d "$(pwd)/../demo/"`.

Make sure you have `atom-ide-ui` and `autocomplete-plus` installed in Atom.