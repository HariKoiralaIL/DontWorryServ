package mapeditor {
import com.company.util.IntPoint;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

/** Dimmed full-screen overlay that hosts the TilePropertiesFrame for the selected tiles. */
public class TilePropertiesOverlay extends Sprite {

    public function TilePropertiesOverlay(tiles:Vector.<IntPoint>, objectName:String) {
        this.tiles_ = tiles;
        this.background_ = new Shape();
        var g:Graphics = this.background_.graphics;
        g.clear();
        g.beginFill(0, 0.8);
        g.drawRect(0, 0, 800, 600);
        g.endFill();
        addChild(this.background_);
        this.frame_ = new TilePropertiesFrame(objectName);
        this.frame_.addEventListener(Event.COMPLETE, this.onComplete);
        this.frame_.addEventListener(Event.CANCEL, this.onCancel);
        addChild(this.frame_);
    }
    public var tiles_:Vector.<IntPoint>;
    private var background_:Shape;
    private var frame_:TilePropertiesFrame;

    /** Entered object name, or null if the field is empty. */
    public function getObjectName():String {
        if (this.frame_.nameInput_.text() == "") {
            return (null);
        }
        return (this.frame_.nameInput_.text());
    }

    public function onComplete(event:Event):void {
        dispatchEvent(new Event(Event.COMPLETE));
        parent.removeChild(this);
    }

    public function onCancel(event:Event):void {
        parent.removeChild(this);
    }

}
}
