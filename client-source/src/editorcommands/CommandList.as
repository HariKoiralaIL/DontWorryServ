package editorcommands {

/**
 * A group of commands that is executed and undone as one step.
 */
public class CommandList {

    private var commands:Vector.<Command>;

    public function CommandList() {
        this.commands = new Vector.<Command>();
    }

    public function isEmpty():Boolean {
        return (this.commands.length == 0);
    }

    public function addCommand(command:Command):void {
        this.commands.push(command);
    }

    public function execute():void {
        var command:Command;
        for each (command in this.commands) {
            command.execute();
        }
    }

    public function unexecute():void {
        var command:Command;
        for each (command in this.commands) {
            command.unexecute();
        }
    }
}
}
