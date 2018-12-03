package org.xtext.example.mydsl.ide

import com.google.inject.Guice
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.FileOutputStream
import java.io.InputStream
import java.io.OutputStream
import java.io.PrintStream
import java.io.PrintWriter
import java.sql.Timestamp
import javax.inject.Inject
import org.eclipse.lsp4j.jsonrpc.Launcher
import org.eclipse.lsp4j.services.LanguageClient
import org.eclipse.xtext.ide.server.LanguageServerImpl
import org.eclipse.xtext.ide.server.ServerModule
import com.google.inject.util.Modules

class MultiProjectServerLauncher {
	
	static boolean IS_DEBUG = false

	def static void main(String[] args) {
		val stdin = System.in
		val stdout = System.out
		redirectStandardStreams()
		val launcher = Guice.createInjector(Modules.override(new ServerModule()).with(new CustomServerModule())).getInstance(ServerLauncher)
		launcher.start(stdin, stdout)
	}

	@Inject LanguageServerImpl languageServer

	def void start(InputStream in, OutputStream out) {
		System.err.println("Starting Xtext Language Server.")
		val launcher = Launcher.createLauncher(languageServer, LanguageClient, in, out, true, new PrintWriter(System.out))
		languageServer.connect(launcher.remoteProxy)
		val future = launcher.startListening
		System.err.println("started.")
		while (!future.done) {
			Thread.sleep(10_000l)
		}
	}

	def static redirectStandardStreams() {
		System.setIn(new ByteArrayInputStream(newByteArrayOfSize(0)))
		val id = org.eclipse.xtext.ide.server.ServerLauncher.name + "-" + new Timestamp(System.currentTimeMillis)
		if (IS_DEBUG) {
			val stdFileOut = new FileOutputStream("out-" + id + ".log")
			System.setOut(new PrintStream(stdFileOut))
			val stdFileErr = new FileOutputStream("error-" + id + ".log")
			System.setErr(new PrintStream(stdFileErr))
		} else {
			System.setOut(new PrintStream(new ByteArrayOutputStream()))
			System.setErr(new PrintStream(new ByteArrayOutputStream()))
		}
	}
	
}