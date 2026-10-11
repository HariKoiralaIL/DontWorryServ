package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;

public class GuildInvitePanel extends InvitePanel {

    public var name_:String;
    private var guildName_:String;

    public function GuildInvitePanel(gs:GameSprite, name:String, guildName:String) {
        super(gs);
        this.name_ = name;
        this.guildName_ = guildName;
        this.addLine(PanelUtil.createLabel(name + " invited you to:", 16, 0xFFFFFF, WIDTH, false), 0);
        this.addLine(PanelUtil.createLabel(guildName, 16, 0xFFFFFF, WIDTH, false), 20);
    }

    override protected function onAccept():void {
        gs_.gsc_.joinGuild(this.guildName_);
    }
}
}
