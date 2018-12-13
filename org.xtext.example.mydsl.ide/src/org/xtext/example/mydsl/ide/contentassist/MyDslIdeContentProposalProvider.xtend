package org.xtext.example.mydsl.ide.contentassist

import com.google.inject.Inject
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.IIdeContentProposalAcceptor
import org.eclipse.xtext.ide.editor.contentassist.IdeContentProposalProvider
import org.eclipse.xtext.scoping.IScopeProvider
import org.xtext.example.mydsl.myDsl.MyDslPackage
import org.xtext.example.mydsl.services.MyDslGrammarAccess

class MyDslIdeContentProposalProvider extends IdeContentProposalProvider {

	@Inject extension MyDslGrammarAccess

	@Inject IScopeProvider scopeProvider

	override protected _createProposals(RuleCall ruleCall, ContentAssistContext context,
		IIdeContentProposalAcceptor acceptor) {
		if (greetingRule == ruleCall.rule && context.currentModel !== null) {
			val scope = scopeProvider.getScope(context.currentModel, MyDslPackage.Literals.GREETING__FROM)
			acceptor.accept(
				proposalCreator.
					createSnippet('''Hello ${1|A,B,C|} from ${2|«scope.allElements.map[name.toString].join(",")»|}!''',
						"New Greeting (Template with Choice)", context), 0)
			acceptor.accept(
				proposalCreator.createSnippet('''Hello ${1:name} from ${2:fromName}!''',
					"New Greeting (Template with Placeholder)", context), 0)
		}
		super._createProposals(ruleCall, context, acceptor)
	}

}
