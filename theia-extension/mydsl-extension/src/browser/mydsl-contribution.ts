import { injectable, inject } from "inversify";
import { CommandContribution, CommandRegistry, MenuContribution, MenuModelRegistry, MessageService } from "@theia/core/lib/common";
import { CommonMenus } from "@theia/core/lib/browser";

export const MyDslCommand = {
    id: 'MyDsl.command',
    label: "Shows a message"
};

@injectable()
export class MyDslDslCommandContribution implements CommandContribution {

    constructor(
        @inject(MessageService) private readonly messageService: MessageService,
    ) { }

    registerCommands(registry: CommandRegistry): void {
        registry.registerCommand(MyDslCommand, {
            execute: () => this.messageService.info('Hello World!')
        });
    }
}

@injectable()
export class MyDslDslMenuContribution implements MenuContribution {

    registerMenus(menus: MenuModelRegistry): void {
        menus.registerMenuAction(CommonMenus.EDIT_FIND, {
            commandId: MyDslCommand.id,
            label: 'Say Hello'
        });
    }
}