# Xtext VS Code example

This is a simple example showing the [Xtext](https://www.eclipse.org/Xtext/) integration for VS Code based on the Microsoft [Language Server Protocol](https://github.com/Microsoft/language-server-protocol).

The base is following simple grammar

```
Model:
    greetings+=Greeting*;
    
Greeting:
    'Hello' name=ID ('from' from=[Greeting])? '!';
```

A typical example model would look like (Open a new folder in VSCode and create the files)

a.mydsl
```
Hello Xtext!
Hello VSCode from Xtext!
Hello ThisFile from Other!
Hello you!
```

b.mydsl
```
/* this is a definition in another file */
Hello Other!
```

The Xtext integration supports typical Xtext and Language Server features like

* Syntax Highlighting
* Validation
* Goto Definition / Find References
* Hover
* Formatting
* Mark Occurrences
* Open Symbol

A introductory article can be found [here](https://blogs.itemis.com/en/integrating-xtext-language-support-in-visual-studio-code)
