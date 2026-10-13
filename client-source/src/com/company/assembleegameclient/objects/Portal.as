package com.company.assembleegameclient.objects {

    import flash.display.IGraphicsData;

    import com.company.assembleegameclient.map.GameCamera;

    import client.ui.panels.PortalPanel;

    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public class Portal extends GameObject implements IInteractable {

        public function Portal(xml:XML) {
            super(xml);
            isInteractive_ = true;
            this.isNexusPortal_ = xml.hasOwnProperty("NexusPortal");
            this.isLocked_ = xml.hasOwnProperty("LockedPortal");
        }
        public var isNexusPortal_:Boolean;
        public var isLocked_:Boolean;
        public var active_:Boolean = true;

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            super.draw(graphicsData, camera, time);
            if (this.isNexusPortal_) {
                drawName(graphicsData, camera);
            }
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new PortalPanel(gs, this));
        }

    }
}//package com.company.assembleegameclient.objects
