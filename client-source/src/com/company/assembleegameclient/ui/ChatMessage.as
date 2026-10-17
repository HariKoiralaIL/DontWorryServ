package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.FameUtil;

import flash.display.Sprite;
import flash.text.engine.ContentElement;
import flash.text.engine.ElementFormat;
import flash.text.engine.GraphicElement;
import flash.text.engine.GroupElement;
import flash.text.engine.TextBlock;
import flash.text.engine.TextElement;

/**
 * A single chat line (sender, optional star icon, recipient, text) that can
 * build the coloured TextBlock for display.
 *
 * Formerly: ui_chat_colors
 */
public class ChatMessage {

    private static var formats_:ChatFormats = new ChatFormats();

    public var time_:int;
    public var name_:String;
    /** Star icon shown before the sender's name (formerly _L_P_). */
    public var starIcon_:Sprite = null;
    public var recipient_:String;
    /** The message was whispered to the local player (formerly _E_B_). */
    public var toLocalPlayer_:Boolean;
    public var text_:String;

    /**
     * @param time           creation time (getTimer())
     * @param name           sender name; special prefixes: "#" enemy, "@" admin, "!" special
     * @param numStars       sender's star count, or a negative number for no star icon
     * @param recipient      "" for public chat, a player name for tells, or the guild / party channel
     * @param toLocalPlayer  true when the tell was addressed to the local player
     * @param text           message text; "{c}0xRRGGBB{/c}" switches the colour of the following text
     */
    public function ChatMessage(time:int, name:String, numStars:int, recipient:String, toLocalPlayer:Boolean, text:String) {
        this.time_ = time;
        this.name_ = name;
        if (numStars >= 0) {
            this.starIcon_ = FameUtil.numStarsToIcon(numStars);
        }
        this.recipient_ = recipient;
        this.toLocalPlayer_ = toLocalPlayer;
        this.text_ = text;
    }

    /** Formerly _0H_u */
    public function createTextBlock():TextBlock {
        var elements:Vector.<ContentElement> = new <ContentElement>[];
        var nameFormat:ElementFormat = formats_.PlayerColour;
        var spacerFormat:ElementFormat = formats_.SpacerColour;
        var textFormat:ElementFormat = formats_.TextColour;
        var displayName:String = this.name_;
        switch (this.name_) {
            case Parameters.SendInfo:
                displayName = "";
                textFormat = formats_.InfoColour;
                break;
            case Parameters.SendClient:
                displayName = "";
                textFormat = formats_.ClientColour;
                break;
            case Parameters.SendHelp:
                displayName = "";
                textFormat = formats_.HelpColour;
                break;
            case Parameters.SendError:
                textFormat = formats_.ErrorColour;
                displayName = "";
                break;
        }
        if (this.name_.charAt(0) == "#") {
            displayName = this.name_.substr(1);
            nameFormat = formats_.EnemyColour;
        }
        if (this.name_.charAt(0) == "@") {
            displayName = this.name_.substr(1);
            nameFormat = formats_.AdminColour;
        }
        if (this.name_.charAt(0) == "!") {
            displayName = this.name_.substr(1);
            nameFormat = formats_.BledixonColour;
        }
        if (this.recipient_ == Parameters.SendGuild) {
            textFormat = formats_.GuildColour;
        } else if (this.recipient_ == Parameters.SendParty) {
            nameFormat = formats_.PartyNameColour;
            textFormat = formats_.PartyTextColour;
        } else if (this.recipient_ != "") {
            nameFormat = formats_.TellColour;
            textFormat = formats_.TellColour;
            if (!this.toLocalPlayer_) {
                elements.push(new TextElement("To: ", formats_.TellColour));
                nameFormat = formats_.TellColour;
                displayName = this.recipient_;
                this.starIcon_ = null;
            }
        }
        if (this.starIcon_ != null) {
            this.starIcon_.y = 3;
            elements.push(new GraphicElement(this.starIcon_, this.starIcon_.width + 2, this.starIcon_.height, formats_.TextColour));
        }
        if (displayName != "") {
            elements.push(new TextElement("<" + displayName + ">", nameFormat), new TextElement(" ", spacerFormat));
            elements.push(new TextElement(this.text_, textFormat));
        } else {
            // System messages may contain inline colour markers.
            var segments:Array = this.text_.split("{c}");
            for each (var segment:String in segments) {
                if (segment.indexOf("{/c}") != -1) {
                    var colorText:String = segment.substr(0, segment.indexOf("{/c}"));
                    textFormat = ChatFormats.createColor(uint(colorText));
                    segment = segment.substr(segment.indexOf("{/c}") + 4);
                }
                elements.push(new TextElement(segment, textFormat));
            }
        }
        return new TextBlock(new GroupElement(elements));
    }
}
}
