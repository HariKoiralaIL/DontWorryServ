package editorcommands {

/**
 * Undo/redo history. `position` is the number of command lists that are
 * currently applied; entries after it are available for redo.
 */
public class CommandQueue {

    private var commands:Vector.<CommandList>;
    private var position:int = 0;

    public function CommandQueue() {
        this.commands = new Vector.<CommandList>();
    }

    /** Runs the commands and records them, discarding any redo history. */
    public function addCommandList(commandList:CommandList):void {
        this.commands.length = this.position;
        commandList.execute();
        this.commands.push(commandList);
        this.position++;
    }

    public function undo():void {
        if (this.position == 0) {
            return;
        }
        this.commands[--this.position].unexecute();
    }

    public function redo():void {
        if (this.position == this.commands.length) {
            return;
        }
        this.commands[this.position++].execute();
    }

    public function clear():void {
        this.position = 0;
        this.commands.length = 0;
    }
}
}
