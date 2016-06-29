/*******************************************************************************
 * Copyright (c) 2016 itemis AG (http://www.itemis.de) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
'use strict';
var net = require('net');
var vscode_lc = require('vscode-languageclient');
function activate(context) {
    var serverOptions = {
        port: 5007
    };
    var serverInfo = function () {
        // Connect to the language server via a socket channel
        var socket = net.connect(serverOptions);
        var result = {
            writer: socket,
            reader: socket
        };
        return Promise.resolve(result);
    };
    var clientOptions = {
        documentSelector: ['mydsl']
    };
    // Create the language client and start the client.
    var disposable = new vscode_lc.LanguageClient('Xtext Server', serverInfo, clientOptions).start();
    // Push the disposable to the context's subscriptions so that the 
    // client can be deactivated on extension deactivation
    context.subscriptions.push(disposable);
}
exports.activate = activate;
