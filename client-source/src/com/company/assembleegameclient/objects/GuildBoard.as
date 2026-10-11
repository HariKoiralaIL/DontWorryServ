// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.objects.GuildBoard

package com.company.assembleegameclient.objects {
import client.ui.panels.GuildBoardPanel;

import com.company.assembleegameclient.game.GameSprite;

import client.ui.panels.Panel;

public class GuildBoard extends GameObject implements _G_4 {

    public function GuildBoard(_arg1:XML) {
        super(_arg1);
        _064 = true;
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return (new GuildBoardPanel(_arg1));
    }

}
}//package com.company.assembleegameclient.objects

