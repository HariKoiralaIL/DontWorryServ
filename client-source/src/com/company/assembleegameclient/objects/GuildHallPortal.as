// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.objects.GuildHallPortal

package com.company.assembleegameclient.objects {
import client.ui.panels.GuildHallPanel;

import com.company.assembleegameclient.game.GameSprite;

import client.ui.panels.Panel;

public class GuildHallPortal extends GameObject implements _G_4 {

    public function GuildHallPortal(_arg1:XML) {
        super(_arg1);
        _064 = true;
    }

    public function getPanel(_arg1:GameSprite):Panel {
        return (new GuildHallPanel(_arg1, this));
    }

}
}//package com.company.assembleegameclient.objects

