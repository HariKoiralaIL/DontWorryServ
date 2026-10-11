package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui._7f;
import com.company.ui.SimpleText;

import flash.events.MouseEvent;

/** A panel with a title and a single button. Override onButtonClick(). */
public class ButtonPanel extends Panel {

    protected var button:_7f;
    private var titleText:SimpleText;

    public function ButtonPanel(gs:GameSprite, title:String, buttonLabel:String) {
        super(gs);
        this.titleText = PanelUtil.createLabel(title);
        this.titleText.y = 6;
        addChild(this.titleText);
        this.button = new _7f(16, buttonLabel);
        this.button.addEventListener(MouseEvent.CLICK, this.onButtonClick);
        this.button.x = (WIDTH / 2) - (this.button.width / 2);
        this.button.y = (HEIGHT - this.button.height) - 4;
        addChild(this.button);
    }

    protected function onButtonClick(event:MouseEvent):void {
    }
}
}
