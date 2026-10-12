package client.ui.screens {
import com.company.assembleegameclient.appengine.CharListEvent;
    import com.company.assembleegameclient.appengine.NewsEntry;

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

    public function News(model:CharListEvent, mode:int) {
        super();
        for each (var entry:NewsEntry in model.newsItems_) {
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

    private function createItem(entry:NewsEntry, model:CharListEvent, mode:int):NewsItem {
        return new NewsItem(entry.getIcon(), entry.title_, entry.tagline_, entry.link_, entry.date_, model.accountId_, mode);
    }

}
}
