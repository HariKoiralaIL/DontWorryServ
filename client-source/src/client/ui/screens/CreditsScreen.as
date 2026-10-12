package client.ui.screens {
import com.company.rotmg.graphics.StackedLogoR;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import signals.Signal;

/** "Developed by" credits screen. */
public class CreditsScreen extends Sprite {

    private static const DEVELOPER_URL:String = "http://www.wildshadow.com/";

    public var close:Signal;

    private var developedByText:SimpleText;
    private var logo:StackedLogoR;
    private var closeButton:MenuButton;

    public function CreditsScreen() {
        this.close = new Signal();
        addChild(new _charscreen());
        this.developedByText = new SimpleText(16, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.developedByText.setBold(true);
        this.developedByText.text = "Developed by:";
        this.developedByText.updateMetrics();
        this.developedByText.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.developedByText);
        this.logo = new StackedLogoR();
        this.logo.scaleX = (this.logo.scaleY = 1.2);
        this.logo.addEventListener(MouseEvent.CLICK, this.onLogoClick);
        this.logo.buttonMode = true;
        this.logo.useHandCursor = true;
        addChild(this.logo);
        this.closeButton = new MenuButton("close", 36, false);
        this.closeButton.addEventListener(MouseEvent.CLICK, this.onCloseClick);
        addChild(this.closeButton);
    }

    public function initialize():void {
        this.developedByText.x = ((800 / 2) - (this.developedByText.width / 2));
        this.developedByText.y = 10;
        this.logo.x = ((800 / 2) - (this.logo.width / 2));
        this.logo.y = 50;
        this.closeButton.x = ((800 / 2) - (this.closeButton.width / 2));
        this.closeButton.y = 545;
    }

    protected function onLogoClick(event:Event):void {
        navigateToURL(new URLRequest(DEVELOPER_URL), "_blank");
    }

    private function onCloseClick(event:Event):void {
        this.close.dispatch();
    }

}
}
