package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.tutorial.Tutorial;
import com.company.assembleegameclient.tutorial.doneAction;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.engine.TextBlock;
import flash.text.engine.TextLine;
import flash.ui.Keyboard;
import flash.utils.Timer;
import flash.utils.getTimer;

import game.marketplace.MarketplaceContainerUI;

/**
 * The in-game chat: shows recent messages, handles the input field, chat
 * hotkeys (/, enter, tell, guild, party), scrolling and sent-message history.
 *
 * Formerly: ui_chat
 */
public class Chat extends Sprite {

    /** Number of messages shown at once; also the scroll step. */
    private static const VISIBLE_MESSAGES:int = 7;
    /** Time after which a message fades from the (unscrolled) chat, in milliseconds. */
    private static const MESSAGE_LIFETIME_MS:int = 20000;
    /** Indent of wrapped lines. */
    private static const WRAP_INDENT:int = 20;
    private static const MIN_LINE_HEIGHT:int = 16;
    private static const MESSAGE_SPACING:int = 4;
    private static const SENT_HISTORY_SIZE:int = 4;

    /** True while the chat input field has focus (formerly _0G_B_). */
    public static var inputActive_:Boolean = false;

    /** All received messages, shared by every Chat instance (formerly _dL_). */
    private static var messages_:Vector.<ChatMessage> = new <ChatMessage>[];

    /** Container of the rendered message lines (formerly _01P_). */
    public var messageHolder_:Sprite;

    private var gs_:GameSprite;
    private var w_:int;
    private var h_:int;
    /** Height of the rendered messages (formerly _5D_). */
    private var contentHeight_:Number;
    private var inputField_:TextField;
    /** The chat was scrolled up: old messages stay visible (formerly _O_C_). */
    private var scrolled_:Boolean = false;
    /** How many messages the view is scrolled back (formerly _zS_). */
    private var scrollOffset_:int = 0;
    /** Names of players recently whispered with, for /tell cycling (formerly _eU_). */
    private var tellNames_:Array = [];
    private var tellIndex_:int = 0;
    /** Re-renders messages once per second so old ones fade (formerly _T_U_). */
    private var refreshTimer_:Timer = new Timer(1000);
    /** The last messages sent, newest first. */
    private var sentHistory_:Array = ["", "", "", ""];
    private var historyIndex_:int = 0;

    public function Chat(gs:GameSprite, width:int, height:int) {
        super();
        this.gs_ = gs;
        this.w_ = width;
        this.h_ = height;
        this.messageHolder_ = new Sprite();
        this.messageHolder_.x = 2;
        this.messageHolder_.filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];
        addChild(this.messageHolder_);
        var format:TextFormat = new TextFormat();
        format.font = "Myriad Pro";
        format.size = 14;
        format.color = 0xFFFFFF;
        format.bold = true;
        this.inputField_ = new TextField();
        this.inputField_.embedFonts = true;
        this.inputField_.defaultTextFormat = format;
        this.inputField_.type = TextFieldType.INPUT;
        this.inputField_.border = true;
        this.inputField_.borderColor = 0xFFFFFF;
        this.inputField_.maxChars = 320;
        this.inputField_.filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];
        this.inputField_.addEventListener(KeyboardEvent.KEY_UP, this.onInputKeyUp);
        this.inputField_.width = this.w_ - 2;
        this.inputField_.height = 18;
        mouseEnabled = false;
        mouseChildren = false;
        this.addText(Parameters.SendClient, Parameters.buildLabel());
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    /** Adds a client-side message (no sender id / stars). */
    public function addText(name:String, text:String):void {
        messages_.push(new ChatMessage(getTimer(), name, -1, "", false, text));
        this.refreshMessages();
    }

    /**
     * Adds a message received from the server. Formerly _ro.
     *
     * @param name      sender name
     * @param objectId  sender object id (unused)
     * @param numStars  sender's star count
     * @param recipient "" for public chat, a player name for tells, or the guild / party channel
     * @param text      message text
     */
    public function addMessage(name:String, objectId:int, numStars:int, recipient:String, text:String):void {
        var sentByLocalPlayer:Boolean = (recipient != "") && (name == this.gs_.charList_.name_);
        var toLocalPlayer:Boolean = (recipient == this.gs_.charList_.name_);
        messages_.push(new ChatMessage(getTimer(), name, numStars, recipient, toLocalPlayer, text));
        this.refreshMessages();
        if (toLocalPlayer) {
            this.rememberTellName(name);
        } else if (recipient != Parameters.SendGuild && recipient != Parameters.SendParty) {
            if (sentByLocalPlayer) {
                this.rememberTellName(recipient);
            }
        }
    }

    private function rememberTellName(name:String):void {
        if (this.tellNames_.length == 0 || this.tellNames_[this.tellNames_.length - 1] != name) {
            this.tellNames_.push(name);
        }
    }

    /** Formerly _01f */
    private function clearMessages():void {
        while (this.messageHolder_.numChildren > 0) {
            this.messageHolder_.removeChildAt(0);
        }
        this.messageHolder_.graphics.clear();
        this.contentHeight_ = 0;
    }

    /** Lays out one message (wrapping long lines) below the previous ones. Formerly _0C_v. */
    private function appendTextBlock(block:TextBlock):void {
        var holder:Sprite = new Sprite();
        var line:TextLine;
        var linesHeight:Number = 0;
        while ((line = block.createTextLine(line, (linesHeight == 0) ? (this.w_ - 4) : ((this.w_ - 4) - WRAP_INDENT)))) {
            line.x = (linesHeight == 0) ? 0 : WRAP_INDENT;
            line.y = line.ascent + linesHeight;
            linesHeight = linesHeight + Math.max(MIN_LINE_HEIGHT, line.height);
            holder.addChild(line);
        }
        if (this.contentHeight_ != 0) {
            this.contentHeight_ = this.contentHeight_ + MESSAGE_SPACING;
        }
        holder.y = this.contentHeight_;
        this.messageHolder_.addChild(holder);
        this.contentHeight_ = this.contentHeight_ + linesHeight;
    }

    /** Re-renders the visible messages. Formerly _x5. */
    private function refreshMessages():void {
        this.clearMessages();
        var now:int = getTimer();
        var first:int = Math.max(0, ((messages_.length - 1) - this.scrollOffset_) - VISIBLE_MESSAGES);
        var end:int = Math.min(messages_.length, (first + VISIBLE_MESSAGES) + 1);
        for (var i:int = first; i < end; i++) {
            var message:ChatMessage = messages_[i];
            var expired:Boolean = !this.scrolled_ && (now > (message.time_ + MESSAGE_LIFETIME_MS));
            if (!expired) {
                this.appendTextBlock(message.createTextBlock());
            }
        }
        this.updateLayout();
    }

    /**
     * Handles client-side chat commands.
     * @return true if the text was handled locally and must not be sent to the server
     * Formerly _2T_.
     */
    private function handleLocalCommand(text:String):Boolean {
        if (text == "/?") {
            this.addText(Parameters.SendHelp, Parameters.HelpCommand);
            return true;
        }
        if (text == "/market") {
            this.gs_.addChild(new MarketplaceContainerUI(this.gs_));
            return true;
        }
        if (text == "/set" || text == "/mscale") {
            // Swallowed: the set-give UI is disabled and /mscale needs an argument.
            return true;
        }
        var scaleMatch:Array = text.match("/mscale (\\d*\\.*\\d+)$");
        if (scaleMatch != null) {
            Parameters.data_["mscale"] = scaleMatch[1];
            Parameters.save();
            dispatchEvent(new Event(Event.RESIZE));
            this.addText(Parameters.SendHelp, "Map Scale: " + scaleMatch[1]);
            return true;
        }
        return false;
    }

    /** Fills the input with "/tell <name> ", cycling through recent names. Formerly _03z. */
    private function cycleTellRecipient(forward:Boolean):void {
        this.inputField_.text = "/tell ";
        if (this.tellNames_.length != 0) {
            if (forward) {
                this.tellIndex_++;
            } else {
                this.tellIndex_--;
            }
            if (this.tellIndex_ <= 0) {
                this.tellIndex_ = 0;
            }
            if (this.tellIndex_ >= this.tellNames_.length) {
                this.tellIndex_ = this.tellNames_.length - 1;
            }
            this.inputField_.appendText(this.tellNames_[this.tellIndex_] + " ");
        }
        this.moveCaretToEnd();
    }

    private function moveCaretToEnd():void {
        this.inputField_.setSelection(this.inputField_.length, this.inputField_.length);
    }

    /** Shows the input field and gives it focus. Formerly _0C_X_. */
    private function openInput():void {
        this.inputField_.type = TextFieldType.INPUT;
        this.inputField_.border = true;
        this.inputField_.borderColor = 0xFFFFFF;
        Chat.inputActive_ = true;
        addChild(this.inputField_);
        if (stage != null) {
            stage.focus = this.inputField_;
        }
        this.updateLayout();
        this.tellIndex_ = this.tellNames_.length;
    }

    /** Formerly _016 */
    private function closeInput():void {
        this.historyIndex_ = 0;
        if (stage != null) {
            stage.focus = null;
        }
        if (contains(this.inputField_)) {
            Chat.inputActive_ = false;
            removeChild(this.inputField_);
        }
        this.updateLayout();
    }

    /** Keeps the messages just above the bottom edge / input field. Formerly _K_C_. */
    private function updateLayout():void {
        if (contains(this.inputField_)) {
            this.messageHolder_.y = ((this.h_ - 8) - this.inputField_.height) - this.contentHeight_;
        } else {
            this.messageHolder_.y = (this.h_ - 4) - this.contentHeight_;
        }
    }

    /** Formerly _kh */
    private function onTimer(event:TimerEvent):void {
        this.refreshMessages();
    }

    private function onAddedToStage(event:Event):void {
        stage.addEventListener(KeyboardEvent.KEY_UP, this.onStageKeyUp);
        this.inputField_.y = this.h_ - 20;
        this.updateLayout();
        this.refreshTimer_.addEventListener(TimerEvent.TIMER, this.onTimer);
        this.refreshTimer_.start();
    }

    private function onRemovedFromStage(event:Event):void {
        stage.removeEventListener(KeyboardEvent.KEY_UP, this.onStageKeyUp);
        this.refreshTimer_.stop();
        this.refreshTimer_.removeEventListener(TimerEvent.TIMER, this.onTimer);
    }

    /** Chat hotkeys while the game has focus. Formerly _H_H_. */
    private function onStageKeyUp(event:KeyboardEvent):void {
        switch (event.keyCode) {
            case Parameters.data_.chatCommand:
                if (stage.focus == null) {
                    this.openInput();
                    this.inputField_.text = "/";
                    this.moveCaretToEnd();
                }
                return;
            case Parameters.data_.chat:
                if (stage.focus == null) {
                    this.openInput();
                }
                return;
            case Parameters.data_.tell:
                if (stage.focus == null) {
                    this.openInput();
                }
                this.cycleTellRecipient(event.shiftKey);
                return;
            case Parameters.data_.guildChat:
                if (stage.focus == null) {
                    this.openInput();
                    this.inputField_.text = "/g ";
                    this.moveCaretToEnd();
                }
                return;
            case Parameters.data_.partyChat:
                if (stage.focus == null) {
                    this.openInput();
                    this.inputField_.text = "/p ";
                    this.moveCaretToEnd();
                }
                return;
            case Parameters.data_.scrollChatUp:
                if (!this.scrolled_) {
                    this.scrolled_ = true;
                } else {
                    this.scrollOffset_ = Math.max(0, Math.min(messages_.length - VISIBLE_MESSAGES, this.scrollOffset_ + VISIBLE_MESSAGES));
                }
                this.refreshMessages();
                return;
            case Parameters.data_.scrollChatDown:
                if (this.scrollOffset_ == 0) {
                    this.scrolled_ = false;
                } else {
                    this.scrollOffset_ = Math.max(0, this.scrollOffset_ - VISIBLE_MESSAGES);
                }
                this.refreshMessages();
                return;
        }
    }

    /** Enter sends the message, Up recalls previously sent ones. Formerly _0_e. */
    private function onInputKeyUp(event:KeyboardEvent):void {
        switch (event.keyCode) {
            case Keyboard.ENTER:
                if (this.inputField_.text.length != 0) {
                    if (!this.handleLocalCommand(this.inputField_.text) && this.gs_.map_.player_ != null) {
                        this.gs_.gsc_.playerText(this.inputField_.text);
                        doneAction(this.gs_, Tutorial.TEXT);
                    }
                    this.addToSentHistory(this.inputField_.text);
                    this.inputField_.text = "";
                }
                this.closeInput();
                event.stopImmediatePropagation();
                return;
            case Keyboard.UP:
                if (this.historyIndex_ > SENT_HISTORY_SIZE - 1) {
                    this.historyIndex_ = 0;
                }
                if (this.sentHistory_[this.historyIndex_] != null && this.sentHistory_[this.historyIndex_] != "") {
                    if (this.gs_.map_.player_ != null) {
                        this.inputField_.text = this.sentHistory_[this.historyIndex_];
                        this.moveCaretToEnd();
                        this.historyIndex_++;
                    }
                } else {
                    this.historyIndex_ = 0;
                    if (this.sentHistory_[0] != null) {
                        if (this.gs_.map_.player_ != null) {
                            this.inputField_.text = this.sentHistory_[0];
                            this.moveCaretToEnd();
                        }
                    }
                }
        }
    }

    /** Shifts older entries down and stores the new message first (skipping duplicates / blanks). */
    private function addToSentHistory(text:String):void {
        for (var i:int = SENT_HISTORY_SIZE - 1; i >= 1; i--) {
            var previous:String = this.sentHistory_[i - 1];
            if (previous != null && this.sentHistory_[i] != previous && previous != "") {
                this.sentHistory_[i] = previous;
            }
        }
        this.sentHistory_[0] = text;
    }
}
}
