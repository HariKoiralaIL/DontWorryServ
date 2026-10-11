package commandcenter {
import commands.ICommandUnmapper;

public class NullCommandUnmapper implements ICommandUnmapper {

    public function fromCommand(commandClass:Class):void {
    }

    public function fromAll():void {
    }

}
}
