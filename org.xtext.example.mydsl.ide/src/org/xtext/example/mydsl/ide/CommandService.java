package org.xtext.example.mydsl.ide;

import java.util.List;
import java.util.concurrent.ExecutionException;

import org.eclipse.lsp4j.ExecuteCommandParams;
import org.eclipse.xtext.ide.server.ILanguageServerAccess;
import org.eclipse.xtext.ide.server.commands.IExecutableCommandService;
import org.eclipse.xtext.util.CancelIndicator;

import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;

public class CommandService implements IExecutableCommandService {
	@Override
	public List<String> initialize() {
		return Lists.newArrayList("mydsl.a", "mydsl.b", "mydsl.c");
	}

	@Override
	public Object execute(ExecuteCommandParams params, ILanguageServerAccess access, CancelIndicator cancelIndicator) {
		if ("mydsl.a".equals(params.getCommand())) {
			String uri = (String) Iterables.getFirst(params.getArguments(), null);
			if (uri != null) {
				try {
					return access.doRead(uri, (ILanguageServerAccess.Context it) -> "Command A").get();
				} catch (InterruptedException | ExecutionException e) {
					return e.getMessage();
				}
			} else {
				return "Param Uri Missing";
			}
		} else if ("mydsl.b".equals(params.getCommand())) {
			return "Command B";
		}
		return "Bad Command";
	}
}
