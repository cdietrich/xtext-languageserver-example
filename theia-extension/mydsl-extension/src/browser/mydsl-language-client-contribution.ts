import { BaseLanguageClientContribution, LanguageClientFactory, Languages, Workspace } from '@theia/languages/lib/browser';
import { inject, injectable } from 'inversify';
import { MYDSL_LANGUAGE_SERVER_ID, MYDSL_LANGUAGE_SERVER_NAME, MYDSL_LANGUAGE_FILE_EXTENSION } from '../common';

@injectable()
export class MyDslLanguageClientContribution extends BaseLanguageClientContribution {

    readonly id = MYDSL_LANGUAGE_SERVER_ID;
    readonly name = MYDSL_LANGUAGE_SERVER_NAME;

    constructor(
        @inject(Workspace) protected readonly workspace: Workspace,
        @inject(Languages) protected readonly languages: Languages,
        @inject(LanguageClientFactory) protected readonly languageClientFactory: LanguageClientFactory
    ) {
        super(workspace, languages, languageClientFactory);
    }

    protected get globPatterns(): string[] {
        return [
            '**/*' + MYDSL_LANGUAGE_FILE_EXTENSION,
        ];
    }

    protected get documentSelector(): string[] {
        return [
            MYDSL_LANGUAGE_SERVER_ID
        ];
    }
    
}