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

import javax.inject.Inject;

import org.eclipse.lsp4j.jsonrpc.Launcher;
import org.eclipse.lsp4j.services.LanguageClient;
import org.eclipse.xtext.ide.server.LanguageServerImpl;
import org.eclipse.xtext.ide.server.ServerModule;

import com.google.inject.Guice;
import com.google.inject.util.Modules;

public class MultiProjectServerLauncher {
	private static boolean IS_DEBUG = false;

	public static void main(String[] args) throws Exception {
		InputStream stdin = System.in;
		PrintStream stdout = System.out;
		MultiProjectServerLauncher.redirectStandardStreams();
		ServerLauncher launcher = Guice
				.createInjector(Modules.override(new ServerModule()).with(new CustomServerModule()))
				.getInstance(ServerLauncher.class);
		launcher.start(stdin, stdout);
	}

	@Inject
	private LanguageServerImpl languageServer;

	public void start(InputStream in, OutputStream out) throws Exception {
		System.err.println("Starting Xtext Language Server.");
		Launcher<LanguageClient> launcher = Launcher.createLauncher(languageServer, LanguageClient.class, in, out, true,
				new PrintWriter(System.out));
		languageServer.connect(launcher.getRemoteProxy());
		Future<Void> future = launcher.startListening();
		System.err.println("started.");
		while (!future.isDone()) {
			Thread.sleep(10_000l);
		}
	}

	public static void redirectStandardStreams() throws Exception {
		ByteArrayInputStream _byteArrayInputStream = new ByteArrayInputStream(new byte[0]);
		System.setIn(_byteArrayInputStream);
		final String id = org.eclipse.xtext.ide.server.ServerLauncher.class.getName() + "-"
				+ new Timestamp(System.currentTimeMillis());
		if (MultiProjectServerLauncher.IS_DEBUG) {
			FileOutputStream stdFileOut = new FileOutputStream((("out-" + id) + ".log"));
			System.setOut(new PrintStream(stdFileOut));
			FileOutputStream stdFileErr = new FileOutputStream((("error-" + id) + ".log"));
			System.setErr(new PrintStream(stdFileErr));
		} else {
			ByteArrayOutputStream _byteArrayOutputStream = new ByteArrayOutputStream();
			System.setOut(new PrintStream(_byteArrayOutputStream));
			ByteArrayOutputStream _byteArrayOutputStream_1 = new ByteArrayOutputStream();
			System.setErr(new PrintStream(_byteArrayOutputStream_1));
		}
	}
}
