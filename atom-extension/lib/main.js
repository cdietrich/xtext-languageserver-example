const {AutoLanguageClient} = require('atom-languageclient');
const cp = require('child_process');
const os = require("os");
const path = require("path");
class MyDslLanguageClient extends AutoLanguageClient {
    getGrammarScopes() {
        return ['source.mydsl']
    }
 
    getLanguageName() {
        return 'MyDsl (Xtext)'
    }
 
    getServerName() {
        return 'MyDsl (Xtext) Language Server'
    }
 
    startServerProcess(projectPath) {
        const serverHome = path.join(__dirname, 'mydsl');
        const args = [];
        let launcher = os.platform() === 'win32' ? 'mydsl-standalone.bat' : 'mydsl-standalone';
        let script = path.join(__dirname, 'mydsl', 'bin', launcher)
        const childProcess = cp.spawn(script, args,{ cwd: serverHome });
        this.captureServerErrors(childProcess);
        childProcess.on('close', exitCode => {
            if (!childProcess.killed) {
                atom.notifications.addError('IDE-MyDsl language server stopped unexpectedly.', {
                    dismissable: true,
                    description: this.processStdErr ? `<code>${this.processStdErr}</code>` : `Exit code ${exitCode}`
                })
            }
        });
        return childProcess;
    }
}
 
module.exports = new MyDslLanguageClient();