package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public interface IInteractable {

        function getPanel(gs:GameSprite):Panel;

    }
}//package com.company.assembleegameclient.objects
