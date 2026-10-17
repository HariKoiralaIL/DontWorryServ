package client.ui.screens {
import account.Account;

import beginnersoffer.BeginnersOfferButton;

import client.ui.frames.NewAccountNameOverlay;

import com.company.assembleegameclient.appengine.CharListEvent;
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.assembleegameclient.ui.KeyCountDisplay;
import com.company.assembleegameclient.ui.TextButton;
import com.company.assembleegameclient.ui.CurrencyDisplay;
import com.company.ui.SimpleText;

import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;
import flash.text.TextFieldAutoSize;

import game.dialogs.Dialog;
import game.dialogs.NameNeedsRegistrationDialog;

import signals.Signal;
import signals.nativesignals.NativeRelaySignal;

/**
 * Landing screen after login: player name, currencies, character list /
 * graveyard (switchable), news feed and the play / classes / main buttons.
 */
public class CurrentCharacterScreen extends BaseScreen {

    /** Height of the visible list area; taller lists get a scroll bar. */
    private static const VISIBLE_HEIGHT:int = 400;

    public var close:Signal;
    /** Never dispatched in this class; purpose unknown (was `_n7`). */
    public var unusedSignal:Signal;
    public var newCharacter:Signal;
    public var showClasses:Signal;
    public var chooseName:Signal;
    public var playGame:Signal;
    public var beginnersOfferButton:BeginnersOfferButton;

    private var model:CharListEvent;
    private var nameText:SimpleText;
    private var chooseNameButton:TextButton;
    private var goldCoinDisplay:CurrencyDisplay;
    private var keysDisplay:KeyCountDisplay;
    private var graveyardButton:TextButton;
    private var charactersButton:TextButton;
    private var newsText:SimpleText;
    private var charactersList:CharsAndNews;
    private var newsSection:CharsAndNews;
    private var listHeight:Number;
    private var playButton:MenuButton;
    private var mainButton:MenuButton;
    private var classesButton:MenuButton;
    private var boundaryLine:Shape;
    private var scrollBar:Scrollbar;
    private var curState:int = CharsAndNews.STATE_CHARACTERS;

    public function CurrentCharacterScreen() {
        addChild(new _charscreen());
        if (Account.getInstance().isRegistered()) {
            this.playButton = new MenuButton("play", 36, true);
            this.classesButton = new MenuButton("classes", 22, false);
        } else {
            this.playButton = new MenuButton("", 0, true);
            this.classesButton = new MenuButton("", 0, false);
        }
        this.mainButton = new MenuButton("main", 22, false);
        super(CurrentCharacterScreen);
        this.unusedSignal = new Signal();
        this.newCharacter = new Signal();
        this.close = new NativeRelaySignal(this.mainButton, MouseEvent.CLICK);
        this.showClasses = new NativeRelaySignal(this.classesButton, MouseEvent.CLICK);
        this.chooseName = new Signal();
        this.playGame = new Signal();
    }

    public function showBeginnersOffer():void {
        this.beginnersOfferButton = new BeginnersOfferButton();
        this.beginnersOfferButton.x = 39;
        this.beginnersOfferButton.y = 33;
        addChild(this.beginnersOfferButton);
    }

    override public function initialize(model:CharListEvent):void {
        super.initialize(model);
        this.model = model;
        this.buildUI(model);
    }

    private function buildUI(model:CharListEvent):void {
        this.buildName();
        this.buildCurrencies();
        this.buildNewsText();
        this.buildNewsSection();
        this.buildBoundaries();
        this.buildCharacterText();
        var graveyard:News = new News(model, News.MODE_DEATHS);
        if (graveyard.hasDeaths()) {
            this.buildGraveText();
        }
        this.buildCharacters();
        this.buildNavBar();
        if (!model.nameChosen_) {
            this.buildChooseName();
        }
    }

    private function getStageBounds():Rectangle {
        var bounds:Rectangle = new Rectangle();
        if (stage) {
            bounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        }
        return bounds;
    }

    private function buildNavBar():void {
        this.playButton.addEventListener(MouseEvent.CLICK, this.onPlayClick);
        this.playButton.x = ((800 / 2) - (this.playButton.width / 2));
        this.playButton.y = 545;
        addChild(this.playButton);
        this.mainButton.x = (((800 / 2) - (this.mainButton.width / 2)) - 94);
        this.mainButton.y = 555;
        addChild(this.mainButton);
        this.classesButton.x = (((800 / 2) - (this.classesButton.width / 2)) + 96);
        this.classesButton.y = 555;
        addChild(this.classesButton);
    }

    private function buildName():void {
        this.nameText = new SimpleText(22, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.nameText.setBold(true);
        this.nameText.text = this.model.name_;
        this.nameText.updateMetrics();
        this.nameText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.nameText.y = 24;
        this.nameText.x = ((this.getStageBounds().width / 2) - (this.nameText.width / 2));
        addChild(this.nameText);
    }

    private function buildChooseName():void {
        this.chooseNameButton = new TextButton(16, false, "");
        this.chooseNameButton.text_.setBold(true);
        this.chooseNameButton.text_.text = "choose name";
        this.chooseNameButton.text_.updateMetrics();
        this.chooseNameButton.addEventListener(MouseEvent.CLICK, this.onChooseNameClick);
        this.chooseNameButton.y = 50;
        this.chooseNameButton.text_.autoSize = TextFieldAutoSize.CENTER;
        this.chooseNameButton.x = ((this.getStageBounds().width / 2) - (this.chooseNameButton.width / 2));
        addChild(this.chooseNameButton);
    }

    private function buildCurrencies():void {
        this.buildGoldFame();
        this.buildKeys();
    }

    private function buildGoldFame():void {
        this.goldCoinDisplay = new CurrencyDisplay();
        this.goldCoinDisplay.draw(this.model.credits_, this.model.fame_);
        this.goldCoinDisplay.x = this.getStageBounds().width;
        this.goldCoinDisplay.y = 20;
        addChild(this.goldCoinDisplay);
    }

    private function buildKeys():void {
        this.keysDisplay = new KeyCountDisplay();
        this.keysDisplay.draw(this.model.keys_);
        this.keysDisplay.x = this.getStageBounds().width;
        this.keysDisplay.y = 44;
        addChild(this.keysDisplay);
    }

    private function buildNewsText():void {
        this.newsText = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.newsText.setBold(true);
        this.newsText.text = "News";
        this.newsText.updateMetrics();
        this.newsText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.newsText.x = 475;
        this.newsText.y = 79;
        addChild(this.newsText);
    }

    private function buildBoundaries():void {
        this.boundaryLine = new Shape();
        this.boundaryLine.graphics.clear();
        this.boundaryLine.graphics.lineStyle(3, 0xFFFFFF);
        this.boundaryLine.graphics.moveTo(0, 106);
        this.boundaryLine.graphics.lineTo(this.getStageBounds().width, 106);
        this.boundaryLine.graphics.lineStyle();
        addChild(this.boundaryLine);
    }

    private function buildCharacterText():void {
        this.charactersButton = this.createTabButton("Characters", 18);
        this.charactersButton.addEventListener(MouseEvent.CLICK, this.onCharactersTabClick);
        addChild(this.charactersButton);
    }

    private function buildGraveText():void {
        this.graveyardButton = this.createTabButton("Graveyard", 18 + 150);
        this.graveyardButton.addEventListener(MouseEvent.CLICK, this.onGraveyardTabClick);
        addChild(this.graveyardButton);
    }

    private function createTabButton(label:String, posX:int):TextButton {
        var button:TextButton = new TextButton(18, false, "", true);
        button.text_.setBold(true);
        button.text_.text = label;
        button.text_.textColor = 0xFFFFFF;
        button.text_.updateMetrics();
        button.x = posX;
        button.y = 79;
        return button;
    }

    private function buildScroll():void {
        this.scrollBar = new Scrollbar(16, (VISIBLE_HEIGHT - 1));
        this.scrollBar.x = 443;
        this.scrollBar.y = 113;
        this.scrollBar.setIndicatorSize((VISIBLE_HEIGHT - 1), this.charactersList.height);
        this.scrollBar.addEventListener(Event.CHANGE, this.onScroll);
        addChild(this.scrollBar);
    }

    private function buildCharacters():void {
        this.showList(CharsAndNews.STATE_CHARACTERS, 14);
    }

    private function buildGraveyard():void {
        this.showList(CharsAndNews.STATE_GRAVEYARD, 10);
    }

    private function showList(state:int, listX:int):void {
        this.curState = state;
        this.charactersList = new CharsAndNews(this.model, this, state);
        this.charactersList.x = listX;
        this.charactersList.y = 108;
        this.listHeight = this.charactersList.height;
        if (this.listHeight > VISIBLE_HEIGHT) {
            this.buildScroll();
        }
        addChild(this.charactersList);
    }

    private function buildNewsSection():void {
        this.newsSection = new CharsAndNews(this.model, this, CharsAndNews.STATE_NEWS);
        this.newsSection.x = 460;
        this.newsSection.y = 108;
        addChild(this.newsSection);
    }

    private function removeCurrentList():void {
        if (this.charactersList != null) {
            removeChild(this.charactersList);
            this.charactersList = null;
        }
        if (this.scrollBar != null) {
            removeChild(this.scrollBar);
            this.scrollBar = null;
        }
    }

    private function onCharactersTabClick(event:MouseEvent):void {
        if (this.curState != CharsAndNews.STATE_CHARACTERS) {
            this.removeCurrentList();
            this.buildCharacters();
        }
    }

    private function onGraveyardTabClick(event:MouseEvent):void {
        if (this.curState != CharsAndNews.STATE_GRAVEYARD) {
            this.removeCurrentList();
            this.buildGraveyard();
        }
    }

    private function onChooseNameClick(event:Event):void {
        if (!Account.getInstance().isRegistered()) {
            var registrationDialog:NameNeedsRegistrationDialog = new NameNeedsRegistrationDialog();
            registrationDialog.addEventListener(Dialog.BUTTON1_EVENT, this.onRegistrationDialogCancel);
            registrationDialog.addEventListener(Dialog.BUTTON2_EVENT, this.onRegistrationDialogRegister);
            addChild(registrationDialog);
            return;
        }
        var nameOverlay:NewAccountNameOverlay = new NewAccountNameOverlay();
        nameOverlay.addEventListener(Event.COMPLETE, this.onNameChosen);
        addChild(nameOverlay);
    }

    private function onNameChosen(event:Event):void {
        this.chooseName.dispatch();
    }

    private function onRegistrationDialogCancel(event:Event):void {
        var dialog:Dialog = (event.currentTarget as Dialog);
        removeChild(dialog);
    }

    private function onRegistrationDialogRegister(event:Event):void {
        var dialog:Dialog = (event.currentTarget as Dialog);
        removeChild(dialog);
        openAccountManagement();
    }

    private function onScroll(event:Event):void {
        this.charactersList.setScrollY(((-(this.scrollBar.getPosition())) * (this.listHeight - VISIBLE_HEIGHT)));
    }

    private function onPlayClick(event:Event):void {
        if (this.model.numChars_ == 0 && this.model.hasAvailableCharSlot()) {
            this.newCharacter.dispatch();
        } else {
            this.playGame.dispatch();
        }
    }

}
}
