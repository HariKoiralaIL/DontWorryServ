package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Portal;
import com.company.assembleegameclient.tutorial.Tutorial;
import com.company.assembleegameclient.tutorial.doneAction;
import com.company.assembleegameclient.ui._7f;
import com.company.ui.SimpleText;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

/** Shows a portal's name with an Enter button, or "Locked" / "Full" when it can't be entered. */
public class PortalPanel extends Panel {

    private static const LOCKED_PREFIX:String = "Locked ";

    public var portal_:Portal;
    private var nameText:SimpleText;
    private var enterButton:_7f;
    private var statusText:SimpleText;

    public function PortalPanel(gs:GameSprite, portal:Portal) {
        super(gs);
        this.portal_ = portal;
        this.nameText = PanelUtil.createLabel("Portal");
        addChild(this.nameText);
        this.enterButton = new _7f(16, "Enter");
        addChild(this.enterButton);
        // Portal._xq: portal is locked. Otherwise a blocked portal is full.
        this.statusText = PanelUtil.createLabel(this.portal_._xq ? "Locked" : "Full", 18, 0xFF0000, WIDTH, false);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    override public function draw():void {
        var locked:Boolean = this.portal_._xq;
        var canEnter:Boolean = this.portal_._09S_;  // Portal._09S_: portal accepts players
        var portalName:String = this.portal_._include();
        if (locked && portalName.indexOf(LOCKED_PREFIX) == 0) {
            portalName = portalName.substr(LOCKED_PREFIX.length);
        }
        this.nameText.htmlText = '<p align="center">' + portalName + "</p>";
        this.nameText._08S_();
        this.nameText.y = (this.nameText.height > 30) ? 0 : 6;
        if (!locked && canEnter && contains(this.statusText)) {
            removeChild(this.statusText);
            addChild(this.enterButton);
        } else if ((locked || !canEnter) && contains(this.enterButton)) {
            removeChild(this.enterButton);
            addChild(this.statusText);
        }
    }

    private function enterPortal():void {
        doneAction(gs_, Tutorial._Y_5);
        gs_.gsc_.usePortal(this.portal_.objectId_);
    }

    private function onAddedToStage(event:Event):void {
        this.nameText.y = 6;
        this.enterButton.x = (WIDTH / 2) - (this.enterButton.width / 2);
        this.enterButton.y = (HEIGHT - this.enterButton.height) - 4;
        this.statusText.y = (HEIGHT - this.statusText.height) - 12;
        this.enterButton.addEventListener(MouseEvent.CLICK, this.onEnterClick);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
    }

    private function onRemovedFromStage(event:Event):void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
    }

    private function onEnterClick(event:MouseEvent):void {
        this.enterPortal();
    }

    private function onKeyDown(event:KeyboardEvent):void {
        if (PanelUtil.isInteractKey(event)) {
            this.enterPortal();
        }
    }
}
}
