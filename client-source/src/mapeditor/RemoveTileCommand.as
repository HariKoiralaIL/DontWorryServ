package mapeditor {
import editorcommands.Command;

/** Removes a whole tile from the map; undo restores the removed tile. */
public class RemoveTileCommand extends Command {

    public function RemoveTileCommand(map:MapCanvas, tileX:int, tileY:int, removedTile:MapTile) {
        this.map_ = map;
        this.tileX_ = tileX;
        this.tileY_ = tileY;
        this.removedTile_ = removedTile.clone();
    }
    private var map_:MapCanvas;
    private var tileX_:int;
    private var tileY_:int;
    private var removedTile_:MapTile;

    override public function execute():void {
        this.map_.removeTile(this.tileX_, this.tileY_);
    }

    override public function unexecute():void {
        this.map_.restoreTile(this.tileX_, this.tileY_, this.removedTile_);
    }

}
}
