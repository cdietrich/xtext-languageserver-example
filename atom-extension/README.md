# Xtext Atom example

This is a simple example showing the [Xtext](https://www.eclipse.org/Xtext/) integration into [Atom](https://atom.io/) based on the Microsoft [Language Server Protocol](https://github.com/Microsoft/language-server-protocol) and the [Atom Language Client](https://github.com/atom/atom-languageclient).

First build the vscode extension in parent. `./gradlew clean build vscodeExtension atomExtension` (in the parent folder).
Start the extension in atom dev model with `apm link --dev; atom -d "$(pwd)/../demo/"` (in this folder).

Make sure you have `atom-ide-ui` and `autocomplete-plus` installed in Atom.