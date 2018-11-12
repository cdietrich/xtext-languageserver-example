/**
 * Generated using theia-extension-generator
 */

import { MyDslDslCommandContribution, MyDslDslMenuContribution } from './mydsl-contribution';
import {
    CommandContribution,
    MenuContribution
} from "@theia/core/lib/common";

import { ContainerModule } from "inversify";
import { LanguageClientContribution } from '@theia/languages/lib/browser';
import { MyDslLanguageClientContribution } from './mydsl-language-client-contribution';
import { LanguageGrammarDefinitionContribution } from '@theia/monaco/lib/browser/textmate';
import { MyDslGrammarContribution } from './mydsl-grammar-contribution';

export default new ContainerModule(bind => {
    // add your contribution bindings here
    bind(CommandContribution).to(MyDslDslCommandContribution);
    bind(MenuContribution).to(MyDslDslMenuContribution);
    
    bind(MyDslLanguageClientContribution).toSelf().inSingletonScope();
    bind(LanguageClientContribution).toService(MyDslLanguageClientContribution);
    bind(LanguageGrammarDefinitionContribution).to(MyDslGrammarContribution).inSingletonScope();
});