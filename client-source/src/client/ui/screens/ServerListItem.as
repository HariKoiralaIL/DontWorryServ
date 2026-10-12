package client.ui.screens {
import com.company.assembleegameclient.net.Server;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

/** One row/tile in the server list: server name plus a Normal/Crowded/Full status. */
public class ServerListItem extends Sprite {

    public static const WIDTH:int = 384;
    public static const HEIGHT:int = 52;

    private static const COLOR_NORMAL:uint = 0x00FF00;
    private static const COLOR_CROWDED:uint = 0xFC8642;
    private static const COLOR_FULL:uint = 0xFF0000;
    private static const BORDER_COLOR:uint = 0xFFFF8F;

    /** Server name, or null for the "Best Server" entry. */
    public var value_:String;

    private var nameText_:SimpleText;
    private var statusText_:SimpleText;
    private var selected_:Boolean = false;
    private var over_:Boolean = false;

    public function ServerListItem(server:Server) {
        super();
        this.value_ = ((server == null) ? null : server.name_);
        this.nameText_ = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.text = ((server == null) ? "Best Server" : server.name_);
        this.nameText_.updateMetrics();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.nameText_.x = 18;
        this.nameText_.y = ((HEIGHT / 2) - (this.nameText_.height / 2));
        addChild(this.nameText_);
        if (server != null) {
            this.buildStatus(server);
        }
        this.draw();
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    public function setSelected(value:Boolean):void {
        this.selected_ = value;
        this.draw();
    }

    private function buildStatus(server:Server):void {
        var color:uint = COLOR_NORMAL;
        var label:String = "Normal";
        if (server.isFull()) {
            color = COLOR_FULL;
            label = "Full";
        } else if (server.isCrowded()) {
            color = COLOR_CROWDED;
            label = "Crowded";
        }
        this.statusText_ = new SimpleText(18, color, false, 0, 0, "Myriad Pro");
        this.statusText_.setBold(true);
        this.statusText_.text = label;
        this.statusText_.updateMetrics();
        this.statusText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.statusText_.x = ((WIDTH / 2) + ((WIDTH / 4) - (this.statusText_.width / 2)));
        this.statusText_.y = ((HEIGHT / 2) - (this.nameText_.height / 2));
        addChild(this.statusText_);
    }

    private function draw():void {
        graphics.clear();
        if (this.selected_) {
            graphics.lineStyle(2, BORDER_COLOR);
        }
        graphics.beginFill(((this.over_) ? 0x3D3D3D : 0x4C4C4C), 1);
        graphics.drawRect(0, 0, WIDTH, HEIGHT);
        if (this.selected_) {
            graphics.lineStyle();
        }
    }

    private function onMouseOver(event:MouseEvent):void {
        this.over_ = true;
        this.draw();
    }

    private function onRollOut(event:MouseEvent):void {
        this.over_ = false;
        this.draw();
    }

}
}
