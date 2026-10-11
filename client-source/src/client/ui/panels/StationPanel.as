package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;

import flash.events.Event;

/**
 * Base for crafting-style stations (Forge, Reforge) that open a frame on
 * the stage. Subclasses say how their frame is opened, closed and checked.
 */
public class StationPanel extends InteractButtonPanel {

    public var obj_:GameObject;

    public function StationPanel(gs:GameSprite, obj:GameObject, title:String, buttonLabel:String) {
        super(gs, title, buttonLabel);
        this.obj_ = obj;
    }

    /** True when the station's frame isn't currently open. */
    protected function isStationClosed():Boolean {
        return true;
    }

    /** Create the station's frame and add it to the stage. */
    protected function openStation():void {
    }

    /** Remove the station's frame from the stage if it is still open. */
    protected function closeStation():void {
    }

    override protected function onInteract():void {
        if (this.isStationClosed()) {
            this.openStation();
        }
    }

    override protected function onRemovedFromStage(event:Event):void {
        super.onRemovedFromStage(event);
        if (parent != null) {
            this.closeStation();
        }
    }
}
}
