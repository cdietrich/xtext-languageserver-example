# Theia with VSCode

```
mkdir plugins && cp ../vscode-extension-self-contained/build/vscode/vscode-extension-self-contained-*.vsix plugins/
yarn
yarn theia build
yarn theia start ../demo --hostname 0.0.0.0 --port 8080 --plugins=local-dir:plugins
```