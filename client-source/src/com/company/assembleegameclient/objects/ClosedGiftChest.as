package com.company.assembleegameclient.objects {

  import com.company.assembleegameclient.net.messages.incoming.Text;

  import client.ui.panels.Panel;
  import client.ui.panels.TextPanel;
  import client.ui.panels.ContainerPanel;

  import com.company.assembleegameclient.game.GameSprite;

  public class ClosedGiftChest extends GameObject implements _G_4 {

    public function ClosedGiftChest(_arg_1:XML) {
      super(_arg_1);
    }

    public function getPanel(_arg_1:GameSprite):Panel {
      return (new TextPanel(_arg_1));
    }

  }
}//package com.company.assembleegameclient.objects