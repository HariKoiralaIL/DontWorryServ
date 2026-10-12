package com.company.assembleegameclient.tutorial {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.PointUtil;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.utils.getTimer;

import zerorealms.rotmg.assets.DataEmbeds;

public class Tutorial extends Sprite {

    // Step actions / requirement types
    public static const NEXT:String = "Next";
    public static const MOVE_FORWARD:String = "MoveForward";
    public static const MOVE_BACKWARD:String = "MoveBackward";
    public static const ROTATE_LEFT:String = "RotateLeft";
    public static const ROTATE_RIGHT:String = "RotateRight";
    public static const MOVE_LEFT:String = "MoveLeft";
    public static const MOVE_RIGHT:String = "MoveRight";
    public static const UPDATE:String = "Update";
    public static const ATTACK:String = "Attack";
    public static const DAMAGE:String = "Damage";
    public static const KILL:String = "Kill";
    public static const SHOW_LOOT:String = "ShowLoot";
    public static const TEXT:String = "Text";
    public static const SHOW_PORTAL:String = "ShowPortal";
    public static const ENTER_PORTAL:String = "EnterPortal";
    public static const NEAR:String = "Near";
    public static const EQUIP:String = "Equip";

    public var gs_:GameSprite;
    public var steps_:Vector.<Step>;
    public var currentStep_:int = 0;

    private var dim_:Sprite;
    private var glowShape_:Shape;
    private var outlineShape_:Shape;

    public function Tutorial(gs:GameSprite) {
        this.steps_ = new Vector.<Step>();
        this.dim_ = new Sprite();
        this.glowShape_ = new Shape();
        this.outlineShape_ = new Shape();
        super();
        this.gs_ = gs;
        for each (var stepXml:XML in DataEmbeds._3H_.Step) {
            this.steps_.push(new Step(stepXml));
        }
        addChild(this.glowShape_);
        addChild(this.outlineShape_);
        var g:Graphics = this.dim_.graphics;
        g.clear();
        g.beginFill(0, 0.1);
        g.drawRect(0, 0, 800, 600);
        g.endFill();
        Parameters.data_.needsTutorial = false;
        Parameters.save();
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    internal function doneAction(action:String):void {
        if (this.currentStep_ >= this.steps_.length) {
            return;
        }
        var step:Step = this.steps_[this.currentStep_];
        if (action != step.action_) {
            return;
        }
        var player:Player = this.gs_.map_.player_;
        for each (var req:Requirement in step.requirements_) {
            switch (req.type_) {
                case NEAR:
                    // NOTE: unlike onEnterFrame, this check ignores req.objectName_.
                    if (!this.isNearObject(req, player, false)) {
                        return;
                    }
                    break;
                case EQUIP:
                    if (player.equipment_[req.slot_] != req.objectType_) {
                        return;
                    }
                    break;
            }
        }
        this.currentStep_++;
    }

    private function isNearObject(req:Requirement, player:Player, matchName:Boolean):Boolean {
        for each (var obj:GameObject in this.gs_.map_.goDict_) {
            if (obj.objectType_ != req.objectType_) {
                continue;
            }
            if (matchName && req.objectName_ != "" && obj.name_ != req.objectName_) {
                continue;
            }
            if (PointUtil._R_O_(obj.x_, obj.y_, player.x_, player.y_) <= req.radius_) {
                return true;
            }
        }
        return false;
    }

    private function onAddedToStage(e:Event):void {
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onRemovedFromStage(e:Event):void {
        removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(e:Event):void {
        var pulse:Number = Math.abs(Math.sin(getTimer() / 300));
        this.glowShape_.filters = [new BlurFilter(5 + pulse * 5, 5 + pulse * 5)];
        this.outlineShape_.graphics.clear();
        this.glowShape_.graphics.clear();
        var player:Player = this.gs_.map_.player_;
        for each (var step:Step in this.steps_) {
            var allMet:Boolean = true;
            for each (var req:Requirement in step.requirements_) {
                if (req.type_ == NEAR && !this.isNearObject(req, player, true)) {
                    allMet = false;
                }
            }
            if (!allMet) {
                step.startTime_ = 0;
                continue;
            }
            if (step.startTime_ == 0) {
                step.startTime_ = getTimer();
            }
            var elapsed:int = getTimer() - step.startTime_;
            for each (var box:UIDrawBox in step.boxes_) {
                box.draw(5 * pulse, this.outlineShape_.graphics, elapsed);
                box.draw(6 * pulse, this.glowShape_.graphics, elapsed);
            }
            for each (var arrow:UIDrawArrow in step.arrows_) {
                arrow.draw(5 * pulse, this.outlineShape_.graphics, elapsed);
                arrow.draw(6 * pulse, this.glowShape_.graphics, elapsed);
            }
        }
    }

}
}
