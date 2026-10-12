package client.ui.screens {
import com.company.assembleegameclient.appengine.Server_list;
import com.company.assembleegameclient.screens.charrects.CharacterRectList;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

/**
 * Left/right content panel of the current-character screen. Depending on
 * `state` it shows the character list, the graveyard, or the news feed.
 */
public class CharsAndNews extends Sprite {

    public static const WIDTH:int = 760;
    public static const HEIGHT:int = 415;
    public static const STATE_CHARACTERS:int = 1;
    public static const STATE_GRAVEYARD:int = 2;
    public static const STATE_NEWS:int = 3;

    /** Content taller than this gets clipped to WIDTH x HEIGHT. */
    private static const MASK_THRESHOLD:int = 400;

    public var list_:Sprite = new Sprite();
    public var news_:News;

    public function CharsAndNews(model:Server_list, screen:BaseScreen, state:int) {
        super();
        switch (state) {
            case STATE_CHARACTERS:
                this.list_ = new CharacterRectList(model, screen);
                break;
            case STATE_GRAVEYARD:
                this.list_ = new News(model, News.MODE_DEATHS);
                break;
            case STATE_NEWS:
                this.news_ = new News(model, News.MODE_NEWS);
                addChild(this.news_);
                break;
            default:
                this.list_ = new Sprite();
        }
        addChild(this.list_);
        if (height > MASK_THRESHOLD) {
            var clip:Shape = new Shape();
            var g:Graphics = clip.graphics;
            g.beginFill(0);
            g.drawRect(0, 0, WIDTH, HEIGHT);
            g.endFill();
            addChild(clip);
            mask = clip;
        }
    }

    public function setScrollY(value:Number):void {
        this.list_.y = value;
    }

}
}
