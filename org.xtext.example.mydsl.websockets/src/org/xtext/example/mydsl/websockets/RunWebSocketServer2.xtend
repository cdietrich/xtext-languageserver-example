package org.xtext.example.mydsl.websockets

import com.google.inject.Guice
import com.google.inject.Injector
import com.pmeade.websocket.net.WebSocket
import com.pmeade.websocket.net.WebSocketServerSocket
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream
import java.net.ServerSocket
import java.util.LinkedHashMap
import java.util.Map
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.Future
import java.util.function.Function
import org.eclipse.lsp4j.jsonrpc.Launcher
import org.eclipse.lsp4j.jsonrpc.MessageConsumer
import org.eclipse.lsp4j.jsonrpc.RemoteEndpoint
import org.eclipse.lsp4j.jsonrpc.json.ConcurrentMessageProcessor
import org.eclipse.lsp4j.jsonrpc.json.JsonRpcMethod
import org.eclipse.lsp4j.jsonrpc.json.JsonRpcMethodProvider
import org.eclipse.lsp4j.jsonrpc.json.MessageJsonHandler
import org.eclipse.lsp4j.jsonrpc.json.StreamMessageProducer
import org.eclipse.lsp4j.jsonrpc.services.ServiceEndpoints
import org.eclipse.lsp4j.services.LanguageClient
import org.eclipse.xtext.ide.server.LanguageServerImpl
import org.eclipse.xtext.ide.server.ServerModule
import org.eclipse.xtext.util.internal.Log

@Log class RunWebSocketServer2 {
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
			return createIoLauncher(localService, remoteInterface, inputStream, outputStream, executorService,
				wrapper)
		}

		def static package <T> Launcher<T> createIoLauncher(Object localService, Class<T> remoteInterface,
			InputStream in, OutputStream out, ExecutorService executorService,
			Function<MessageConsumer, MessageConsumer> wrapper) {
			var Map<String, JsonRpcMethod> supportedMethods = new LinkedHashMap<String, JsonRpcMethod>()
			supportedMethods.putAll(ServiceEndpoints.getSupportedMethods(remoteInterface))
			if (localService instanceof JsonRpcMethodProvider) {
				var JsonRpcMethodProvider rpcMethodProvider = (localService as JsonRpcMethodProvider)
				supportedMethods.putAll(rpcMethodProvider.supportedMethods())
			} else {
				supportedMethods.putAll(ServiceEndpoints.getSupportedMethods(localService.getClass()))
			}
			var MessageJsonHandler jsonHandler = new MessageJsonHandler(supportedMethods)
			var MessageConsumer outGoingMessageStream = new StreamMessageConsumer2(out, jsonHandler)
			outGoingMessageStream = wrapper.apply(outGoingMessageStream)
			val RemoteEndpoint serverEndpoint = new RemoteEndpoint(outGoingMessageStream,
				ServiceEndpoints.toEndpoint(localService))
			jsonHandler.setMethodProvider(serverEndpoint)
			// wrap incoming message stream
			val MessageConsumer messageConsumer = wrapper.apply(serverEndpoint)
			val StreamMessageProducer reader = new StreamMessageProducer(in, jsonHandler)
			val T remoteProxy2 = ServiceEndpoints.toServiceObject(serverEndpoint, remoteInterface)
			return new Launcher<T>() {
				override Future<Void> startListening() {
					return ConcurrentMessageProcessor.startProcessing(reader, messageConsumer, executorService)
				}

				override T getRemoteProxy() {
					return remoteProxy2
				}
				
				override RemoteEndpoint getRemoteEndpoint() {
					return serverEndpoint;
				}
				
			}
		}

	}
	