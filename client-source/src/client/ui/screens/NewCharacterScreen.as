package client.ui.screens {
import com.company.assembleegameclient.appengine.CharListEvent;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui.ui_goldcoin;

import flash.events.Event;
import flash.events.MouseEvent;

import signals.Signal;

/** Class-selection screen shown when creating a new character. */
public class NewCharacterScreen extends BaseScreen {

    private static const COLUMNS:int = 5;
    private static const CELL_SIZE:int = 140;
    private static const GRID_LEFT:int = 50;
    private static const GRID_TOP:int = 60;

    public var close:Signal;
    public var play:Signal;

    private var backButton:MenuButton;
    private var goldCoinDisplay:ui_goldcoin;
    /** CharacterBox instances keyed by player object type. */
    private var characterBoxes:Object = {};

    public function NewCharacterScreen() {
        addChild(new _charscreen());
        super(CurrentCharacterScreen);
        this.play = new Signal(int);
        this.close = new Signal();
    }

    override public function initialize(model:CharListEvent):void {
        super.initialize(model);
        this.backButton = new MenuButton("back", 36, false);
        this.backButton.addEventListener(MouseEvent.CLICK, this.onBackClick);
        addChild(this.backButton);
        this.goldCoinDisplay = new ui_goldcoin();
        this.goldCoinDisplay.draw(model.credits_, model.fame_);
        addChild(this.goldCoinDisplay);
        this.buildCharacterBoxes(model);
        this.backButton.x = ((800 / 2) - (this.backButton.width / 2));
        this.backButton.y = 545;
        this.goldCoinDisplay.x = 800;
        this.goldCoinDisplay.y = 20;
    }

    private function buildCharacterBoxes(model:CharListEvent):void {
        var index:int = 0;
        while (index < ObjectLibrary._tj.length) {
            var playerXML:XML = ObjectLibrary._tj[index];
            var objectType:int = int(playerXML.@type);
            var box:CharacterBox = new CharacterBox(playerXML, model.charStats_[objectType], model);
            box.x = (((GRID_LEFT + (CELL_SIZE * int((index % COLUMNS)))) + (CELL_SIZE / 2)) - (box.width / 2));
            box.y = (GRID_TOP + (CELL_SIZE * int((index / COLUMNS))));
            this.characterBoxes[objectType] = box;
            box.addEventListener(MouseEvent.ROLL_OVER, this.onBoxRollOver);
            box.addEventListener(Event.ENTER_FRAME, this.onBoxEnterFrame);
            box.addEventListener(Event.REMOVED_FROM_STAGE, this.onBoxRemovedFromStage);
            box.addEventListener(MouseEvent.ROLL_OUT, this.onBoxRollOut);
            if (model.hasAvailableCharSlot()) {
                box.addEventListener(MouseEvent.CLICK, this.onBoxClick);
            }
            addChild(box);
            index++;
        }
    }

    public function onBoxEnterFrame(event:Event):void {
        (event.currentTarget as CharacterBox).tryUpdateSpin();
    }

    public function onBoxRemovedFromStage(event:Event):void {
        (event.currentTarget as CharacterBox).removeEventListener(Event.ENTER_FRAME, this.onBoxEnterFrame);
    }

    private function onBackClick(event:Event):void {
        this.close.dispatch();
    }

    private function onBoxRollOver(event:MouseEvent):void {
        var box:CharacterBox = (event.currentTarget as CharacterBox);
        box.setHighlighted(true);
        box.selectedOver = true;
        tooltip.dispatch(box.getTooltip());
    }

    private function onBoxRollOut(event:MouseEvent):void {
        var box:CharacterBox = (event.currentTarget as CharacterBox);
        box.setHighlighted(false);
        box.selectedOver = false;
        tooltip.dispatch(null);
    }

    private function onBoxClick(event:MouseEvent):void {
        tooltip.dispatch(null);
        var box:CharacterBox = (event.currentTarget as CharacterBox);
        if (!box.available) {
            return;
        }
        this.play.dispatch(box.objectType());
    }

}
}
