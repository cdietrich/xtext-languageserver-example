import { ContainerModule } from 'inversify';
import { LanguageServerContribution } from '@theia/languages/lib/node';
import { MyDslLanguageServerContribution } from './mydsl-language-server-contribution';

export default new ContainerModule(bind => {
    bind(LanguageServerContribution).to(MyDslLanguageServerContribution).inSingletonScope();
});
