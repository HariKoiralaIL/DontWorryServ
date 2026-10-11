package mapeditor {
import editorcommands.Command;

/** Changes the name attached to the object on a tile (Edit tool). */
public class SetObjectNameCommand extends Command {

    public function SetObjectNameCommand(map:MapCanvas, tileX:int, tileY:int, oldName:String, newName:String) {
        this.map_ = map;
        this.tileX_ = tileX;
        this.tileY_ = tileY;
        this.oldName_ = oldName;
        this.newName_ = newName;
    }
    private var map_:MapCanvas;
    private var tileX_:int;
    private var tileY_:int;
    private var oldName_:String;
    private var newName_:String;

    override public function execute():void {
        this.map_.setObjectName(this.tileX_, this.tileY_, this.newName_);
    }

    override public function unexecute():void {
        this.map_.setObjectName(this.tileX_, this.tileY_, this.oldName_);
    }

}
}
