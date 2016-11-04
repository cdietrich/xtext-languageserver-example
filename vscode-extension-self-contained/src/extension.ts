'use strict';

import * as path from 'path';

import {Trace} from 'vscode-jsonrpc';
import { workspace, ExtensionContext } from 'vscode';
import { LanguageClient, LanguageClientOptions, ServerOptions } from 'vscode-languageclient';

export function activate(context: ExtensionContext) {
    // The server is a locally installed self contained jar
    let jar = context.asAbsolutePath(path.join('src', 'mydsl-full.jar'));
    
    let serverOptions: ServerOptions = {
        run : { command: "java", args:['-jar', jar] },
        debug: { command: "java", args: ['-Xdebug','-Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n,quiet=y','-Xmx256m','-jar', jar] }
    };
    
    let clientOptions: LanguageClientOptions = {
        documentSelector: ['mydsl'],
        synchronize: {
            fileEvents: workspace.createFileSystemWatcher('**/*.*')
        }
    };
    
    // Create the language client and start the client.
    let lc = new LanguageClient('Xtext Server', serverOptions, clientOptions);
    // enable tracing (.Off, .Messages, Verbose)
    lc.trace = Trace.Verbose;
    let disposable = lc.start();
    
    // Push the disposable to the context's subscriptions so that the 
    // client can be deactivated on extension deactivation
    context.subscriptions.push(disposable);
}