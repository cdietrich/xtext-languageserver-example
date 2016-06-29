package org.xtext.example.mydsl.ide;
import java.net.InetSocketAddress;

import org.eclipse.xtext.ide.server.ServerModule;

import com.google.inject.Guice;
import com.google.inject.Injector;

import io.typefox.lsapi.services.LanguageServer;
import io.typefox.lsapi.services.json.LanguageServerLauncher;

/**
 * @author dietrich - Initial contribution and API
 */
public class RunServer {

	public static void main(String[] args) {
		Injector injector = Guice.createInjector(new ServerModule());
		LanguageServer languageServer = injector.getInstance(LanguageServer.class);
		LanguageServerLauncher launcher = LanguageServerLauncher.newLoggingLauncher(languageServer,
				new InetSocketAddress("localhost", 5007));
		launcher.launch();
	}

}