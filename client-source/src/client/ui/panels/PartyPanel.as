package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.NearbyPlayerTracker;
import com.company.assembleegameclient.ui.tooltip.PlayerToolTip;
import com.company.assembleegameclient.ui.ui_playerslist;
import com.company.util.MoreColorUtil;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.utils.getTimer;

import menus.PlayerMenu;

/** Shows the party members (two columns); hover for a tooltip, click for the player menu. */
public class PartyPanel extends Panel {

    /** [x, y] of each member slot. */
    private static const SLOT_POSITIONS:Array =
            [[0, 0], [100, 0], [0, 32], [100, 32], [0, 64], [100, 64], [0, 92], [100, 92]];
    private static const LOW_HEALTH_RATIO:Number = 0.2;

    public var memberSlots:Vector.<ui_playerslist>;
    private var toolTip:PlayerToolTip = null;
    private var playerMenu:PlayerMenu = null;
    private var isHovering:Boolean = false;

    public function PartyPanel(gs:GameSprite) {
        super(gs);
        this.memberSlots = new Vector.<ui_playerslist>(NearbyPlayerTracker.MAX_LISTED, true);
        for (var i:int = 0; i < SLOT_POSITIONS.length; i++) {
            this.memberSlots[i] = this.createMemberSlot(SLOT_POSITIONS[i][0], SLOT_POSITIONS[i][1]);
        }
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    override public function draw():void {
        var slot:ui_playerslist;
        var party:NearbyPlayerTracker = gs_.map_.party_;
        if (party == null) {
            for each (slot in this.memberSlots) {
                slot.draw(null);
            }
            return;
        }
        // While hovering or with the menu open, keep showing the slot's current player
        // so the tooltip/menu target doesn't change under the cursor.
        var keepSlotPlayers:Boolean = this.isHovering || (this.playerMenu != null && this.playerMenu.parent != null);
        var blinkTime:int = 0;
        for (var i:int = 0; i < NearbyPlayerTracker.MAX_LISTED; i++) {
            var member:Player;
            if (keepSlotPlayers) {
                member = this.memberSlots[i].go_ as Player;
            } else {
                member = party.members_[i];
            }
            if (member != null && member.map_ == null) {
                member = null;
            }
            var tint:ColorTransform = null;
            if (member != null) {
                if (member.HP_ < (member.maxHP_ * LOW_HEALTH_RATIO)) {
                    if (blinkTime == 0) {
                        blinkTime = getTimer();
                    }
                    var pulse:Number = int(Math.abs(Math.sin(blinkTime / 200)) * 10) / 10;
                    var shift:int = 128;
                    tint = new ColorTransform(1, 1, 1, 1, pulse * shift, -pulse * shift, -pulse * shift);
                }
                if (!member.starred_) {
                    if (tint != null) {
                        tint.concat(MoreColorUtil.GRAY_60);
                    } else {
                        tint = MoreColorUtil.GRAY_60;
                    }
                }
            }
            this.memberSlots[i].draw(member, tint);
        }
        if (this.toolTip != null) {
            this.toolTip.draw();
        }
    }

    private function createMemberSlot(x:int, y:int):ui_playerslist {
        var slot:ui_playerslist = new ui_playerslist(0xFFFFFF, false, null);
        addChild(slot);
        slot.x = x;
        slot.y = y;
        return slot;
    }

    private function removeToolTip():void {
        if (this.toolTip != null) {
            if (this.toolTip.parent != null) {
                this.toolTip.parent.removeChild(this.toolTip);
            }
            this.toolTip = null;
        }
    }

    private function removePlayerMenu():void {
        if (this.playerMenu != null) {
            if (this.playerMenu.parent != null) {
                this.playerMenu.parent.removeChild(this.playerMenu);
            }
            this.playerMenu = null;
        }
    }

    private function onAddedToStage(event:Event):void {
        for each (var slot:ui_playerslist in this.memberSlots) {
            slot.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            slot.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            slot.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        }
    }

    private function onRemovedFromStage(event:Event):void {
        this.removeToolTip();
        this.removePlayerMenu();
        for each (var slot:ui_playerslist in this.memberSlots) {
            slot.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            slot.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            slot.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        }
    }

    private function onMouseOver(event:MouseEvent):void {
        this.removeToolTip();
        if (this.playerMenu != null && this.playerMenu.parent != null) {
            return;
        }
        var slot:ui_playerslist = event.target as ui_playerslist;
        var player:Player = slot.go_ as Player;
        if (player == null || player.texture_ == null) {
            return;
        }
        this.toolTip = new PlayerToolTip(player);
        stage.addChild(this.toolTip);
        this.isHovering = true;
    }

    private function onMouseOut(event:MouseEvent):void {
        this.removeToolTip();
        this.isHovering = false;
    }

    private function onMouseDown(event:MouseEvent):void {
        this.removeToolTip();
        this.removePlayerMenu();
        var slot:ui_playerslist = event.target as ui_playerslist;
        this.playerMenu = new PlayerMenu(gs_, slot.go_ as Player);
        stage.addChild(this.playerMenu);
    }
}
}
