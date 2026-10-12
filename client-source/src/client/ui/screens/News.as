package client.ui.screens {
import com.company.assembleegameclient.appengine.Server_list;
import com.company.assembleegameclient.appengine._vt;

import flash.display.Sprite;

/**
 * Vertical list of NewsItem rows built from the server list's entries.
 * MODE_NEWS shows the non-death entries; MODE_DEATHS shows the graveyard.
 */
public class News extends Sprite {

    public static const MODE_NEWS:int = 1;
    public static const MODE_DEATHS:int = 2;

    private var items:Vector.<NewsItem> = new Vector.<NewsItem>();
    private var containsDeaths:Boolean = false;

    public function News(model:Server_list, mode:int) {
        super();
        for each (var entry:_vt in model._tZ_) {
            switch (mode) {
                case MODE_NEWS:
                    if (!entry.isDeath()) {
                        this.addItem(this.createItem(entry, model, mode));
                    }
                    break;
                case MODE_DEATHS:
                    if (entry.isDeath()) {
                        this.addItem(this.createItem(entry, model, mode));
                        this.containsDeaths = true;
                    }
                    break;
                default:
                    break;
            }
        }
    }

    public function hasDeaths():Boolean {
        return this.containsDeaths;
    }

    public function addItem(item:NewsItem):void {
        item.y = (4 + (this.items.length * (NewsItem.HEIGHT + 4)));
        this.items.push(item);
        addChild(item);
    }

    private function createItem(entry:_vt, model:Server_list, mode:int):NewsItem {
        return new NewsItem(entry.getIcon(), entry._O_k, entry._03P_, entry._qh, entry._W_e, model.accountId_, mode);
    }

}
}
