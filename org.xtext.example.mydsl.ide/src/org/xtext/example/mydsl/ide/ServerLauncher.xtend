/*******************************************************************************
 * Copyright (c) 2016 itemis AG (http://www.itemis.de) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package org.xtext.example.mydsl.ide

import com.google.inject.Guice
import com.google.inject.Inject
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.FileOutputStream
import java.io.InputStream
import java.io.OutputStream
import java.io.PrintStream
import java.io.PrintWriter
import java.sql.Timestamp
import org.eclipse.lsp4j.jsonrpc.Launcher
import org.eclipse.lsp4j.services.LanguageClient
import org.eclipse.xtext.ide.server.LanguageServerImpl
import org.eclipse.xtext.ide.server.ServerModule

/**
 * @author Sven Efftinge - Initial contribution and API
 * @since 2.11
 */
class ServerLauncher {

	static boolean IS_DEBUG = true

	def static void main(String[] args) {
		//IS_DEBUG = args.exists[it == 'debug']
		val stdin = System.in
		val stdout = System.out
		redirectStandardStreams()
		val launcher = Guice.createInjector(new ServerModule()).getInstance(ServerLauncher)
		launcher.start(stdin, stdout)
	}

	@Inject LanguageServerImpl languageServer

	def void start(InputStream in, OutputStream out) {
		System.err.println("Starting Xtext Language Server.")
		val id = ServerLauncher.name + "-" + (new Timestamp(System.currentTimeMillis)).toString.replaceAll(" ","_")
		val launcher = Launcher.createLauncher(languageServer, LanguageClient, in, out, true, new PrintWriter(new FileOutputStream("/Users/dietrich/logs/xxx-"+id+".log"), true))
		languageServer.connect(launcher.remoteProxy)
		val future = launcher.startListening
		System.err.println("started.")
		while (!future.done) {
			Thread.sleep(10_000l)
		}
	}

	def static redirectStandardStreams() {
		System.setIn(new ByteArrayInputStream(newByteArrayOfSize(0)))
		val id = ServerLauncher.name + "-" + (new Timestamp(System.currentTimeMillis)).toString.replaceAll(" ","_")
		if (IS_DEBUG) {
			val stdFileOut = new FileOutputStream("/Users/dietrich/logs/out-" + id + ".log")
			System.setOut(new PrintStream(stdFileOut, true))
			val stdFileErr = new FileOutputStream("/Users/dietrich/logs/error-" + id + ".log")
			System.setErr(new PrintStream(stdFileErr, true))
		} else {
			System.setOut(new PrintStream(new ByteArrayOutputStream()))
			System.setErr(new PrintStream(new ByteArrayOutputStream()))
		}
	}

}
