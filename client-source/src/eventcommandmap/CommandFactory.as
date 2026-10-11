package eventcommandmap {

import injection.Injector;

import robotlegs.bender.framework.impl.applyHooks;
import robotlegs.bender.framework.impl.guardsApprove;
import commands.ICommandMapping;

/**
 * Creates a command instance for a mapping, provided all of the mapping's
 * guards approve. Hooks are applied while the command class is temporarily
 * mapped as a singleton, so guards and hooks see the same instance.
 */
public class CommandFactory {

    private var injector:Injector;

    public function CommandFactory(injector:Injector) {
        this.injector = injector;
    }

    /**
     * @return the command instance, or null if a guard rejected the mapping
     */
    public function create(mapping:ICommandMapping):Object {
        if (!guardsApprove(mapping.guards, this.injector)) {
            return null;
        }
        var commandClass:Class = mapping.commandClass;
        this.injector.map(commandClass).asSingleton();
        var command:Object = this.injector.getInstance(commandClass);
        applyHooks(mapping.hooks, this.injector);
        this.injector.unmap(commandClass);
        return command;
    }

}
}
