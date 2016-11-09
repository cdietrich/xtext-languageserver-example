package org.xtext.example.mydsl.ide;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.function.Function;

import org.eclipse.lsp4j.jsonrpc.Launcher;
import org.eclipse.lsp4j.jsonrpc.MessageConsumer;
import org.eclipse.lsp4j.services.LanguageClient;
import org.eclipse.xtext.ide.server.LanguageServerImpl;
import org.eclipse.xtext.ide.server.ServerModule;

import com.google.inject.Guice;
import com.google.inject.Injector;

/**
 * @author dietrich - Initial contribution and API
 */
public class RunServer {

	public static void main(String[] args) throws InterruptedException, IOException {
		Injector injector = Guice.createInjector(new ServerModule());
		LanguageServerImpl languageServer = injector.getInstance(LanguageServerImpl.class);
		Function<MessageConsumer, MessageConsumer> wrapper = consumer -> {
			MessageConsumer result = consumer;
			return result;
		};
		Launcher<LanguageClient> launcher = Launcher.createSocketLauncher(languageServer, LanguageClient.class, new InetSocketAddress("localhost", 5007), Executors.newCachedThreadPool(), wrapper);
		languageServer.connect(launcher.getRemoteProxy());
		Future<?> future = launcher.startListening();
		while (!future.isDone()) {
			Thread.sleep(10_000l);
		}
	}

}