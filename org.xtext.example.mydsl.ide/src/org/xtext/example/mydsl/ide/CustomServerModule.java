package org.xtext.example.mydsl.ide;

import org.eclipse.xtext.ide.server.IMultiRootWorkspaceConfigFactory;
import org.eclipse.xtext.ide.server.MultiRootWorkspaceConfigFactory;

import com.google.inject.AbstractModule;

public final class CustomServerModule extends AbstractModule {
	@Override
	protected void configure() {
		bind(IMultiRootWorkspaceConfigFactory.class).to(MultiRootWorkspaceConfigFactory.class);
	}
}