package org.xtext.example.mydsl.ide

import org.eclipse.xtext.ide.server.commands.IExecutableCommandService
import org.eclipse.lsp4j.ExecuteCommandParams
import org.eclipse.xtext.ide.server.ILanguageServerAccess
import org.eclipse.xtext.util.CancelIndicator

class CommandService implements IExecutableCommandService {

	override initialize() {
		#["mydsl.a", "mydsl.b", "mydsl.c"]
	}

	override execute(ExecuteCommandParams params, ILanguageServerAccess access, CancelIndicator cancelIndicator) {
		if (params.command == "mydsl.a") {
			val uri = params.arguments.head as String
			if (uri !== null) {
				return access.doRead(uri) [
					return "Command A"
				].get
			} else {
				return "Param Uri Missing"
			}
		} else if (params.command == "mydsl.b") {
			return "Command B"
		}
		return "Bad Command"

	}

}
