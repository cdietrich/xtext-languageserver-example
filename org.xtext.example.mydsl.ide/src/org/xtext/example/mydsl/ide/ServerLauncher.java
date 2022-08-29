/**
 * Copyright (c) 2016, 2022 itemis AG (http://www.itemis.de) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.mydsl.ide;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.concurrent.Future;

import org.eclipse.lsp4j.jsonrpc.Launcher;
import org.eclipse.lsp4j.services.LanguageClient;
import org.eclipse.xtext.ide.server.LanguageServerImpl;
import org.eclipse.xtext.ide.server.ServerModule;

import com.google.inject.Guice;
import com.google.inject.Inject;

/**
 * @author Sven Efftinge - Initial contribution and API
 * @since 2.11
 */
public class ServerLauncher {
	private static boolean IS_DEBUG = true;

	public static void main(final String[] args) throws Exception {
		InputStream stdin = System.in;
		PrintStream stdout = System.out;
		ServerLauncher.redirectStandardStreams();
		ServerLauncher launcher = Guice.createInjector(new ServerModule()).getInstance(ServerLauncher.class);
		launcher.start(stdin, stdout);
	}

	@Inject
	private LanguageServerImpl languageServer;

	public void start(final InputStream in, final OutputStream out) throws Exception {
		System.err.println("Starting Xtext Language Server.");
		String id = ServerLauncher.class.getName() + "-"
				+ new Timestamp(System.currentTimeMillis()).toString().replaceAll(" ", "_");
		Launcher<LanguageClient> launcher = Launcher.createLauncher(languageServer, LanguageClient.class, in, out, true,
				new PrintWriter(new FileOutputStream((("/Users/dietrich/logs/xxx-" + id) + ".log")), true));
		languageServer.connect(launcher.getRemoteProxy());
		Future<Void> future = launcher.startListening();
		System.err.println("started.");
		while (!future.isDone()) {
			Thread.sleep(10_000l);
		}
	}

	public static void redirectStandardStreams() throws Exception {
		System.setIn(new ByteArrayInputStream(new byte[0]));
		String id = ServerLauncher.class.getName() + "-"
				+ new Timestamp(System.currentTimeMillis()).toString().replaceAll(" ", "_");
		if (ServerLauncher.IS_DEBUG) {
			FileOutputStream stdFileOut = new FileOutputStream((("/Users/dietrich/logs/out-" + id) + ".log"));
			System.setOut(new PrintStream(stdFileOut, true));
			FileOutputStream stdFileErr = new FileOutputStream((("/Users/dietrich/logs/error-" + id) + ".log"));
			System.setErr(new PrintStream(stdFileErr, true));
		} else {
			System.setOut(new PrintStream(new ByteArrayOutputStream()));
			System.setErr(new PrintStream(new ByteArrayOutputStream()));
		}
	}
}
