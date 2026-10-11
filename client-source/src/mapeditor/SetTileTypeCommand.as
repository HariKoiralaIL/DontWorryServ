package mapeditor {
import editorcommands.Command;

/** Changes the type stored on one layer of one tile (draw / erase). */
public class SetTileTypeCommand extends Command {

    public function SetTileTypeCommand(map:MapCanvas, tileX:int, tileY:int, layer:int, oldType:int, newType:int) {
        this.map_ = map;
        this.tileX_ = tileX;
        this.tileY_ = tileY;
        this.layer_ = layer;
        this.oldType_ = oldType;
        this.newType_ = newType;
    }
    private var map_:MapCanvas;
    private var tileX_:int;
    private var tileY_:int;
    private var layer_:int;
    private var oldType_:int;
    private var newType_:int;

    override public function execute():void {
        this.map_.setType(this.tileX_, this.tileY_, this.layer_, this.newType_);
    }

    override public function unexecute():void {
        this.map_.setType(this.tileX_, this.tileY_, this.layer_, this.oldType_);
    }

}
}
