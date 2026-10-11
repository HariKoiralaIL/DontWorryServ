package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;

public class PartyInvitePanel extends InvitePanel {

    public var name_:String;
    private var partyID_:int;

    public function PartyInvitePanel(gs:GameSprite, name:String, partyID:int) {
        super(gs);
        this.name_ = name;
        this.partyID_ = partyID;
        this.addLine(PanelUtil.createLabel("Invited to the party of:", 16, 0xFFFFFF, WIDTH, false), 0);
        this.addLine(PanelUtil.createLabel(name, 16, 0xFFFFFF, WIDTH, false), 20);
    }

    override protected function onAccept():void {
        gs_.gsc_.joinParty(this.partyID_);
    }
}
}
