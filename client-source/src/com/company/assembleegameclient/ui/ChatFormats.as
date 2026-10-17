package com.company.assembleegameclient.ui {
import flash.text.engine.CFFHinting;
import flash.text.engine.ElementFormat;
import flash.text.engine.FontDescription;
import flash.text.engine.FontLookup;
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;
import flash.text.engine.RenderingMode;

/**
 * The set of text formats (one per colour) used when rendering chat lines.
 *
 * Formerly: _vi
 */
public class ChatFormats {

    private static const FONT_NAME:String = "MyriadProCFF,_sans";
    private static const DEFAULT_FONT_SIZE:int = 13;
    private static const CUSTOM_COLOR_FONT_SIZE:int = 14;

    public var TextColour:ElementFormat = createFormat(0xFFFFFF);
    public var InfoColour:ElementFormat = createFormat(0xFFFF00);
    public var ClientColour:ElementFormat = createFormat(0x0000FF);
    public var HelpColour:ElementFormat = createFormat(0xFF5B05);
    public var ErrorColour:ElementFormat = createFormat(0xFF0000);
    public var AdminColour:ElementFormat = createFormat(0xFFFFFF);
    public var BledixonColour:ElementFormat = createFormat(0xFF00FF);
    public var EnemyColour:ElementFormat = createFormat(0xFFA800);
    public var PlayerColour:ElementFormat = createFormat(0x00FF00);
    /** Colour of the space between a name tag and the message (formerly _cK_). */
    public var SpacerColour:ElementFormat = createFormat(0x363636);
    public var TellColour:ElementFormat = createFormat(0x00F0FF);
    public var GuildColour:ElementFormat = createFormat(0xA6FF5D);
    public var PartyNameColour:ElementFormat = createFormat(0x7474F7);
    public var PartyTextColour:ElementFormat = createFormat(0xABABF4);

    /** Format for server-supplied "{c}...{/c}" colours. */
    public static function createColor(color:uint):ElementFormat {
        return createFormatWithSize(color, CUSTOM_COLOR_FONT_SIZE);
    }

    private static function createFormat(color:uint):ElementFormat {
        return createFormatWithSize(color, DEFAULT_FONT_SIZE);
    }

    private static function createFormatWithSize(color:uint, fontSize:int):ElementFormat {
        var format:ElementFormat = new ElementFormat();
        format.fontDescription = new FontDescription(FONT_NAME, FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.HORIZONTAL_STEM);
        format.fontSize = fontSize;
        format.color = color;
        return format;
    }
}
}
