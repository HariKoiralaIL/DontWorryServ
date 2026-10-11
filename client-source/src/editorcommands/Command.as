package editorcommands {

/**
 * Base class for an undoable action. Subclasses override both methods.
 */
public class Command {

    public function execute():void {
    }

    public function unexecute():void {
    }
}
}
