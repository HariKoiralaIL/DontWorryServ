package client.ui.panels {
import game.marketplace.MarketplaceContainerUI;

import com.company.assembleegameclient.game.GameSprite;

import flash.events.MouseEvent;

public class MarketPanel extends ButtonPanel {

    public function MarketPanel(gs:GameSprite) {
        super(gs, "Marketplace", "View");
    }

    override protected function onButtonClick(event:MouseEvent):void {
        gs_.mui_.clearInput();
        gs_.addChild(new MarketplaceContainerUI(gs_));
    }
}
}
