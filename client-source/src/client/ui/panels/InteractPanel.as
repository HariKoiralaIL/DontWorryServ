package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.IInteractable;
import com.company.util.PointUtil;

import flash.display.Sprite;
import flash.events.Event;

/**
 * Hosts the panel under the minimap: the panel of the closest interactive
 * object in range, the party panel when nothing is nearby, or an override
 * panel (invites, trade requests) that stays until it completes.
 */
public class InteractPanel extends Sprite {

    /** Max distance (in tiles) at which an object can be interacted with. */
    public static const MAX_DIST:Number = 1;

    public var gs_:GameSprite;
    public var player_:Player;
    public var w_:int;
    public var h_:int;
    public var currentPanel:Panel = null;
    public var currentInteractive:IInteractable = null;
    public var partyPanel:PartyPanel;
    private var overridePanel:Panel;

    public function InteractPanel(gs:GameSprite, player:Player, width:int, height:int) {
        this.gs_ = gs;
        this.player_ = player;
        this.w_ = width;
        this.h_ = height;
        this.partyPanel = new PartyPanel(gs);
    }

    /** Shows the given panel until it dispatches Event.COMPLETE. */
    public function setOverridePanel(panel:Panel):void {
        if (this.overridePanel != null) {
            this.overridePanel.removeEventListener(Event.COMPLETE, this.onComplete);
        }
        this.overridePanel = panel;
        this.overridePanel.addEventListener(Event.COMPLETE, this.onComplete);
    }

    public function redraw():void {
        this.currentPanel.draw();
    }

    public function draw():void {
        if (this.overridePanel != null) {
            this.showPanel(this.overridePanel, true);
            this.currentPanel.draw();
            return;
        }
        var closestDist:Number = Number.MAX_VALUE;
        var closest:IInteractable = null;
        for each (var go:GameObject in this.gs_.map_.goDict_) {
            if (!go.isInteractive_) {
                continue;
            }
            var interactive:IInteractable = go as IInteractable;
            if (interactive == null) {
                return;
            }
            if (Math.abs(go.x_ - this.player_.x_) > MAX_DIST || Math.abs(go.y_ - this.player_.y_) > MAX_DIST) {
                continue;
            }
            var dist:Number = PointUtil._R_O_(go.x_, go.y_, this.player_.x_, this.player_.y_);
            if (dist < MAX_DIST && dist < closestDist) {
                closestDist = dist;
                closest = interactive;
            }
        }
        if (this.currentPanel == null || closest != this.currentInteractive) {
            this.currentInteractive = closest;
            var panel:Panel = (this.currentInteractive != null)
                    ? this.currentInteractive.getPanel(this.gs_)
                    : this.partyPanel;
            this.showPanel(panel, this.currentInteractive != null);
        }
        this.currentPanel.draw();
    }

    private function showPanel(panel:Panel, offset:Boolean):void {
        if (panel == this.currentPanel) {
            return;
        }
        if (this.currentPanel != null) {
            removeChild(this.currentPanel);
        }
        this.currentPanel = panel;
        if (this.currentPanel == null) {
            return;
        }
        if (offset) {
            this.currentPanel.x = 6;
            this.currentPanel.y = 20;
        }
        addChild(this.currentPanel);
    }

    private function onComplete(event:Event):void {
        if (this.overridePanel != null) {
            this.overridePanel.removeEventListener(Event.COMPLETE, this.onComplete);
            this.overridePanel = null;
        }
        this.showPanel(null, false);
        this.draw();
    }
}
}
