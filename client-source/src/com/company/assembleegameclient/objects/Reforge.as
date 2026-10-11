package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.game.GameSprite;

import client.ui.panels.Panel;
import client.ui.panels.ReforgePanel;

public class Reforge extends GameObject implements _G_4 {
    public function Reforge(_arg1:XML) {
        super(_arg1);
        this._064 = true;
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return new ReforgePanel(_arg1, this);
    }
}
}