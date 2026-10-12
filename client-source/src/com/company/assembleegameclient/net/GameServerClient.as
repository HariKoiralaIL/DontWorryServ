package com.company.assembleegameclient.net {
import account.Account;

import audio.MusicManager;
import audio.SoundEffects;

import client.enums.PositionSlot;
import client.events.ClientUpdateEvent;
import client.events.NameResultEvent;
import client.events.ReconnectEvent;
import client.events.ResultEvent;
import client.signals.DataSignalB;
import client.signals.EmptySignal;
import client.ui.frames.ItemResultBox;
import client.ui.frames.TextInputForm;
import client.ui.panels.GuildInvitePanel;
import client.ui.panels.PartyInvitePanel;
import client.ui.panels.TradeRequestPanel;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.map.GameMap;
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.net.messages.data.*;
import com.company.assembleegameclient.net.messages.incoming.*;
import com.company.assembleegameclient.net.messages.incoming.File;
import com.company.assembleegameclient.net.messages.incoming.Text;
import com.company.assembleegameclient.net.messages.outgoing.*;
import com.company.assembleegameclient.objects.*;
import com.company.assembleegameclient.objects.Container;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.FrameHolder;
import com.company.assembleegameclient.ui._B_N_;
import com.company.assembleegameclient.util.Currency;
import com.company.assembleegameclient.util._wW_;
import com.company.net.NetworkMessage;
import com.company.net.ServerConnection;
import com.company.util.Random;
import com.company.util._L_2;
import com.hurlant.crypto.rsa.RSAKey;
import com.hurlant.util.Base64;
import com.hurlant.util.der.PEM;

import config.InjectorLocator;

import flash.display.BitmapData;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.net.FileReference;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.getTimer;

import game.dialogs.Dialog;
import game.dialogs.NotEnoughFameDialog;
import game.dialogs.NotEnoughGoldDialog;
import game.dialogs.NotEnoughKeysDialog;
import game.signals.DeathSignal;

import mapoverlay.CharacterStatusText;
import mapoverlay.SpeechBalloon;

import particleeffects.*;

import thrownobjects.ThrownObjectSpawner;

/**
 * Game server client: owns the ServerConnection, registers every packet type,
 * sends outgoing packets and handles incoming ones.
 */
public class GameServerClient {

    // ---- Packet ids -------------------------------------------------------
    public static const FAILURE:int = 0;
    public static const CANCELTRADE:int = 1;
    public static const USEPORTAL:int = 3;
    public static const INVRESULT:int = 4;
    public static const JOINGUILD:int = 5;
    public static const PING:int = 6;
    public static const MOVE:int = 7;
    public static const GUILDINVITE:int = 8;
    public static const GLOBAL_NOTIFICATION:int = 9;
    public static const SETCONDITION:int = 10;
    public static const UPDATE_ACK:int = 11;
    public static const TRADEDONE:int = 12;
    public static const SERVER_PLAYER_SHOOT:int = 13;
    public static const GOTOACK:int = 14;
    public static const CREATEGUILD:int = 15;
    public static const PONG:int = 16;
    public static const HELLO:int = 17;
    public static const TRADEACCEPTED:int = 18;
    public static const ENEMY_SHOOT:int = 19;
    public static const NAMERESULT:int = 20;
    public static const REQUESTTRADE:int = 21;
    public static const SHOOTACK:int = 22;
    public static const TRADECHANGED:int = 23;
    public static const PLAYERHIT:int = 24;
    public static const TEXT:int = 25;
    public static const UPDATE:int = 26;
    public static const BUYRESULT:int = 27;
    public static const PIC:int = 28;
    public static const USEITEM:int = 30;
    public static const CREATE_SUCCESS:int = 31;
    public static const CHOOSENAME:int = 33;
    public static const QUESTOBJID:int = 34;
    public static const INVDROP:int = 35;
    public static const CREATE:int = 36;
    public static const CHANGETRADE:int = 37;
    public static const PLAYERSHOOT:int = 38;
    public static const RECONNECT:int = 39;
    public static const CHANGEGUILDRANK:int = 40;
    public static const DEATH:int = 41;
    public static const ESCAPE:int = 42;
    public static const PLAYSOUND:int = 44;
    public static const LOAD:int = 45;
    public static const ACCOUNTLIST:int = 46;
    public static const DAMAGE:int = 47;
    public static const CHECKCREDITS:int = 48;
    public static const TELEPORT:int = 49;
    public static const BUY:int = 50;
    public static const SQUAREHIT:int = 51;
    public static const GOTO:int = 52;
    public static const EDITACCOUNTLIST:int = 53;
    public static const FILE:int = 55;
    public static const SHOW_EFFECT:int = 56;
    public static const ACCEPTTRADE:int = 57;
    public static const CREATE_GUILD_RESULT:int = 58;
    public static const AOEACK:int = 59;
    public static const MAPINFO:int = 60;
    public static const TRADEREQUESTED:int = 61;
    public static const NEW_TICK:int = 62;
    public static const NOTIFICATION:int = 63;
    public static const GROUNDDAMAGE:int = 64;
    public static const INVSWAP:int = 65;
    public static const OTHERHIT:int = 66;
    public static const TRADESTART:int = 67;
    public static const AOE_:int = 68;
    public static const PLAYERTEXT:int = 69;
    public static const ALLYSHOOT:int = 74;
    public static const CLIENTSTAT:int = 75;
    public static const ENEMYHIT:int = 76;
    public static const INVITEDTOGUILD:int = 77;
    public static const GUILDREMOVE:int = 78;
    public static const VISIBULLET:int = 80;
    public static const SWITCHMUSIC:int = 83;
    public static const CRAFT:int = 84;
    public static const INVITEDTOPARTY:int = 85;
    public static const JOINPARTY:int = 86;
    public static const PARTYINVITE:int = 87;
    public static const ITEMSELECTSTART:int = 88;
    public static const ITEMSELECTRESULT:int = 89;
    public static const ITEMRESULT:int = 90;
    public static const GETTEXTINPUT:int = 91;
    public static const TEXTINPUTRESULT:int = 92;
    public static const GIVEITEM:int = 93;
    public static const PLAYERCHEAT:int = 94;
    public static const MARKETTRADE:int = 95;
    public static const MARKETTRADERESULT:int = 96;
    public static const MARKETCREATE:int = 97;

    // ---- Constants --------------------------------------------------------
    // Speech balloon colors: [background, outline, text]
    private static const CHAT_COLORS_DEFAULT:Vector.<uint> = new <uint>[14802908, 0xFFFFFF, 0x545454];
    private static const CHAT_COLORS_ENEMY:Vector.<uint> = new <uint>[5644060, 16549442, 13484223];
    private static const CHAT_COLORS_WHISPER:Vector.<uint> = new <uint>[2493110, 61695, 13880567];
    private static const CHAT_COLORS_GUILD:Vector.<uint> = new <uint>[0x3E8A00, 10944349, 13891532];
    private static const CHAT_COLORS_PARTY:Vector.<uint> = new <uint>[0x5656B7, 0x7474F7, 13880567];

    private static const RC4_OUTGOING_KEY:String = "311f80691451c71b09a13a2a6e";
    private static const RC4_INCOMING_KEY:String = "72c5583cafb6818995cbd74b80";

    private static const HELLO_COPYRIGHT:String = "450d6aefthfasdt45z4asd78b8227atfh37xdff";
    private static const HELLO_HOST:String = "bledixon.com";

    private static const MAX_CONNECT_ATTEMPTS:int = 5;
    private static const MOVE_RECORD_MIN_AGE:int = 125;
    private static const MOVE_RECORD_MAX_COUNT:int = 10;
    private static const MOVE_RECORD_CUTOFF:int = 25;
    private static const CONVERTED_CREDITS_LIMIT:int = 100;

    // ---- State ------------------------------------------------------------
    public var gs_:GameSprite;
    public var server_:Server;
    public var gameId_:int;
    public var isNewCharacter_:Boolean;
    public var charId_:int;
    public var keyTime_:int;
    public var key_:ByteArray;
    public var mapJSON_:String;
    public var lastTickId_:int = -1;
    public var jitterDisplay_:NetJitterDisplay = null;
    public var connection_:ServerConnection = null;
    public var outstandingBuy_:PurchaseTracker = null;

    private var playerObjectId_:int = -1;
    private var shouldReconnect_:Boolean = true;
    private var random_:Random = null;
    private var reconnectTimer_:Timer;
    private var connectAttempts_:int = 1;

    public function GameServerClient(gs:GameSprite, server:Server, gameId:int, isNewCharacter:Boolean, charId:int, keyTime:int, key:ByteArray, mapJSON:String) {
        this.gs_ = gs;
        this.server_ = server;
        this.gameId_ = gameId;
        this.isNewCharacter_ = isNewCharacter;
        this.charId_ = charId;
        this.keyTime_ = keyTime;
        this.key_ = key;
        this.mapJSON_ = mapJSON;
        this.connection_ = new ServerConnection(false);
        this.registerMessages();
        this.connection_.addEventListener(Event.CONNECT, this.onConnect);
        this.connection_.addEventListener(Event.CLOSE, this.onClose);
        this.connection_.addEventListener(ErrorEvent.ERROR, this.onError);
    }

    private function registerMessages():void {
        var c:ServerConnection = this.connection_;
        c.registerMessage(FAILURE, Failure, this.onFailure);
        c.registerMessage(CREATE_SUCCESS, CreateSuccess, this.onCreateSuccess);
        c.registerMessage(CREATE, Create, null);
        c.registerMessage(PLAYERSHOOT, PlayerShoot, null);
        c.registerMessage(MOVE, Move, null);
        c.registerMessage(PLAYERTEXT, PlayerText, null);
        c.registerMessage(TEXT, Text, this.onText);
        c.registerMessage(SERVER_PLAYER_SHOOT, ServerPlayerShoot, this.onServerPlayerShoot);
        c.registerMessage(DAMAGE, Damage, this.onDamage);
        c.registerMessage(UPDATE, Update, this.onUpdate);
        c.registerMessage(UPDATE_ACK, NetworkMessage, null);
        c.registerMessage(NOTIFICATION, Notification, this.onNotification);
        c.registerMessage(GLOBAL_NOTIFICATION, GlobalNotification, this.onGlobalNotification);
        c.registerMessage(NEW_TICK, NewTick, this.onNewTick);
        c.registerMessage(INVSWAP, InvSwap, null);
        c.registerMessage(USEITEM, UseItem, null);
        c.registerMessage(SHOW_EFFECT, ShowEffect, this.onShowEffect);
        c.registerMessage(HELLO, Hello, null);
        c.registerMessage(GOTO, Goto, this.onGoto);
        c.registerMessage(INVDROP, InvDrop, null);
        c.registerMessage(INVRESULT, InvResult, this.onInvResult);
        c.registerMessage(RECONNECT, Reconnect, this.onReconnect);
        c.registerMessage(PING, Ping, this.onPing);
        c.registerMessage(PONG, Pong, null);
        c.registerMessage(MAPINFO, MapInfo, this.onMapInfo);
        c.registerMessage(LOAD, Load, null);
        c.registerMessage(PIC, Pic, this.onPic);
        c.registerMessage(SETCONDITION, SetCondition, null);
        c.registerMessage(TELEPORT, Teleport, null);
        c.registerMessage(USEPORTAL, UsePortal, null);
        c.registerMessage(DEATH, Death, this.onDeath);
        c.registerMessage(BUY, Buy, null);
        c.registerMessage(BUYRESULT, BuyResult, this.onBuyResult);
        c.registerMessage(AOE_, AOE, this.onAoe);
        c.registerMessage(GROUNDDAMAGE, GroundDamage, null);
        c.registerMessage(PLAYERHIT, PlayerHit, null);
        c.registerMessage(ENEMYHIT, EnemyHit, null);
        c.registerMessage(AOEACK, AoeAck, null);
        c.registerMessage(SHOOTACK, ShootAck, null);
        c.registerMessage(OTHERHIT, OtherHit, null);
        c.registerMessage(SQUAREHIT, SquareHit, null);
        c.registerMessage(GOTOACK, GotoAck, null);
        c.registerMessage(EDITACCOUNTLIST, EditAccountList, null);
        c.registerMessage(ACCOUNTLIST, AccountList, this.onAccountList);
        c.registerMessage(QUESTOBJID, QuestObjId, this.onQuestObjId);
        c.registerMessage(CHOOSENAME, ChooseName, null);
        c.registerMessage(NAMERESULT, NameResult, this.onNameResult);
        c.registerMessage(CREATEGUILD, CreateGuild, null);
        c.registerMessage(CREATE_GUILD_RESULT, CreateGuildResult, this.onCreateGuildResult);
        c.registerMessage(GUILDREMOVE, GuildRemove, null);
        c.registerMessage(GUILDINVITE, GuildInvite, null);
        c.registerMessage(ALLYSHOOT, AllyShoot, this.onAllyShoot);
        c.registerMessage(ENEMY_SHOOT, EnemyShoot, this.onEnemyShoot);
        c.registerMessage(REQUESTTRADE, RequestTrade, null);
        c.registerMessage(TRADEREQUESTED, TradeRequested, this.onTradeRequested);
        c.registerMessage(TRADESTART, TradeStart, this.onTradeStart);
        c.registerMessage(CHANGETRADE, ChangeTrade, null);
        c.registerMessage(TRADECHANGED, TradeChanged, this.onTradeChanged);
        c.registerMessage(ACCEPTTRADE, AcceptTrade, null);
        c.registerMessage(CANCELTRADE, CancelTrade, null);
        c.registerMessage(TRADEDONE, TradeDone, this.onTradeDone);
        c.registerMessage(TRADEACCEPTED, TradeAccepted, this.onTradeAccepted);
        c.registerMessage(CLIENTSTAT, ClientStat, this.onClientStat);
        c.registerMessage(CHECKCREDITS, CheckCredits, null);
        c.registerMessage(ESCAPE, Escape, null);
        c.registerMessage(FILE, File, this.onFile);
        c.registerMessage(INVITEDTOGUILD, InvitedToGuild, this.onInvitedToGuild);
        c.registerMessage(JOINGUILD, JoinGuild, null);
        c.registerMessage(CHANGEGUILDRANK, ChangeGuildRank, null);
        c.registerMessage(PLAYSOUND, PlaySound, this.onPlaySound);
        c.registerMessage(CRAFT, Craft, null);
        c.registerMessage(VISIBULLET, Visibullet, null);
        c.registerMessage(SWITCHMUSIC, SwitchMusic, this.onSwitchMusic);
        c.registerMessage(INVITEDTOPARTY, InvitedToParty, this.onInvitedToParty);
        c.registerMessage(JOINPARTY, JoinParty, null);
        c.registerMessage(PARTYINVITE, PartyInvite, null);
        c.registerMessage(ITEMSELECTSTART, ItemSelectStart, this.onItemSelectStart);
        c.registerMessage(ITEMSELECTRESULT, ItemSelectResult, null);
        c.registerMessage(ITEMRESULT, ItemResult, this.onItemResult);
        c.registerMessage(GETTEXTINPUT, GetTextInput, this.onGetTextInput);
        c.registerMessage(TEXTINPUTRESULT, TextInputResult, null);
        c.registerMessage(GIVEITEM, GiveItem, null);
        c.registerMessage(PLAYERCHEAT, PlayerCheat, null);
        c.registerMessage(MARKETTRADE, MarketTrade, null);
        c.registerMessage(MARKETTRADERESULT, MarketTradeResult, this.onMarketTradeResult);
        c.registerMessage(MARKETCREATE, MarketCreate, null);
    }

    // ---- Connection -------------------------------------------------------

    public function connect():void {
        this.gs_.textBox_.addText(Parameters.SendClient, "Connecting to " + this.server_.name_);
        if (Parameters._wZ_) {
            this.connection_.setOutgoingCipher("rc4", _L_2._Z_S_(RC4_OUTGOING_KEY));
            this.connection_.setIncomingCipher("rc4", _L_2._Z_S_(RC4_INCOMING_KEY));
        }
        this.connection_.connect(this.server_.address_, this.server_.port_);
    }

    public function getNextDamage(min:uint, max:uint):uint {
        return this.random_._0M_K_(min, max);
    }

    public function createJitterDisplay():void {
        if (this.jitterDisplay_ == null) {
            this.jitterDisplay_ = new NetJitterDisplay();
        }
    }

    public function destroyJitterDisplay():void {
        this.jitterDisplay_ = null;
    }

    // ---- Outgoing packets -------------------------------------------------

    public function playerShoot(time:int, projectile:Projectile):void {
        var msg:PlayerShoot = this.connection_.acquireMessage(PLAYERSHOOT) as PlayerShoot;
        msg.time_ = time;
        msg.bulletId_ = projectile.bulletId_;
        msg.containerType_ = projectile.containerType_;
        msg.startingPos_.x_ = projectile.x_;
        msg.startingPos_.y_ = projectile.y_;
        msg.angle_ = projectile.angle_;
        this.connection_.sendMessage(msg);
    }

    public function playerCheatCheck():void {
        this.connection_.sendMessage(this.connection_.acquireMessage(PLAYERCHEAT) as PlayerCheat);
    }

    public function playerHit(bulletId:int, objectId:int):void {
        var msg:PlayerHit = this.connection_.acquireMessage(PLAYERHIT) as PlayerHit;
        msg.bulletId_ = bulletId;
        msg.objectId_ = objectId;
        this.connection_.sendMessage(msg);
    }

    public function enemyHit(time:int, bulletId:int, targetId:int, kill:Boolean, damage:int):void {
        var msg:EnemyHit = this.connection_.acquireMessage(ENEMYHIT) as EnemyHit;
        msg.time_ = time;
        msg.bulletId_ = bulletId;
        msg.targetId_ = targetId;
        msg.kill_ = kill;
        msg.dmg_ = damage;
        this.connection_.sendMessage(msg);
    }

    public function otherHit(time:int, bulletId:int, objectId:int, targetId:int):void {
        var msg:OtherHit = this.connection_.acquireMessage(OTHERHIT) as OtherHit;
        msg.time_ = time;
        msg.bulletId_ = bulletId;
        msg.objectId_ = objectId;
        msg.targetId_ = targetId;
        this.connection_.sendMessage(msg);
    }

    public function squareHit(time:int, bulletId:int, objectId:int):void {
        var msg:SquareHit = this.connection_.acquireMessage(SQUAREHIT) as SquareHit;
        msg.time_ = time;
        msg.bulletId_ = bulletId;
        msg.objectId_ = objectId;
        this.connection_.sendMessage(msg);
    }

    public function aoeAck(time:int, x:Number, y:Number):void {
        var msg:AoeAck = this.connection_.acquireMessage(AOEACK) as AoeAck;
        msg.time_ = time;
        msg.position_.x_ = x;
        msg.position_.y_ = y;
        this.connection_.sendMessage(msg);
    }

    public function groundDamage(time:int, x:Number, y:Number):void {
        var msg:GroundDamage = this.connection_.acquireMessage(GROUNDDAMAGE) as GroundDamage;
        msg.time_ = time;
        msg.position_.x_ = x;
        msg.position_.y_ = y;
        this.connection_.sendMessage(msg);
    }

    public function shootAck(time:int):void {
        var msg:ShootAck = this.connection_.acquireMessage(SHOOTACK) as ShootAck;
        msg.time_ = time;
        this.connection_.sendMessage(msg);
    }

    public function playerText(text:String):void {
        var msg:PlayerText = this.connection_.acquireMessage(PLAYERTEXT) as PlayerText;
        msg.text_ = text;
        this.connection_.sendMessage(msg);
    }

    public function invSwap(player:Player, obj1:GameObject, slot1:int, type1:int, obj2:GameObject, slot2:int, type2:int):Boolean {
        if (!this.gs_) {
            return false;
        }
        var msg:InvSwap = this.connection_.acquireMessage(INVSWAP) as InvSwap;
        msg.time_ = this.gs_.lastUpdate_;
        msg.position_.x_ = player.x_;
        msg.position_.y_ = player.y_;
        msg.slotObject1_.objectId_ = obj1.objectId_;
        msg.slotObject1_.slotId_ = slot1;
        msg.slotObject1_.objectType_ = type1;
        msg.slotObject2_.objectId_ = obj2.objectId_;
        msg.slotObject2_.slotId_ = slot2;
        msg.slotObject2_.objectType_ = type2;
        this.connection_.sendMessage(msg);

        // Optimistically swap locally
        var item1:int = obj1.equipment_[slot1];
        var data1:Object = obj1.equipData_[slot1];
        obj1.equipData_[slot1] = obj2.equipData_[slot2];
        obj1.equipment_[slot1] = obj2.equipment_[slot2];
        obj2.equipment_[slot2] = item1;
        obj2.equipData_[slot2] = data1;
        SoundEffects.play("inventory_move_item");
        return true;
    }

    public function invDrop(objectId:int, slotId:int, objectType:int):void {
        var msg:InvDrop = this.connection_.acquireMessage(INVDROP) as InvDrop;
        msg.slotObject_.objectId_ = objectId;
        msg.slotObject_.slotId_ = slotId;
        msg.slotObject_.objectType_ = objectType;
        this.connection_.sendMessage(msg);
    }

    public function useItem(time:int, objectId:int, slotId:int, objectType:int, x:Number, y:Number):void {
        var msg:UseItem = this.connection_.acquireMessage(USEITEM) as UseItem;
        msg.time_ = time;
        msg.slotObject_.objectId_ = objectId;
        msg.slotObject_.slotId_ = slotId;
        msg.slotObject_.objectType_ = objectType;
        msg.itemUsePos_.x_ = x;
        msg.itemUsePos_.y_ = y;
        this.connection_.sendMessage(msg);
    }

    public function setCondition(effect:uint, duration:Number):void {
        var msg:SetCondition = this.connection_.acquireMessage(SETCONDITION) as SetCondition;
        msg.conditionEffect_ = effect;
        msg.conditionDuration_ = duration;
        this.connection_.sendMessage(msg);
    }

    public function move(tickId:int, player:Player):void {
        var x:Number = -1;
        var y:Number = -1;
        if (player != null && !player.isPaused()) {
            x = player.x_;
            y = player.y_;
        }
        var msg:Move = this.connection_.acquireMessage(MOVE) as Move;
        msg.tickId_ = tickId;
        msg.time_ = this.gs_.lastUpdate_;
        msg.newPosition_.x_ = x;
        msg.newPosition_.y_ = y;
        var lastClearTime:int = this.gs_.moveRecords_.lastClearTime_;
        msg.records_.length = 0;
        if (lastClearTime >= 0 && msg.time_ - lastClearTime > MOVE_RECORD_MIN_AGE) {
            var count:int = Math.min(MOVE_RECORD_MAX_COUNT, this.gs_.moveRecords_.records_.length);
            var i:int = 0;
            while (i < count) {
                if (this.gs_.moveRecords_.records_[i].time_ >= msg.time_ - MOVE_RECORD_CUTOFF) {
                    break;
                }
                msg.records_.push(this.gs_.moveRecords_.records_[i]);
                i++;
            }
        }
        this.gs_.moveRecords_.clear(msg.time_);
        this.connection_.sendMessage(msg);
        player._01w();
    }

    public function teleport(objectId:int):void {
        var msg:Teleport = this.connection_.acquireMessage(TELEPORT) as Teleport;
        msg.objectId_ = objectId;
        this.connection_.sendMessage(msg);
    }

    public function usePortal(objectId:int):void {
        var msg:UsePortal = this.connection_.acquireMessage(USEPORTAL) as UsePortal;
        msg.objectId_ = objectId;
        this.connection_.sendMessage(msg);
    }

    public function buy(objectId:int):void {
        if (this.outstandingBuy_ != null) {
            return;
        }
        var item:SellableObject = this.gs_.map_.goDict_[objectId];
        if (item == null) {
            return;
        }
        var converted:Boolean = false;
        if (item.currency_ == Currency._class) {
            var credits:int = this.gs_.map_.player_.credits_;
            converted = this.gs_.charList_.converted_ || credits > CONVERTED_CREDITS_LIMIT || item.price_ > credits;
        }
        this.outstandingBuy_ = new PurchaseTracker(item.soldObjectInternalName(), item.price_, item.currency_, converted);
        var msg:Buy = this.connection_.acquireMessage(BUY) as Buy;
        msg.objectId_ = objectId;
        this.connection_.sendMessage(msg);
    }

    public function gotoAck(time:int):void {
        var msg:GotoAck = this.connection_.acquireMessage(GOTOACK) as GotoAck;
        msg.time_ = time;
        this.connection_.sendMessage(msg);
    }

    public function editAccountList(accountListId:int, add:Boolean, objectId:int):void {
        var msg:EditAccountList = this.connection_.acquireMessage(EDITACCOUNTLIST) as EditAccountList;
        msg.accountListId_ = accountListId;
        msg.add_ = add;
        msg.objectId_ = objectId;
        this.connection_.sendMessage(msg);
    }

    public function chooseName(name:String):void {
        var msg:ChooseName = this.connection_.acquireMessage(CHOOSENAME) as ChooseName;
        msg.name_ = name;
        this.connection_.sendMessage(msg);
    }

    public function createGuild(name:String):void {
        var msg:CreateGuild = this.connection_.acquireMessage(CREATEGUILD) as CreateGuild;
        msg.name_ = name;
        this.connection_.sendMessage(msg);
    }

    public function guildRemove(name:String):void {
        var msg:GuildRemove = this.connection_.acquireMessage(GUILDREMOVE) as GuildRemove;
        msg.name_ = name;
        this.connection_.sendMessage(msg);
    }

    public function guildInvite(name:String):void {
        var msg:GuildInvite = this.connection_.acquireMessage(GUILDINVITE) as GuildInvite;
        msg.name_ = name;
        this.connection_.sendMessage(msg);
    }

    public function partyInvite(name:String):void {
        var msg:PartyInvite = this.connection_.acquireMessage(PARTYINVITE) as PartyInvite;
        msg.name_ = name;
        this.connection_.sendMessage(msg);
    }

    public function requestTrade(name:String):void {
        var msg:RequestTrade = this.connection_.acquireMessage(REQUESTTRADE) as RequestTrade;
        msg.name_ = name;
        this.connection_.sendMessage(msg);
    }

    public function changeTrade(offer:Vector.<Boolean>):void {
        var msg:ChangeTrade = this.connection_.acquireMessage(CHANGETRADE) as ChangeTrade;
        msg.offer_ = offer;
        this.connection_.sendMessage(msg);
    }

    public function acceptTrade(myOffer:Vector.<Boolean>, yourOffer:Vector.<Boolean>):void {
        var msg:AcceptTrade = this.connection_.acquireMessage(ACCEPTTRADE) as AcceptTrade;
        msg.myOffer_ = myOffer;
        msg.yourOffer_ = yourOffer;
        this.connection_.sendMessage(msg);
    }

    public function cancelTrade():void {
        this.connection_.sendMessage(this.connection_.acquireMessage(CANCELTRADE));
    }

    public function selectItem(slot:int):void {
        var msg:ItemSelectResult = this.connection_.acquireMessage(ITEMSELECTRESULT) as ItemSelectResult;
        msg.slot_ = slot;
        this.connection_.sendMessage(msg);
    }

    public function textInputResult(success:Boolean, action:String, input:String):void {
        var msg:TextInputResult = this.connection_.acquireMessage(TEXTINPUTRESULT) as TextInputResult;
        msg.success_ = success;
        msg.action_ = action;
        msg.input_ = input;
        this.connection_.sendMessage(msg);
    }

    public function marketTrade(tradeId:int):void {
        var msg:MarketTrade = this.connection_.acquireMessage(MARKETTRADE) as MarketTrade;
        msg.tradeId_ = tradeId;
        this.connection_.sendMessage(msg);
    }

    public function marketCreate(includedSlots:Vector.<int>, requestItems:Vector.<int>, requestData:Vector.<Object>):void {
        var msg:MarketCreate = this.connection_.acquireMessage(MARKETCREATE) as MarketCreate;
        msg.includedSlots_ = includedSlots;
        msg.requestItems_ = requestItems;
        msg.requestData_ = requestData;
        this.connection_.sendMessage(msg);
    }

    public function giveItem(itemType:int, itemData:Object):void {
        var msg:GiveItem = this.connection_.acquireMessage(GIVEITEM) as GiveItem;
        msg.itemType_ = itemType;
        msg.itemData_ = itemData != null ? itemData : {};
        this.connection_.sendMessage(msg);
    }

    public function checkCredits():void {
        this.connection_.sendMessage(this.connection_.acquireMessage(CHECKCREDITS));
    }

    public function escape():void {
        this.connection_.sendMessage(this.connection_.acquireMessage(ESCAPE));
    }

    public function joinGuild(guildName:String):void {
        var msg:JoinGuild = this.connection_.acquireMessage(JOINGUILD) as JoinGuild;
        msg.guildName_ = guildName;
        this.connection_.sendMessage(msg);
    }

    public function joinParty(partyId:int):void {
        var msg:JoinParty = this.connection_.acquireMessage(JOINPARTY) as JoinParty;
        msg.partyID_ = partyId;
        this.connection_.sendMessage(msg);
    }

    public function changeGuildRank(name:String, guildRank:int):void {
        var msg:ChangeGuildRank = this.connection_.acquireMessage(CHANGEGUILDRANK) as ChangeGuildRank;
        msg.name_ = name;
        msg.guildRank_ = guildRank;
        this.connection_.sendMessage(msg);
    }

    public function craftItems(objectId:int):void {
        var msg:Craft = this.connection_.acquireMessage(CRAFT) as Craft;
        msg.objectId_ = objectId;
        this.connection_.sendMessage(msg);
    }

    public function sendVisibullet(damage:int, enemyId:int, bulletId:int, armorPiercing:Boolean):void {
        var msg:Visibullet = this.connection_.acquireMessage(VISIBULLET) as Visibullet;
        msg.damage_ = damage;
        msg.enemyId_ = enemyId;
        msg.bulletId_ = bulletId;
        msg.armorPiercing_ = armorPiercing;
        this.connection_.sendMessage(msg);
    }

    private function sendCreate():void {
        var msg:Create = this.connection_.acquireMessage(CREATE) as Create;
        msg.objectType_ = Parameters.data_.playerObjectType;
        this.connection_.sendMessage(msg);
    }

    private function sendLoad():void {
        var msg:Load = this.connection_.acquireMessage(LOAD) as Load;
        msg.charId_ = this.charId_;
        this.connection_.sendMessage(msg);
    }

    private function rsaEncrypt(value:String):String {
        var rsa:RSAKey = PEM.readRSAPublicKey(Parameters.RSAKey);
        var plain:ByteArray = new ByteArray();
        plain.writeUTFBytes(value);
        var encrypted:ByteArray = new ByteArray();
        rsa.encrypt(plain, encrypted, plain.length);
        return Base64.encodeByteArray(encrypted);
    }

    // ---- Incoming: connection lifecycle -----------------------------------

    private function onConnect(e:Event):void {
        this.gs_.textBox_.addText(Parameters.SendClient, "Enjoy your Stay!");
        var acc:Account = Account.getInstance();
        var hello:Hello = this.connection_.acquireMessage(HELLO) as Hello;
        hello.copyright_ = HELLO_COPYRIGHT;
        hello._5c2_ = HELLO_HOST;
        hello.buildVersion_ = Parameters.clientVersion;
        hello.gameId_ = this.gameId_;
        hello.guid_ = this.rsaEncrypt(acc.guid());
        hello.password_ = this.rsaEncrypt(acc.password());
        hello.secret_ = this.rsaEncrypt(acc.secret());
        hello.keyTime_ = this.keyTime_;
        hello.key_.length = 0;
        if (this.key_ != null) {
            hello.key_.writeBytes(this.key_);
        }
        hello.mapJSON_ = this.mapJSON_ == null ? "" : this.mapJSON_;
        hello._8U_ = acc.entrytag();
        hello._yt = acc.gameNetwork();
        hello._J_k = acc.gameNetworkUserId();
        hello.playPlatform = acc.playPlatform();
        this.connection_.sendMessage(hello);
    }

    private function onClose(e:Event):void {
        if (this.playerObjectId_ != -1) {
            this.gs_.dispatchEvent(new Event(Event.COMPLETE));
            return;
        }
        if (this.shouldReconnect_) {
            if (this.connectAttempts_ < MAX_CONNECT_ATTEMPTS) {
                this.scheduleReconnect(this.connectAttempts_++);
            } else {
                this.gs_.dispatchEvent(new Event(Event.COMPLETE));
            }
            this.gs_.textBox_.addText(Parameters.SendError, "Connection failed!  Retrying...");
        }
    }

    private function onError(e:ErrorEvent):void {
        this.gs_.textBox_.addText(Parameters.SendError, e.text);
    }

    private function scheduleReconnect(delaySeconds:int):void {
        this.reconnectTimer_ = new Timer(delaySeconds * 1000, 1);
        this.reconnectTimer_.addEventListener(TimerEvent.TIMER_COMPLETE, this.onReconnectTimer);
        this.reconnectTimer_.start();
    }

    private function onReconnectTimer(e:TimerEvent):void {
        this.connect();
    }

    private function onPing(ping:Ping):void {
        var pong:Pong = this.connection_.acquireMessage(PONG) as Pong;
        pong.serial_ = ping.serial_;
        pong.time_ = getTimer();
        this.connection_.sendMessage(pong);
    }

    private function onReconnect(msg:Reconnect):void {
        var hasHost:Boolean = msg.host_ != "";
        var server:Server = new Server(msg.name_, hasHost ? msg.host_ : this.server_.address_, hasHost ? msg.port_ : this.server_.port_);
        this.gs_.dispatchEvent(new ReconnectEvent(server, msg.gameId_, this.isNewCharacter_, this.charId_, msg.keyTime_, msg.key_));
    }

    // ---- Incoming: failure ------------------------------------------------

    private function onFailure(msg:Failure):void {
        switch (msg.errorId_) {
            case Failure.INCORRECT_VERSION:
                this.onIncorrectVersion(msg);
                return;
            case Failure.BAD_KEY:
                this.onBadKey(msg);
                return;
            case Failure.INVALID_TELEPORT_TARGET:
                this.onInvalidTeleportTarget(msg);
                return;
            case Failure.EMAIL_VERIFICATION_NEEDED:
                this.onEmailVerificationNeeded(msg);
                return;
            case Failure.TELEPORT_REALM_BLOCK:
                this.onTeleportRealmBlock(msg);
                return;
            default:
                this.onDefaultFailure(msg);
        }
    }

    private function onTeleportRealmBlock(msg:Failure):void {
        this.shouldReconnect_ = false;
        this.gs_.dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onEmailVerificationNeeded(msg:Failure):void {
        var dialog:Dialog = new Dialog("Guest accounts have been disabled for improved security.", "Anti-Guest Guard", "Ok", null, "/noGuests");
        dialog.addEventListener(Dialog.BUTTON1_EVENT, this.onDialogClosed);
        this.gs_.stage.addChild(dialog);
        this.shouldReconnect_ = false;
    }

    private function onInvalidTeleportTarget(msg:Failure):void {
        this.gs_.textBox_.addText(Parameters.SendError, msg.errorDescription_);
        this.gs_.map_.player_.nextTeleportAt_ = 0;
    }

    private function onBadKey(msg:Failure):void {
        this.gs_.textBox_.addText(Parameters.SendError, msg.errorDescription_);
        this.shouldReconnect_ = false;
        this.gs_.dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onIncorrectVersion(msg:Failure):void {
        var text:String = "Client version: " + Parameters.clientVersion
                + "\nServer version: " + msg.errorDescription_
                + "\n\nPlease use one of these links to play: "
                + '<font color="#7777EE"> <a href="http://bledixon.com/client/WebMain.swf">'
                + "          Client #1 </a></font>"
                + '<font color="#7777EE"> <a href="http://bledixon.com/xclient/WebMain.swf">'
                + "          Client #2</a></font>";
        var dialog:Dialog = new Dialog(text, "Client Update Needed", "Ok", null, "/clientUpdate");
        dialog.addEventListener(Dialog.BUTTON1_EVENT, this.onDialogClosed);
        this.gs_.stage.addChild(dialog);
        this.shouldReconnect_ = false;
    }

    private function onDefaultFailure(msg:Failure):void {
        this.gs_.textBox_.addText(Parameters.SendError, msg.errorDescription_);
    }

    private function onDialogClosed(e:Event):void {
        var dialog:Dialog = e.currentTarget as Dialog;
        dialog.parent.removeChild(dialog);
        this.gs_.dispatchEvent(new ClientUpdateEvent());
    }

    // ---- Incoming: map / objects ------------------------------------------

    private function onMapInfo(msg:MapInfo):void {
        var xml:String;
        for each (xml in msg.clientXML_) {
            this.loadXmlData(xml);
        }
        for each (xml in msg.extraXML_) {
            this.loadXmlData(xml);
        }
        this.gs_.applyMapInfo(msg);
        this.random_ = new Random(msg.fp_);
        if (this.isNewCharacter_) {
            this.sendCreate();
        } else {
            this.sendLoad();
        }
    }

    private function loadXmlData(xmlString:String):void {
        var xml:XML = XML(xmlString);
        GroundLibrary.parseFromXML(xml);
        ObjectLibrary._nY_(xml);
    }

    private function onCreateSuccess(msg:CreateSuccess):void {
        this.playerObjectId_ = msg.objectId_;
        this.charId_ = msg.charId_;
        this.gs_.initialize();
        this.isNewCharacter_ = false;
    }

    private function onUpdate(msg:Update):void {
        this.connection_.sendMessage(this.connection_.acquireMessage(UPDATE_ACK));
        var i:int = 0;
        while (i < msg.tiles_.length) {
            var tile:GroundTileData = msg.tiles_[i];
            this.gs_.map_.setGroundTile(tile.x_, tile.y_, tile.type_);
            this.gs_.hudView_._F_.setGroundTile(tile.x_, tile.y_, tile.type_);
            i++;
        }
        i = 0;
        while (i < msg.newObjs_.length) {
            this.addObject(msg.newObjs_[i]);
            i++;
        }
        i = 0;
        while (i < msg.drops_.length) {
            this.gs_.map_.removeObj(msg.drops_[i]);
            i++;
        }
    }

    private function addObject(objData:ObjectData):void {
        var map:GameMap = this.gs_.map_;
        var obj:GameObject = ObjectLibrary._075(objData.objectType_);
        if (obj == null) {
            return;
        }
        var status:ObjectStatusData = objData.status_;
        obj.setObjectId(status.objectId_);
        map.addObj(obj, status.pos_.x_, status.pos_.y_);
        if (obj.objectId_ == this.playerObjectId_) {
            map.player_ = obj as Player;
        }
        this.processObjectStatus(status, 0, -1);
        if (obj.props_.static_ && obj.props_.occupySquare_ && !obj.props_._ia) {
            this.gs_.hudView_._F_._0A_R_(obj.x_, obj.y_, obj);
        }
    }

    private function onNewTick(msg:NewTick):void {
        if (this.jitterDisplay_ != null) {
            this.jitterDisplay_.onTick();
        }
        this.move(msg.tickId_, this.gs_.map_.player_);
        for each (var status:ObjectStatusData in msg.statuses_) {
            this.processObjectStatus(status, msg.tickTime_, msg.tickId_);
        }
        this.lastTickId_ = msg.tickId_;
    }

    private function processObjectStatus(status:ObjectStatusData, tickTime:int, tickId:int):void {
        var map:GameMap = this.gs_.map_;
        var obj:GameObject = map.goDict_[status.objectId_];
        if (obj == null) {
            return;
        }
        var isSelf:Boolean = status.objectId_ == this.playerObjectId_;
        if (tickTime != 0 && !isSelf) {
            obj._0I_u(status.pos_.x_, status.pos_.y_, tickTime, tickId);
        }
        var player:Player = obj as Player;
        var prevLevel:int;
        var prevExp:int;
        if (player != null) {
            prevLevel = player.level_;
            prevExp = player.exp_;
        }
        this.applyStats(obj, status.stats_, isSelf);
        if (player != null && prevLevel != -1) {
            if (player.level_ > prevLevel) {
                if (isSelf) {
                    var unlocked:Array = this.gs_.charList_.classesUnlockedBy(player.objectType_, player.level_);
                    player._ut(unlocked.length != 0);
                } else {
                    player._x1("Level Up!");
                }
            } else if (player.exp_ > prevExp) {
                player._0I_I_(player.exp_ - prevExp);
            }
        }
    }

    private function applyStats(obj:GameObject, stats:Vector.<StatData>, isSelf:Boolean):void {
        var player:Player = obj as Player;
        var merchant:Merchant = obj as Merchant;
        var sellable:SellableObject = obj as SellableObject;
        for each (var stat:StatData in stats) {
            var value:int = stat.statValue_;
            switch (stat.statType_) {
                case StatData.MAX_HP_STAT:
                    obj.maxHP_ = value;
                    break;
                case StatData.HP_STAT:
                    obj.HP_ = value;
                    break;
                case StatData.SIZE_STAT:
                    obj.size_ = value;
                    break;
                case StatData.MAX_MP_STAT:
                    player.maxMP_ = value;
                    break;
                case StatData.MP_STAT:
                    player.MP_ = value;
                    break;
                case StatData.NEXT_LEVEL_EXP_STAT:
                    player._7V_ = value;
                    break;
                case StatData.EXP_STAT:
                    player.exp_ = value;
                    break;
                case StatData.LEVEL_STAT:
                    obj.level_ = value;
                    break;
                case StatData.ATTACK_STAT:
                    player.attack_ = value;
                    break;
                case StatData.DEFENSE_STAT:
                    obj.defense_ = value;
                    break;
                case StatData.SPEED_STAT:
                    player.speed_ = value;
                    break;
                case StatData.DEXTERITY_STAT:
                    player.dexterity_ = value;
                    break;
                case StatData.VITALITY_STAT:
                    player.vitality_ = value;
                    break;
                case StatData.WISDOM_STAT:
                    player.wisdom_ = value;
                    break;
                case StatData._luckData:
                    player.luck_ = value;
                    break;
                case StatData._critData:
                    player.crit_ = value;
                    break;
                case StatData.CONDITION_STAT:
                    obj._9B_ = value;
                    break;
                case StatData.INVDATA_0_STAT:
                case StatData.INVDATA_1_STAT:
                case StatData.INVDATA_2_STAT:
                case StatData.INVDATA_3_STAT:
                case StatData.INVDATA_4_STAT:
                case StatData.INVDATA_5_STAT:
                case StatData.INVDATA_6_STAT:
                case StatData.INVDATA_7_STAT:
                case StatData.INVDATA_8_STAT:
                case StatData.INVDATA_9_STAT:
                case StatData.INVDATA_10_STAT:
                case StatData.INVDATA_11_STAT:
                    obj.equipData_[stat.statType_ - StatData.INVDATA_0_STAT] = JSON.parse(stat.strStatValue_);
                    break;
                case StatData.INVENTORY_0_STAT:
                case StatData.INVENTORY_1_STAT:
                case StatData.INVENTORY_2_STAT:
                case StatData.INVENTORY_3_STAT:
                case StatData.INVENTORY_4_STAT:
                case StatData.INVENTORY_5_STAT:
                case StatData.INVENTORY_6_STAT:
                case StatData.INVENTORY_7_STAT:
                case StatData.INVENTORY_8_STAT:
                case StatData.INVENTORY_9_STAT:
                case StatData.INVENTORY_10_STAT:
                case StatData.INVENTORY_11_STAT:
                    obj.equipment_[stat.statType_ - StatData.INVENTORY_0_STAT] = value;
                    break;
                case StatData.NUM_STARS_STAT:
                    player.numStars_ = value;
                    break;
                case StatData.NAME_STAT:
                    if (obj.name_ != stat.strStatValue_) {
                        obj.name_ = stat.strStatValue_;
                        obj._U_g = null;
                    }
                    break;
                case StatData.TEX1_STAT:
                    obj.setTex1(value);
                    break;
                case StatData.TEX2_STAT:
                    obj.setTex2(value);
                    break;
                case StatData.MERCHANDISE_TYPE_STAT:
                    merchant.setMerchandiseType(value);
                    break;
                case StatData.CREDITS_STAT:
                    player._F_S_(value);
                    break;
                case StatData.MERCHANDISE_PRICE_STAT:
                    sellable.setPrice(value);
                    break;
                case StatData.ACTIVE_STAT:
                    (obj as Portal)._09S_ = value != 0;
                    break;
                case StatData.ACCOUNT_ID_STAT:
                    player.accountId_ = value;
                    break;
                case StatData.FAME_STAT:
                    player.fame_ = value;
                    break;
                case StatData.MERCHANDISE_CURRENCY_STAT:
                    sellable._gF_(value);
                    break;
                case StatData.CONNECT_STAT:
                    obj._O_l = value;
                    break;
                case StatData.MERCHANDISE_COUNT_STAT:
                    merchant._1I_ = value;
                    merchant._z5 = 0;
                    break;
                case StatData.MERCHANDISE_MINS_LEFT_STAT:
                    merchant._gt = value;
                    merchant._z5 = 0;
                    break;
                case StatData.MERCHANDISE_DISCOUNT_STAT:
                    merchant._S_I_ = value;
                    merchant._z5 = 0;
                    break;
                case StatData.MERCHANDISE_RANK_REQ_STAT:
                    sellable.setRankReq(value);
                    break;
                case StatData.MAX_HP_BOOST_STAT:
                    player._P_7 = value;
                    break;
                case StatData.MAX_MP_BOOST_STAT:
                    player._0D_G_ = value;
                    break;
                case StatData.ATTACK_BOOST_STAT:
                    player._05s = value;
                    break;
                case StatData.DEFENSE_BOOST_STAT:
                    player._07f = value;
                    break;
                case StatData._luckBonus:
                    player.stat_luck = value;
                    break;
                case StatData._critBonus:
                    player.stat_crit = value;
                    break;
                case StatData.SPEED_BOOST_STAT:
                    player._065 = value;
                    break;
                case StatData.VITALITY_BOOST_STAT:
                    player._pP_ = value;
                    break;
                case StatData.WISDOM_BOOST_STAT:
                    player._B_e = value;
                    break;
                case StatData.DEXTERITY_BOOST_STAT:
                    player._cu = value;
                    break;
                case StatData.OWNER_ACCOUNT_ID_STAT:
                    (obj as Container)._75(value);
                    break;
                case StatData.RANK_REQUIRED_STAT:
                    (obj as NameChanger)._Y__(value);
                    break;
                case StatData.NAME_CHOSEN_STAT:
                    player._hv = value != 0;
                    obj._U_g = null;
                    break;
                case StatData.CURR_FAME_STAT:
                    player._0L_o = value;
                    break;
                case StatData.NEXT_CLASS_QUEST_FAME_STAT:
                    player._n8 = value;
                    break;
                case StatData.LEGENDARY_RANK_STAT:
                    player._2v = value;
                    break;
                case StatData.SINK_LEVEL_STAT:
                    if (!isSelf) {
                        player._0F_ = value;
                    }
                    break;
                case StatData.ALT_TEXTURE_STAT:
                    obj._5w(value);
                    break;
                case StatData.GUILD_NAME_STAT:
                    player._Y_C_(stat.strStatValue_);
                    break;
                case StatData.GUILD_RANK_STAT:
                    player.guildRank_ = value;
                    break;
                case StatData.BREATH_STAT:
                    player._R_4 = value;
                    break;
                case StatData.XP_BOOSTED_STAT:
                    player._gz = value;
                    break;
                case StatData.SKIN_STAT:
                    obj.setSkin(value);
                    break;
                case StatData.PVP_STAT:
                    obj.pvp_ = value != 0;
                    break;
                case StatData.TEAM_STAT:
                    obj.team_ = value;
                    break;
                case StatData.KEYS:
                    player.setKeys(value);
                    break;
                case StatData.CANNEXUS:
                    player.canNexus = value != 0;
                    break;
                case StatData.PARTY_STAT:
                    player.UpdateParty(value);
                    break;
                case StatData.PARTY_LEADER_STAT:
                    player.partyLeader = value != 0;
                    break;
                case StatData.EFFECT_STAT:
                    player.setEffect(stat.strStatValue_);
            }
        }
    }

    private function onGoto(msg:Goto):void {
        this.gotoAck(this.gs_.lastUpdate_);
        var obj:GameObject = this.gs_.map_.goDict_[msg.objectId_];
        if (obj == null) {
            return;
        }
        obj._gk(msg.pos_.x_, msg.pos_.y_, this.gs_.lastUpdate_);
    }

    private function onQuestObjId(msg:QuestObjId):void {
        this.gs_.map_.quest_.setObject(msg.objectId_);
    }

    private function onPic(msg:Pic):void {
        this.gs_.addChild(new _B_N_(msg.bitmapData_));
    }

    private function onPlaySound(msg:PlaySound):void {
        var obj:GameObject = this.gs_.map_.goDict_[msg.ownerId_];
        if (obj == null) {
            return;
        }
        obj._05M_(msg.soundId_);
    }

    private function onSwitchMusic(msg:SwitchMusic):void {
        MusicManager.reload(msg.music_);
    }

    private function onFile(msg:File):void {
        new FileReference().save(msg.file_, msg.filename_);
    }

    private function onClientStat(msg:ClientStat):void {
        Account.getInstance().reportIntStat(msg.name_, msg.value_);
    }

    // ---- Incoming: combat -------------------------------------------------

    private function onDamage(msg:Damage):void {
        var map:GameMap = this.gs_.map_;
        var projectile:Projectile;
        if (msg.objectId_ >= 0 && msg.bulletId_ > 0) {
            var projectileKey:int = Projectile._61(msg.objectId_, msg.bulletId_);
            projectile = map.boDict_[projectileKey] as Projectile;
            if (projectile != null && !projectile._ko._0C_c) {
                map.removeObj(projectileKey);
            }
        }
        var target:GameObject = map.goDict_[msg.targetId_];
        if (target != null) {
            target.damage(-1, msg.damageAmount_, msg.effects_, msg.kill_, projectile);
        }
    }

    private function onServerPlayerShoot(msg:ServerPlayerShoot):void {
        var isOwn:Boolean = msg.ownerId_ == this.playerObjectId_;
        var owner:GameObject = this.gs_.map_.goDict_[msg.ownerId_];
        if (owner == null || owner._aE_) {
            if (isOwn) {
                this.shootAck(-1);
            }
            return;
        }
        var projectile:Projectile = _wW_._B_1(Projectile) as Projectile;
        projectile.reset(msg.containerType_, 0, msg.ownerId_, msg.bulletId_, msg.angle_, this.gs_.lastUpdate_);
        projectile._T_j(msg.damage_);
        this.gs_.map_.addObj(projectile, msg.startingPos_.x_, msg.startingPos_.y_);
        if (isOwn) {
            this.shootAck(this.gs_.lastUpdate_);
        }
    }

    private function onAllyShoot(msg:AllyShoot):void {
        var owner:GameObject = this.gs_.map_.goDict_[msg.ownerId_];
        if (owner == null || owner._aE_ || Parameters.data_.disableAllyProjectiles) {
            return;
        }
        var projectile:Projectile = _wW_._B_1(Projectile) as Projectile;
        projectile.reset(msg.containerType_, 0, msg.ownerId_, msg.bulletId_, msg.angle_, this.gs_.lastUpdate_);
        projectile._T_j(msg.dmg_);
        this.gs_.map_.addObj(projectile, owner.x_, owner.y_);
        owner.setAttack(msg.containerType_, msg.angle_);
    }

    private function onEnemyShoot(msg:EnemyShoot):void {
        var owner:GameObject = this.gs_.map_.goDict_[msg.ownerId_];
        if (owner == null || owner._aE_) {
            this.shootAck(-1);
            return;
        }
        var i:int = 0;
        while (i < msg.numShots_) {
            var projectile:Projectile = _wW_._B_1(Projectile) as Projectile;
            var angle:Number = msg.angle_ + msg.angleInc_ * i;
            projectile.reset(owner.objectType_, msg.bulletType_, msg.ownerId_, (msg.bulletId_ + i) % 0x0100, angle, this.gs_.lastUpdate_);
            projectile._T_j(msg.damage_);
            this.gs_.map_.addObj(projectile, msg.startingPos_.x_, msg.startingPos_.y_);
            i++;
        }
        this.shootAck(this.gs_.lastUpdate_);
        owner.setAttack(owner.objectType_, msg.angle_ + msg.angleInc_ * ((msg.numShots_ - 1) / 2));
    }

    private function onAoe(msg:AOE):void {
        var player:Player = this.gs_.map_.player_;
        if (player == null) {
            this.aoeAck(this.gs_.lastUpdate_, 0, 0);
            return;
        }
        var effect:AoeEffect = new AoeEffect(msg.pos_.toPoint(), msg.radius_, 0xFF0000);
        this.gs_.map_.addObj(effect, msg.pos_.x_, msg.pos_.y_);
        if (player._0C_4() || player.isPaused()) {
            this.aoeAck(this.gs_.lastUpdate_, player.x_, player.y_);
            return;
        }
        if (player._F_Y_(msg.pos_) < msg.radius_) {
            var damage:int = GameObject._C_f(msg.damage_, player.defense_, false, player._9B_);
            var effects:Vector.<uint> = null;
            if (msg.effect_ != 0) {
                effects = new Vector.<uint>();
                effects.push(msg.effect_);
            }
            player.damage(msg.origType_, damage, effects, false, null);
        }
        this.aoeAck(this.gs_.lastUpdate_, player.x_, player.y_);
    }

    private function onDeath(msg:Death):void {
        MusicManager.reload("Death");
        var snapshot:BitmapData = new BitmapData(800, 600);
        snapshot.draw(this.gs_);
        msg.background = snapshot;
        if (this.gs_.isEditor) {
            return;
        }
        InjectorLocator.getInjector().getInstance(DeathSignal).dispatch(msg);
    }

    private function onShowEffect(msg:ShowEffect):void {
        var map:GameMap = this.gs_.map_;
        var target:GameObject;
        var effect:ParticleEffect;
        var start:Point;
        switch (msg.effectType_) {
            case ShowEffect.HEAL_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                map.addObj(new AuraEffect(target, msg.color_), target.x_, target.y_);
                return;
            case ShowEffect.TELEPORT_EFFECT:
                map.addObj(new TeleportEffect(), msg.pos1_.x_, msg.pos1_.y_);
                return;
            case ShowEffect.STREAM_EFFECT:
                effect = new StreamEffect(msg.pos1_, msg.pos2_, msg.color_);
                map.addObj(effect, msg.pos1_.x_, msg.pos1_.y_);
                return;
            case ShowEffect.THROW_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                start = target != null ? new Point(target.x_, target.y_) : msg.pos2_.toPoint();
                effect = new ThrowEffect(start, msg.pos1_.toPoint(), msg.color_);
                map.addObj(effect, start.x, start.y);
                return;
            case ShowEffect.NOVA_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                effect = new NovaEffect(target, msg.pos1_.x_, msg.color_);
                map.addObj(effect, target.x_, target.y_);
                return;
            case ShowEffect.POISON_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                effect = new SparkEffect(target, msg.color_);
                map.addObj(effect, target.x_, target.y_);
                return;
            case ShowEffect.LINE_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                effect = new LineEffect(target, msg.pos1_, msg.color_);
                map.addObj(effect, msg.pos1_.x_, msg.pos1_.y_);
                return;
            case ShowEffect.BURST_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                effect = new BurstEffect(target, msg.pos1_, msg.pos2_, msg.color_);
                map.addObj(effect, msg.pos1_.x_, msg.pos1_.y_);
                return;
            case ShowEffect.FLOW_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                effect = new FlowEffect(msg.pos1_, target, msg.color_);
                map.addObj(effect, msg.pos1_.x_, msg.pos1_.y_);
                return;
            case ShowEffect.RING_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                effect = new RingEffect(target, msg.pos1_.x_, msg.color_);
                map.addObj(effect, target.x_, target.y_);
                return;
            case ShowEffect.LIGHTNING_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                effect = new LightningEffect(target, msg.pos1_, msg.color_, msg.pos2_.x_);
                map.addObj(effect, target.x_, target.y_);
                return;
            case ShowEffect.COLLAPSE_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                effect = new CollapseEffect(target, msg.pos1_, msg.pos2_, msg.color_);
                map.addObj(effect, msg.pos1_.x_, msg.pos1_.y_);
                return;
            case ShowEffect.CONEBLAST_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                effect = new ConeBlastEffect(target, msg.pos1_, msg.pos2_.x_, msg.color_);
                map.addObj(effect, target.x_, target.y_);
                return;
            case ShowEffect.JITTER_EFFECT:
                this.gs_.camera_.startShake();
                return;
            case ShowEffect.FLASH_EFFECT:
                target = map.goDict_[msg.targetObjectId_];
                if (target == null) return;
                target._B_t = new _T_f(getTimer(), msg.color_, msg.pos1_.x_, msg.pos1_.y_);
                return;
            case ShowEffect.THROW_PROJECTILE_EFFECT:
                start = msg.pos1_.toPoint();
                effect = new ThrownObjectSpawner(msg.pos2_.toPoint(), msg.pos1_.toPoint());
                map.addObj(effect, start.x, start.y);
                return;
        }
    }

    // ---- Incoming: chat / notifications -----------------------------------

    private function onText(msg:Text):void {
        var player:Player = this.gs_.map_.player_;
        var text:String = msg.text_;
        var isServerMessage:Boolean = msg.numStars_ == -1 || msg.objectId_ == -1;
        if (msg.numStars_ < Parameters.data_.chatStarRequirement
                && !this.isOwnName(msg.name_, player)
                && !isServerMessage
                && !this.hasSpecialPrefix(msg.recipient_)
                && msg.name_.charAt(0) != "@") {
            return;
        }
        if (msg.cleanText_.length > 0 && msg.objectId_ != this.playerObjectId_ && Parameters.data_.filterLanguage) {
            text = msg.cleanText_;
        }
        if (msg.objectId_ >= 0) {
            var speaker:GameObject = this.gs_.map_.goDict_[msg.objectId_];
            if (speaker != null) {
                var colors:Vector.<uint> = CHAT_COLORS_DEFAULT;
                if (speaker.props_.isEnemy_) {
                    colors = CHAT_COLORS_ENEMY;
                } else if (msg.recipient_ == Parameters.SendGuild) {
                    colors = CHAT_COLORS_GUILD;
                } else if (msg.recipient_ == Parameters.SendParty) {
                    colors = CHAT_COLORS_PARTY;
                } else if (msg.recipient_ != "") {
                    colors = CHAT_COLORS_WHISPER;
                }
                this.gs_.map_.mapOverlay_.addSpeechBalloon(new SpeechBalloon(speaker, text, colors[0], 1, colors[1], 1, colors[2], msg.bubbleTime_, false, true));
            }
        }
        if (text || !Parameters.data_.hidePlayerChat || this.hasSpecialPrefix(msg.name_)) {
            this.gs_.textBox_._ro(msg.name_, msg.objectId_, msg.numStars_, msg.recipient_, text);
        }
    }

    private function isOwnName(name:String, player:Player):Boolean {
        return name == player.name_;
    }

    /** True for names/recipients starting with a special channel marker (* # @ !). */
    private function hasSpecialPrefix(value:String):Boolean {
        if (value.length == 0) {
            return false;
        }
        var first:String = value.charAt(0);
        return first == "*" || first == "#" || first == "@" || first == "!";
    }

    private function onNotification(msg:Notification):void {
        var obj:GameObject = this.gs_.map_.goDict_[msg.objectId_];
        if (obj == null) {
            return;
        }
        this.gs_.map_.mapOverlay_.addChild(new CharacterStatusText(obj, msg.text_, msg.color_, 2000));
        if (obj == this.gs_.map_.player_ && msg.text_ == "Quest Complete!") {
            this.gs_.map_.quest_.completed();
        }
    }

    private function onGlobalNotification(msg:GlobalNotification):void {
        switch (msg.text) {
            case "yellow":
                DataSignalB.instance.dispatch(PositionSlot.SLOT_3);
                return;
            case "red":
                DataSignalB.instance.dispatch(PositionSlot.SLOT_2);
                return;
            case "green":
                DataSignalB.instance.dispatch(PositionSlot.SLOT_1);
                return;
            case "purple":
                DataSignalB.instance.dispatch(PositionSlot.SLOT_0);
                return;
            case "showKeyUI":
                EmptySignal.instance.dispatch();
                return;
            case "beginnersPackage":
                return;
        }
    }

    // ---- Incoming: inventory / shop ---------------------------------------

    private function onInvResult(msg:InvResult):void {
        if (msg.result_ != 0) {
            this.resetInventoryUI();
        }
    }

    private function resetInventoryUI():void {
        SoundEffects.play("error");
        this.gs_.hudView_._02y._e9.refresh();
        this.gs_.hudView_._02y.equips_.refresh();
        this.gs_.hudView_._U_T_.redraw();
    }

    private function onBuyResult(msg:BuyResult):void {
        if (msg.result_ == BuyResult.RESULT_0 && this.outstandingBuy_ != null) {
            this.outstandingBuy_.track();
        }
        this.outstandingBuy_ = null;
        switch (msg.result_) {
            case BuyResult.RESULT_3:
                this.gs_.stage.addChild(new NotEnoughGoldDialog());
                return;
            case BuyResult.RESULT_6:
                this.gs_.stage.addChild(new NotEnoughFameDialog());
                return;
            case BuyResult.RESULT_9:
                this.gs_.stage.addChild(new NotEnoughKeysDialog());
                return;
            default:
                this.gs_.textBox_.addText(msg.result_ == BuyResult.RESULT_0 ? Parameters.SendInfo : Parameters.SendError, msg.resultString_);
        }
    }

    private function onItemSelectStart(msg:ItemSelectStart):void {
        this.gs_.hudView_.selectItem(msg);
    }

    private function onItemResult(msg:ItemResult):void {
        var box:ItemResultBox = new ItemResultBox(this.gs_, msg.item_, "acquired", JSON.parse(msg.data_));
        this.gs_.stage.addChild(new FrameHolder(box));
    }

    private function onGetTextInput(msg:GetTextInput):void {
        var form:TextInputForm = new TextInputForm(this.gs_, msg.name_, msg.action_);
        this.gs_.stage.addChild(new FrameHolder(form));
    }

    private function onMarketTradeResult(msg:MarketTradeResult):void {
        if (msg.errorText_ != "") {
            this.gs_.textBox_.addText(msg.success_ ? "" : Parameters.SendError, msg.errorText_);
        }
        this.gs_.dispatchEvent(new ResultEvent(msg.success_, msg.errorText_, ResultEvent.MARKET_RESULT));
    }

    // ---- Incoming: trade --------------------------------------------------

    private function onTradeRequested(msg:TradeRequested):void {
        if (Parameters.data_.showTradePopup) {
            this.gs_.hudView_._U_T_.setOverridePanel(new TradeRequestPanel(this.gs_, msg.name_));
        }
        this.gs_.textBox_.addText("", msg.name_ + " wants to trade with you.  Type \"/trade " + msg.name_ + "\" to trade.");
    }

    private function onTradeStart(msg:TradeStart):void {
        this.gs_.hudView_._0L_v(msg);
    }

    private function onTradeChanged(msg:TradeChanged):void {
        this.gs_.hudView_._ss(msg);
    }

    private function onTradeDone(msg:TradeDone):void {
        this.gs_.hudView_._A_a();
        this.gs_.textBox_.addText("", msg.description_);
    }

    private function onTradeAccepted(msg:TradeAccepted):void {
        this.gs_.hudView_._mH_(msg);
    }

    // ---- Incoming: social -------------------------------------------------

    private function onAccountList(msg:AccountList):void {
        if (msg.accountListId_ == 0) {
            this.gs_.map_.party_.setStars(msg);
        }
        if (msg.accountListId_ == 1) {
            this.gs_.map_.party_.setIgnores(msg);
        }
    }

    private function onNameResult(msg:NameResult):void {
        this.gs_.dispatchEvent(new NameResultEvent(msg));
    }

    private function onCreateGuildResult(msg:CreateGuildResult):void {
        if (msg.errorText_ != "") {
            this.gs_.textBox_.addText(Parameters.SendError, msg.errorText_);
        }
        this.gs_.dispatchEvent(new ResultEvent(msg.success_, msg.errorText_));
    }

    private function onInvitedToGuild(msg:InvitedToGuild):void {
        if (Parameters.data_.showGuildInvitePopup) {
            this.gs_.hudView_._U_T_.setOverridePanel(new GuildInvitePanel(this.gs_, msg.name_, msg.guildName_));
        }
        this.gs_.textBox_.addText("", "You have been invited by " + msg.name_ + " to join the guild " + msg.guildName_
                + '.\n  If you wish to join type "/join ' + msg.guildName_ + '"');
    }

    private function onInvitedToParty(msg:InvitedToParty):void {
        if (Parameters.data_.showGuildInvitePopup) {
            this.gs_.hudView_._U_T_.setOverridePanel(new PartyInvitePanel(this.gs_, msg.name_, msg.partyID_));
        }
        this.gs_.textBox_.addText("", "You have been invited by " + msg.name_ + " to join a party.\nIf you wish to join, type \"/party join " + msg.name_ + "\"");
    }

}
}
