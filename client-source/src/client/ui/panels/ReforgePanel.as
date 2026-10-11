package client.ui.panels {
import client.ui.frames.ReforgeFrame;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.ui.FrameHolderNoDim;

public class ReforgePanel extends StationPanel {

    private var frameHolder:FrameHolderNoDim;
    private var reforgeFrame:ReforgeFrame;

    public function ReforgePanel(gs:GameSprite, obj:GameObject) {
        super(gs, obj, "Reforge Station", "Reforge");
    }

    override protected function isStationClosed():Boolean {
        return ReforgeFrame.isClosed;
    }

    override protected function openStation():void {
        this.reforgeFrame = new ReforgeFrame(gs_, obj_);
        this.frameHolder = new FrameHolderNoDim(this.reforgeFrame);
        stage.addChild(this.frameHolder);
    }

    override protected function closeStation():void {
        if (this.frameHolder != null && this.reforgeFrame.open) {
            stage.removeChild(this.frameHolder);
        }
    }
}
}
