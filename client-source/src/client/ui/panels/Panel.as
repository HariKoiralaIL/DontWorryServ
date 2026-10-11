package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;

import flash.display.Sprite;

/** Base class for everything shown in the interaction area under the minimap. */
public class Panel extends Sprite {

    public static const WIDTH:int = 188;
    public static const HEIGHT:int = 84;

    public var gs_:GameSprite;

    public function Panel(gs:GameSprite) {
        this.gs_ = gs;
    }

    /** Called every frame while the panel is visible. */
    public function draw():void {
    }
}
}
