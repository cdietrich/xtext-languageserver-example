package org.xtext.example.mydsl.ide;

import org.eclipse.xtext.ide.server.IWorkspaceConfigFactory;
import org.eclipse.xtext.ide.server.MultiProjectWorkspaceConfigFactory;

import com.google.inject.AbstractModule;

public final class CustomServerModule extends AbstractModule {
	@Override
	protected void configure() {
		bind(IWorkspaceConfigFactory.class).to(MultiProjectWorkspaceConfigFactory.class);
	}
}