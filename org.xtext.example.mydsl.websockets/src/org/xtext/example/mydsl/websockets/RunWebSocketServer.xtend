package org.xtext.example.mydsl.websockets

import com.google.inject.Guice
import com.google.inject.Injector
import com.pmeade.websocket.net.WebSocket
import com.pmeade.websocket.net.WebSocketServerSocket
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream
import java.net.ServerSocket
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.Future
import java.util.function.Function
import org.eclipse.lsp4j.jsonrpc.Launcher
import org.eclipse.lsp4j.jsonrpc.MessageConsumer
import org.eclipse.lsp4j.services.LanguageClient
import org.eclipse.xtext.ide.server.LanguageServerImpl
import org.eclipse.xtext.ide.server.ServerModule
import org.eclipse.xtext.util.internal.Log

@Log class RunWebSocketServer {
	def static void main(String[] args) throws InterruptedException, IOException {
		var Injector injector = Guice.createInjector(new ServerModule())
		var ServerSocket serverSocket = new ServerSocket(4389)
		var WebSocketServerSocket webSocketServerSocket = new WebSocketServerSocket(serverSocket)
		LOG.info('''Language Server started.''')
		try {
			while (true) {
				LOG.info('''Waiting for client to connect to web socket on port «serverSocket.localPort» ...''')
				var WebSocket webSocket = webSocketServerSocket.accept()
				try {
					LOG.info('''Connected.''')
					var LanguageServerImpl languageServer = injector.getInstance(LanguageServerImpl)
					var Function<MessageConsumer, MessageConsumer> wrapper = [consumer |
						{
							var MessageConsumer result = consumer
							return result
						}
					]
					var Launcher<LanguageClient> launcher = createSocketLauncher(languageServer, LanguageClient,
						Executors.newCachedThreadPool(), wrapper, webSocket.getInputStream(),
						webSocket.getOutputStream())
						languageServer.connect(launcher.getRemoteProxy())
						var Future<?> future = launcher.startListening()
						while (!future.isDone()) {
							if (future.isDone()) {
								webSocket.close()
								languageServer.shutdown()
							}
						}
					} catch (Exception e) {
						e.printStackTrace()
					}
				}
			} finally {
				webSocketServerSocket.close()
				LOG.info("Language Server stopped.")
			}
		}

		def static package <T> Launcher<T> createSocketLauncher(Object localService, Class<T> remoteInterface,
			ExecutorService executorService, Function<MessageConsumer, MessageConsumer> wrapper,
			InputStream inputStream, OutputStream outputStream) throws IOException {
			return Launcher.createIoLauncher(localService, remoteInterface, inputStream, outputStream, executorService,
				wrapper)
		}
	}
	