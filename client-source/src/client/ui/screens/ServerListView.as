package client.ui.screens {
import com.company.assembleegameclient.net.Server;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * Two-column grid of servers, preceded by a centred "Best Server" entry.
 * Clicking an entry selects it and saves it as the preferred server.
 */
public class ServerListView extends Sprite {

    private var items:Vector.<ServerListItem> = new Vector.<ServerListItem>();

    public function ServerListView(servers:Vector.<Server>) {
        super();
        var item:ServerListItem = new ServerListItem(null);
        item.setSelected(true);
        item.x = ((ServerListItem.WIDTH / 2) + 2);
        item.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        addChild(item);
        this.items.push(item);
        var index:int = 2;
        for each (var server:Server in servers) {
            item = new ServerListItem(server);
            if (server.name_ == Parameters.data_.preferredServer) {
                this.setSelected(item);
            }
            item.x = ((index % 2) * (ServerListItem.WIDTH + 4));
            item.y = (int((index / 2)) * (ServerListItem.HEIGHT + 4));
            item.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            addChild(item);
            this.items.push(item);
            index++;
        }
    }

    private function setSelected(selected:ServerListItem):void {
        for each (var item:ServerListItem in this.items) {
            item.setSelected(false);
        }
        selected.setSelected(true);
    }

    private function onMouseDown(event:MouseEvent):void {
        var item:ServerListItem = (event.target as ServerListItem);
        this.setSelected(item);
        Parameters.data_.preferredServer = item.value_;
        Parameters.save();
    }

}
}
