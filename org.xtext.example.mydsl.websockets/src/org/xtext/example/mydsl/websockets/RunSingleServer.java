package org.xtext.example.mydsl.websockets;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.SocketAddress;
import java.util.concurrent.ExecutorService;
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
import com.pmeade.websocket.net.WebSocket;
import com.pmeade.websocket.net.WebSocketServerSocket;

/**
 * @author dietrich - Initial contribution and API
 */
public class RunSingleServer {

	public static void main(String[] args) throws InterruptedException, IOException {
		Injector injector = Guice.createInjector(new ServerModule());
		LanguageServerImpl languageServer = injector.getInstance(LanguageServerImpl.class);
		Function<MessageConsumer, MessageConsumer> wrapper = consumer -> {
			MessageConsumer result = consumer;
			return result;
		};
		ServerSocket serverSocket = new ServerSocket(4389);
		WebSocketServerSocket webSocketServerSocket = new WebSocketServerSocket(serverSocket);

		WebSocket webSocket = webSocketServerSocket.accept();
		try {

			Launcher<LanguageClient> launcher = createSocketLauncher(languageServer, LanguageClient.class,
					new InetSocketAddress("localhost", 4389), Executors.newCachedThreadPool(), wrapper,
					webSocket.getInputStream(), webSocket.getOutputStream());
			languageServer.connect(launcher.getRemoteProxy());
			Future<?> future = launcher.startListening();
			while (!future.isDone()) {
				Thread.sleep(10_000l);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			webSocketServerSocket.close();
		}

	}

	static <T> Launcher<T> createSocketLauncher(Object localService, Class<T> remoteInterface,
			SocketAddress socketAddress, ExecutorService executorService,
			Function<MessageConsumer, MessageConsumer> wrapper, InputStream inputStream, OutputStream outputStream)
			throws IOException {
		return Launcher.createIoLauncher(localService, remoteInterface, inputStream, outputStream, executorService,
				wrapper);
	}

}