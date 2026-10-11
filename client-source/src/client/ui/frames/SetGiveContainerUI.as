/**
 * Created by Michael on 12.02.2017.
 */
package client.ui.frames {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.ui.Inventory;

import flash.events.Event;
import flash.events.MouseEvent;

public class SetGiveContainerUI extends Frame {

    private static const FRAME_WIDTH:int = 250;

    public static var isClosed:Boolean = true;

    public var open:Boolean;
    public var inventory_:Inventory;
    private var gs_:GameSprite;
    private var obj_:GameObject;

    public function SetGiveContainerUI(gs:GameSprite, obj:GameObject) {
        SetGiveContainerUI.isClosed = false;
        super("Give Sets", "Craft", "Close", "/craft", FRAME_WIDTH);
        this.inventory_ = new Inventory(gs, obj, "Crafting Inventory", obj._9A_, 8, false);
        var inventoryX:Number = FRAME_WIDTH / 2 - this.inventory_.width / 2 - 5;
        this.gs_ = gs;
        this.obj_ = obj;
        this._W_z(this.inventory_, inventoryX);
        this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
        this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
        Button1.addEventListener(MouseEvent.CLICK, this.onCraft);
        Button2.addEventListener(MouseEvent.CLICK, this.onClose);
        this.open = true;
    }

    private function onEnterFrame(e:Event):void {
        this.inventory_.draw(this.inventory_._iA_.equipment_);
    }

    private function onAdded(e:Event):void {
        this.x = this.x - 97;
        this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onRemoved(e:Event):void {
        this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        SetGiveContainerUI.isClosed = true;
        this.open = false;
    }

    private function onClose(e:MouseEvent):void {
        SetGiveContainerUI.isClosed = true;
        this.open = false;
        stage.focus = null;
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onCraft(e:MouseEvent):void {
        this.gs_.gsc_.craftItems(this.obj_.objectId_);
    }

}
}
