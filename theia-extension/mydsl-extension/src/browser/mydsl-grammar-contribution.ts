import { LanguageGrammarDefinitionContribution, TextmateRegistry } from '@theia/monaco/lib/browser/textmate';
import { injectable } from 'inversify';
import { MYDSL_LANGUAGE_FILE_EXTENSION, MYDSL_LANGUAGE_SERVER_ID, MYDSL_LANGUAGE_SERVER_NAME } from '../common';

@injectable()
export class MyDslGrammarContribution implements LanguageGrammarDefinitionContribution {

    registerTextmateLanguage(registry: TextmateRegistry) {
        monaco.languages.register({
            id: MYDSL_LANGUAGE_SERVER_ID,
            aliases: [
                MYDSL_LANGUAGE_SERVER_NAME, MYDSL_LANGUAGE_SERVER_ID
            ],
            extensions: [
                MYDSL_LANGUAGE_FILE_EXTENSION,
            ],
            mimetypes: [
                'text/mydsl'
            ]
        });
        monaco.languages.setLanguageConfiguration(MYDSL_LANGUAGE_SERVER_ID, this.configuration);

        const theGrammar = require('../../data/mydsl.tmLanguage.json');
        registry.registerTextmateGrammarScope('source.mydsl', {
            async getGrammarDefinition() {
                return {
                    format: 'json',
                    content: theGrammar,
                };
            }
        });
        registry.mapLanguageIdToTextmateGrammar(MYDSL_LANGUAGE_SERVER_ID, 'source.mydsl');
    }

    protected configuration: monaco.languages.LanguageConfiguration = {
        'comments': {
            'lineComment': '//',
            'blockComment': ['/*', '*/']
        },
        'brackets': [
            ['{', '}'],
            ['[', ']'],
            ['(', ')']
        ],
        'autoClosingPairs': [
            { 'open': '{', 'close': '}' },
            { 'open': '[', 'close': ']' },
            { 'open': '(', 'close': ')' },
            { 'open': "'", 'close': "'", 'notIn': ['string', 'comment'] },
            { 'open': '"', 'close': '"', 'notIn': ['string'] },
            { 'open': '/**', 'close': ' */', 'notIn': ['string'] }
        ],
        'surroundingPairs': [
            { 'open': '{', 'close': '}' },
            { 'open': '[', 'close': ']' },
            { 'open': '(', 'close': ')' },
            { 'open': "'", 'close': "'" },
            { 'open': '"', 'close': '"' },
            { 'open': '`', 'close': '`' }
        ],
        'folding': {
            'markers': {
                'start': new RegExp('^\\s*//\\s*#?region\\b'),
                'end': new RegExp('^\\s*//\\s*#?endregion\\b')
            }
        }
    };
}
