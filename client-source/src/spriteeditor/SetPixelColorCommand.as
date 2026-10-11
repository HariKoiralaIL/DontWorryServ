package spriteeditor {
import editorcommands.Command;

import spriteeditor.PixelCell;

import client.util.color.HSV;

/** Undoable command that changes the color of one pixel. */
public class SetPixelColorCommand extends Command {

    public var pixel_:PixelCell;
    public var oldColor_:HSV;
    public var newColor_:HSV;

    public function SetPixelColorCommand(pixel:PixelCell, oldColor:HSV, newColor:HSV) {
        this.pixel_ = pixel;
        this.oldColor_ = (((oldColor) != null) ? oldColor.clone() : null);
        this.newColor_ = (((newColor) != null) ? newColor.clone() : null);
    }

    override public function execute():void {
        this.pixel_.setColor(this.newColor_);
    }

    override public function unexecute():void {
        this.pixel_.setColor(this.oldColor_);
    }

}
}//package spriteeditor
