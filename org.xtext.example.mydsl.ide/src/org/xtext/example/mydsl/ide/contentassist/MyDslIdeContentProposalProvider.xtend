package org.xtext.example.mydsl.ide.contentassist

import com.google.inject.Inject
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistEntry
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
		if (greetingRule == ruleCall.rule) {
			val scope = scopeProvider.getScope(context.currentModel, MyDslPackage.Literals.GREETING__FROM)

			acceptor.accept(
				proposalCreator.
					createProposal('''Hello ${1|A,B,C|} from ${2|«scope.allElements.map[name.toString].join(",")»|}!''',
						context) => [
							kind = ContentAssistEntry.KIND_SNIPPET
							label = "New Greeting (Template with Choice)"
						], 0)
			acceptor.accept(
				proposalCreator.
					createProposal('''Hello ${1:name} from ${2:fromName}!''',
						context) => [
							kind = ContentAssistEntry.KIND_SNIPPET
							label = "New Greeting (Template with Placeholder)"
						], 0)
		}
		super._createProposals(ruleCall, context, acceptor)

	}

}
