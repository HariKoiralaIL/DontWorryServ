package client.ui.panels {
import client.ui.frames.Crafting;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.ui.FrameHolderNoDim;

public class ForgePanel extends StationPanel {

    private var frameHolder:FrameHolderNoDim;
    private var craftingFrame:Crafting;

    public function ForgePanel(gs:GameSprite, obj:GameObject) {
        super(gs, obj, "Crafting Station", "Forge");
    }

    override protected function isStationClosed():Boolean {
        return Crafting.isClosed;
    }

    override protected function openStation():void {
        this.craftingFrame = new Crafting(gs_, obj_);
        this.frameHolder = new FrameHolderNoDim(this.craftingFrame);
        stage.addChild(this.frameHolder);
    }

    override protected function closeStation():void {
        if (this.frameHolder != null && this.craftingFrame.open) {
            stage.removeChild(this.frameHolder);
        }
    }
}
}
