package client.ui.screens {
import com.company.backgrounds.TitleBackground;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

/** Title background with a centred, replaceable loading message. */
public class LoadingScreen extends Sprite {

    private var text:SimpleText;

    public function LoadingScreen() {
        super();
        addChild(new TitleBackground());
        this.text = new SimpleText(35, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.text.y = 300;
        this.text.setBold(true);
        this.text.htmlText = '<p align="center">Loading...</p>';
        this.text.autoSize = TextFieldAutoSize.CENTER;
        this.text.updateMetrics();
        this.text.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        addChild(this.text);
    }

    public function setMessage(html:String):void {
        this.text.htmlText = html;
        this.text.x = ((800 - this.text.width) * 0.5);
    }

}
}
