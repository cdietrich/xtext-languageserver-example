import { isWindows } from '@theia/core/lib/common/os';
import { BaseLanguageServerContribution, IConnection } from '@theia/languages/lib/node';
import { injectable } from 'inversify';
import * as net from 'net';
import { join, resolve } from 'path';
import { createSocketConnection } from 'vscode-ws-jsonrpc/lib/server';
import { MYDSL_LANGUAGE_SERVER_ID, MYDSL_LANGUAGE_SERVER_NAME } from '../common';

const EXECUTABLE_NAME = isWindows ? 'mydsl-standalone.bat' : 'mydsl-standalone';
const EXECUTABLE_PATH = resolve(join(__dirname, '..', '..', 'build', 'org.xtext.example.mydsl.ide-1.0.0-SNAPSHOT', 'bin', EXECUTABLE_NAME));

@injectable()
export class MyDslLanguageServerContribution extends BaseLanguageServerContribution {

    readonly id = MYDSL_LANGUAGE_SERVER_ID;
    readonly name = MYDSL_LANGUAGE_SERVER_NAME;

    getPort(): number | undefined {
        let arg = process.argv.filter(arg => arg.startsWith('--STATES_LSP='))[0];
        if (!arg) {
            return undefined;
        } else {
            return Number.parseInt(arg.substring('--STATES_LSP='.length), 10);
        }
    }

    start(clientConnection: IConnection): void {
        let socketPort = this.getPort();
        if (socketPort) {
            const socket = new net.Socket();
            const serverConnection = createSocketConnection(socket, socket, () => {
                socket.destroy();
            });
            this.forward(clientConnection, serverConnection);
            socket.connect(socketPort);
        } else {
            const args: string[] = [];
            const serverConnection = this.createProcessStreamConnection(EXECUTABLE_PATH, args);
            this.forward(clientConnection, serverConnection);
        }
    }
}
