package com.company.assembleegameclient.parameters {
import com.company.util.DateUtil;
import com.company.util.KeyCodes;

import flash.display.DisplayObject;
import flash.net.LocalConnection;
import flash.net.SharedObject;
import flash.utils.Dictionary;

public class Parameters {

    private static const DAY_MS:Number = 24 * 60 * 60 * 1000;

    public static const standalone:Boolean = false;

    public static const isTesting:Boolean = true; // Kind of has to be true?
    public static const sendErrors:Boolean = false;
    public static const clientVersion:String = "reborn x2.1.2";
    public static const useRC4:Boolean = true;
    public static const gamePort:int = 2050;
    public static const _1h:Boolean = false;
    public static const _1C_c:uint = 0x000000;
    public static const _mg:uint = 10944349;
    public static const _8T_:uint = 0xFCDF00;
    public static const _colorBled:uint = 0xFF1D8E;
    public static const _colorArc:uint = 0x2ECC71;
    public static const _colorSec:uint = 0xFF0000;
    public static const partyColor:uint = 0x709BFF;
    public static const _F_g:int = 60;
    public static const RotationSpeed:Number = 0.003;
    public static const _E_S_:int = 120;
    public static const SendInfo:String = "";
    public static const SendClient:String = "*Client*";
    public static const SendError:String = "*Error*";
    public static const SendHelp:String = "*Help*";
    public static const SendGuild:String = "*Guild*";
    public static const SendParty:String = "*Party*";
    public static const _0u:int = 1000;
    public static const _0H_m:int = 1000;
    public static const TUT_ID:int = -1;
    public static const NEXUS_ID:int = -2;
    public static const RAND_REALM:int = -3;
    public static const NEXUS_LIMBO:int = -4;
    public static const TEST_ID:int = -6;
    public static const _K_5:Number = 18;
    public static const ToS_Url_:String = "http://www.realmofthemadgod.com/TermsofUse.html";
    public static const musicUrl_:String = "bledixon.github.io";
    public static const connection:String = serverAddress();
    public static const HelpCommand:String = "Help:\n" + "[/pause]: pause the game (until you [/pause] again\n" + "[/who]: list players online\n" + "[/tutorial]: enter the tutorial\n" + "[/yell <message>]: send message to all players in Nexus\n" + "[/tell <player name> <message>]: send a private message to a player\n" + "[/guild <message>]: send a message to your guild\n" + "[/ignore <player name>]: don't show chat messages from player\n" + "[/unignore <player name>]: stop ignoring a player\n" + "[/teleport <player name>]: teleport to a player\n" + "[/trade <player name>]: request a trade with a player\n" + "[/invite <player name>]: invite a player to your guild\n" + "[/join <guild name>]: join a guild (invite necessary\n" + "[/?]: this message";
    public static const RC4_OUTGOING_KEY:String = "311f80691451c71b09a13a2a6e";
    public static const RC4_INCOMING_KEY:String = "72c5583cafb6818995cbd74b80";
    public static const RSAKey:String = "-----BEGIN PUBLIC KEY-----\n" + "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzRQGnNw5kEaIpych+U4J" + "ZtuLnMJuQKEyU1FfcyHISNkYhy1jmSMPav+7D3Qg1R6exeeM6LtXvUEQ6Fgris1J" + "UVDr5gjII0ti98LvIsF/hgTk2VOvm2QK/1OpyAxni4RZuR8OE0p0Co0yUwhTVjfN" + "5Ooh4hntfuwVtk1AZEFudA9oOqdUbNwi98M9VIf+9vJWnx2zAx+1r7Ja/JDeM3Fb" + "YW9awMw4d0fpGoN/PfZGqKdgd4jjXLuhatSu13sAU39aPZAI2ku3MQRMQcUBLxDI" + "HyEq1NA+BztASjpYr3w+bX85bWZwPOBN95O3z6hbDTv/FZj5tpkVqaVhxqBeEbaR" + "ywIDAQAB\n" + "-----END PUBLIC KEY-----";

    public static var root:DisplayObject;
    public static var data_:Object = null;
    public static var _R_P_:int = 1;
    public static var _Q_b:int = 0;
    public static var _Q_w:Boolean = true;
    public static var _0F_o:Boolean = false;
    public static var _ih:Boolean = false;
    public static var _hk:Boolean = true;
    private static var sharedObject_:SharedObject = null;
    private static var keyActions_:Dictionary = new Dictionary();

    public static function buildLabel():String {
        return (Parameters.isTesting ? "Project B" : "Devel") + " Build #" + Parameters.clientVersion + (isTestingDomain() ? " Testing" : "");
    }

    public static function isTestingDomain():Boolean {
        return new LocalConnection().domain != "yoursite.com";
    }

    public static function serverAddress():String {
        return "127.0.0.1:8080";
    }

    public static function load():void {
        try {
            sharedObject_ = SharedObject.getLocal("SeraphsDominionOptions", "/");
            data_ = sharedObject_.data;
        } catch (error:Error) {
            data_ = {};
        }
        initDefaults();
        save();
    }

    public static function save():void {
        try {
            if (sharedObject_ != null) {
                sharedObject_.flush();
            }
        } catch (error:Error) {
        }
    }

    /** Binds keyCode to action, unbinding any other action that used it. */
    public static function setKey(action:String, keyCode:uint):void {
        for (var other:String in keyActions_) {
            if (data_[other] == keyCode) {
                data_[other] = KeyCodes.UNSET; // unbound
            }
        }
        data_[action] = keyCode;
    }

    public static function initDefaults():void {
        initKeyBindings();
        initSettings();
        initSurvey();
    }

    private static function initKeyBindings():void {
        defaultKey("moveLeft", KeyCodes.A);
        defaultKey("moveRight", KeyCodes.D);
        defaultKey("moveUp", KeyCodes.W);
        defaultKey("moveDown", KeyCodes.S);
        defaultKey("rotateLeft", KeyCodes.Q);
        defaultKey("rotateRight", KeyCodes.E);
        defaultKey("useSpecial", KeyCodes.SPACE);
        defaultKey("interact", KeyCodes.NUMBER_0);
        defaultKey("useInvSlot1", KeyCodes.NUMBER_1);
        defaultKey("useInvSlot2", KeyCodes.NUMBER_2);
        defaultKey("useInvSlot3", KeyCodes.NUMBER_3);
        defaultKey("useInvSlot4", KeyCodes.NUMBER_4);
        defaultKey("useInvSlot5", KeyCodes.NUMBER_5);
        defaultKey("useInvSlot6", KeyCodes.NUMBER_6);
        defaultKey("useInvSlot7", KeyCodes.NUMBER_7);
        defaultKey("useInvSlot8", KeyCodes.NUMBER_8);
        defaultKey("escapeToNexus", KeyCodes.INSERT);
        defaultKey("escapeToNexus2", KeyCodes.F5);
        defaultKey("autofireToggle", KeyCodes.I);
        defaultKey("scrollChatUp", KeyCodes.PAGE_UP);
        defaultKey("scrollChatDown", KeyCodes.PAGE_DOWN);
        defaultKey("miniMapZoomOut", KeyCodes.MINUS);
        defaultKey("miniMapZoomIn", KeyCodes.EQUAL);
        defaultKey("resetToDefaultCameraAngle", KeyCodes.R);
        defaultKey("togglePerformanceStats", KeyCodes.UNSET);
        defaultKey("options", KeyCodes.O);
        defaultKey("toggleCentering", KeyCodes.UNSET);
        defaultKey("chat", KeyCodes.ENTER);
        defaultKey("chatCommand", KeyCodes.SLASH);
        defaultKey("tell", KeyCodes.TAB);
        defaultKey("guildChat", KeyCodes.G);
        defaultKey("partyChat", KeyCodes.P);
        defaultKey("toggleFullscreen", KeyCodes.UNSET);
        defaultKey("switchTabs", KeyCodes.B);
        defaultKey("giveItem", KeyCodes.UNSET);
    }

    private static function initSettings():void {
        defaultSetting("playerObjectType", 782);
        defaultSetting("playMusic", true);
        defaultSetting("playSFX", true);
        defaultSetting("playPewPew", true);
        defaultSetting("centerOnPlayer", true);
        defaultSetting("preferredServer", null);
        defaultSetting("needsTutorial", true);
        defaultSetting("needsNexusTutorial", true);
        defaultSetting("needsRandomRealm", true);
        defaultSetting("cameraAngle", ((7 * Math.PI) / 4));
        defaultSetting("defaultCameraAngle", ((7 * Math.PI) / 4));
        defaultSetting("showQuestPortraits", true);
        defaultSetting("fullscreenMode", true);
        defaultSetting("showProtips", true);
        defaultSetting("protipIndex", 0);
        defaultSetting("joinDate", DateUtil.formatPacificTime());
        defaultSetting("lastDailyAnalytics", null);
        defaultSetting("allowRotation", false);
        defaultSetting("charIdUseMap", {});
        defaultSetting("drawShadows", true);
        defaultSetting("textBubbles", true);
        defaultSetting("showTradePopup", true);
        defaultSetting("paymentMethod", null);
        defaultSetting("filterLanguage", true);
        defaultSetting("showGuildInvitePopup", true);
        defaultSetting("showBeginnersOffer", false);
        defaultSetting("beginnersOfferTimeLeft", 0);
        defaultSetting("beginnersOfferShowNow", false);
        defaultSetting("beginnersOfferShowNowTime", 0);
        defaultSetting("watchForTutorialExit", false);
        defaultSetting("contextualClick", true);
        defaultSetting("inventorySwap", true);
        defaultSetting("hidePlayerChat", false);
        defaultSetting("chatStarRequirement", 1);
        defaultSetting("togglePercentage", false);
        defaultSetting("blureffect", false);
        defaultSetting("toggleBarText", true);
        defaultSetting("clickForGold", false);
        defaultSetting("disableAllyProjectiles", false);
        defaultSetting("disableWeather", false);
        defaultSetting("HideOtherPlayers", false);
        defaultSetting("disableParticles", false);
        defaultSetting("disableDamageText", false);
        defaultSetting("forceLowQuality", false);
        defaultSetting("mscale", 1.0);
        defaultSetting("viewDistance", 1);
        defaultSetting("damageInfo", false);
        //defaultSetting("brightness", 0.5);
        defaultSetting("cursorSelect", 1);
        //defaultSetting("ultraView", false);
        defaultSetting("rotationSpeed", 0.003);
        defaultSetting("GUI_screen", 0);
    }

    private static function initSurvey():void {
        if (!data_.hasOwnProperty("needsSurvey")) {
            data_.needsSurvey = data_.needsTutorial;
            switch (int(Math.random() * 5)) {
                case 0:
                    data_.surveyDate = 0;
                    data_.playTimeLeftTillSurvey = (5 * 60);
                    data_.surveyGroup = "5MinPlaytime";
                    return;
                case 1:
                    data_.surveyDate = 0;
                    data_.playTimeLeftTillSurvey = (10 * 60);
                    data_.surveyGroup = "10MinPlaytime";
                    return;
                case 2:
                    data_.surveyDate = 0;
                    data_.playTimeLeftTillSurvey = (30 * 60);
                    data_.surveyGroup = "30MinPlaytime";
                    return;
                case 3:
                    data_.surveyDate = (new Date().time + ((7 * DAY_MS)));
                    data_.playTimeLeftTillSurvey = (2 * 60);
                    data_.surveyGroup = "1WeekRealtime";
                    return;
                case 4:
                    data_.surveyDate = (new Date().time + ((14 * DAY_MS)));
                    data_.playTimeLeftTillSurvey = (2 * 60);
                    data_.surveyGroup = "2WeekRealtime";
                    return;
            }
        }
    }

    /** Registers a rebindable key action with a default key. */
    private static function defaultKey(action:String, keyCode:uint):void {
        if (!data_.hasOwnProperty(action)) {
            data_[action] = keyCode;
        }
        keyActions_[action] = true;
    }

    private static function defaultSetting(name:String, value:*):void {
        if (!data_.hasOwnProperty(name)) {
            data_[name] = value;
        }
    }

}
}

