package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;

public class TradeRequestPanel extends InvitePanel {

    public var name_:String;

    public function TradeRequestPanel(gs:GameSprite, name:String) {
        super(gs);
        this.name_ = name;
        this.addLine(PanelUtil.createLabel(name + " wants to trade with you"), 0);
    }

    override protected function onAccept():void {
        gs_.gsc_.requestTrade(this.name_);
    }
}
}
