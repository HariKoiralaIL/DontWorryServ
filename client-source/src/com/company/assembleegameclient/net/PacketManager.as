// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.net.PacketManager

package com.company.assembleegameclient.net {
  import com.company.assembleegameclient.net.messages.incoming.*;
  import com.company.assembleegameclient.net.messages.incoming.AOE;
  import com.company.assembleegameclient.net.messages.incoming.BuyResult;
  import com.company.assembleegameclient.net.messages.incoming.Damage;
  import com.company.assembleegameclient.net.messages.incoming.Death;
  import com.company.assembleegameclient.net.messages.incoming.File;
  import com.company.assembleegameclient.net.messages.incoming.Goto;
  import com.company.assembleegameclient.net.messages.incoming.InvResult;
  import com.company.assembleegameclient.net.messages.incoming.InvitedToGuild;
  import com.company.assembleegameclient.net.messages.incoming.MapInfo;
  import com.company.assembleegameclient.net.messages.incoming.NameResult;
  import com.company.assembleegameclient.net.messages.incoming.Notification;
  import com.company.assembleegameclient.net.messages.incoming.Pic;
  import com.company.assembleegameclient.net.messages.incoming.ShowEffect;
  import com.company.assembleegameclient.net.messages.incoming.Text;
  import com.company.assembleegameclient.net.messages.incoming.Update;
  import com.company.assembleegameclient.net.messages.incoming.Ping;
  import com.company.assembleegameclient.net.messages.incoming.ClientStat;
  import com.company.assembleegameclient.net.messages.incoming.AccountList;
  import com.company.assembleegameclient.net.messages.incoming.NewTick;
  import com.company.assembleegameclient.net.messages.incoming.Reconnect;
  import com.company.assembleegameclient.net.messages.incoming.TradeDone;
  import com.company.assembleegameclient.net.messages.incoming.EnemyShoot;
  import com.company.assembleegameclient.net.messages.incoming.Failure;
  import com.company.assembleegameclient.net.messages.incoming.AllyShoot;
  import com.company.assembleegameclient.net.messages.incoming.TradeStart;
  import com.company.assembleegameclient.net.messages.incoming.ServerPlayerShoot;
  import com.company.assembleegameclient.net.messages.incoming.CreateSuccess;
  import com.company.assembleegameclient.net.messages.incoming.QuestObjId;
  import com.company.assembleegameclient.net.messages.incoming.TradeRequested;
  import com.company.assembleegameclient.net.messages.incoming.TradeChanged;
  import com.company.assembleegameclient.net.messages.incoming.PlaySound;
  import com.company.assembleegameclient.net.messages.incoming.GlobalNotification;
  import com.company.assembleegameclient.net.messages.incoming.CreateGuildResult;
  import com.company.assembleegameclient.net.messages.incoming.TradeAccepted;

  import mapoverlay.SpeechBalloon;
  import mapoverlay.CharacterStatusText;

  import com.gskinner.motion.GTween;

  import client.signals.typed.BooleanSignal;

  import com.company.assembleegameclient.net.messages.outgoing.*;
  import com.company.assembleegameclient.net.messages.outgoing.Buy;
  import com.company.assembleegameclient.net.messages.outgoing.Create;
  import com.company.assembleegameclient.net.messages.outgoing.Teleport;
  import com.company.assembleegameclient.net.messages.outgoing.UsePortal;
  import com.company.assembleegameclient.net.messages.outgoing.ChangeGuildRank;
  import com.company.assembleegameclient.net.messages.outgoing.AcceptTrade;
  import com.company.assembleegameclient.net.messages.outgoing.Hello;
  import com.company.assembleegameclient.net.messages.outgoing.EditAccountList;
  import com.company.assembleegameclient.net.messages.outgoing.InvDrop;
  import com.company.assembleegameclient.net.messages.outgoing.Escape;
  import com.company.assembleegameclient.net.messages.outgoing.JoinGuild;
  import com.company.assembleegameclient.net.messages.outgoing.ShootAck;
  import com.company.assembleegameclient.net.messages.outgoing.PlayerShoot;
  import com.company.assembleegameclient.net.messages.outgoing.ChangeTrade;
  import com.company.assembleegameclient.net.messages.outgoing.InvSwap;
  import com.company.assembleegameclient.net.messages.outgoing.RequestTrade;
  import com.company.assembleegameclient.net.messages.outgoing.EnemyHit;
  import com.company.assembleegameclient.net.messages.outgoing.GroundDamage;
  import com.company.assembleegameclient.net.messages.outgoing.PlayerHit;
  import com.company.assembleegameclient.net.messages.outgoing.CreateGuild;
  import com.company.assembleegameclient.net.messages.outgoing.GuildInvite;
  import com.company.assembleegameclient.net.messages.outgoing.Move;
  import com.company.assembleegameclient.net.messages.outgoing.CheckCredits;
  import com.company.assembleegameclient.net.messages.outgoing.AoeAck;
  import com.company.assembleegameclient.net.messages.outgoing.UseItem;
  import com.company.assembleegameclient.net.messages.outgoing.SquareHit;
  import com.company.assembleegameclient.net.messages.outgoing.Pong;
  import com.company.assembleegameclient.net.messages.outgoing.OtherHit;
  import com.company.assembleegameclient.net.messages.outgoing.SetCondition;
  import com.company.assembleegameclient.net.messages.outgoing.GotoAck;
  import com.company.assembleegameclient.net.messages.outgoing.ChooseName;
  import com.company.assembleegameclient.net.messages.outgoing.PlayerText;
  import com.company.assembleegameclient.net.messages.outgoing.Load;
  import com.company.assembleegameclient.net.messages.outgoing.GuildRemove;
  import com.company.assembleegameclient.net.messages.outgoing.CancelTrade;

  import client.ui.frames.ItemResultBox;
  import client.ui.frames.TextInputForm;

  import particleeffects.*;
  import particleeffects.FlowEffect;
  import particleeffects.StreamEffect;
  import particleeffects.TeleportEffect;
  import particleeffects.ThrowEffect;
  import particleeffects.RingEffect;
  import particleeffects.AuraEffect;
  import particleeffects.LineEffect;
  import particleeffects.CollapseEffect;
  import particleeffects.LightningEffect;
  import particleeffects.BurstEffect;
  import particleeffects.ParticleEffect;
  import particleeffects.NovaEffect;
  import particleeffects.SparkEffect;
  import particleeffects.ConeBlastEffect;
  import particleeffects.AoeEffect;

  import game.dialogs.NotEnoughGoldDialog;
  import game.dialogs.NotEnoughFameDialog;
  import game.dialogs.NotEnoughKeysDialog;
  import game.dialogs.Dialog;

  import client.signals.EmptySignal;
  import client.signals.DataSignalB;

  import robotlegs.bender.framework.api.IMessageDispatcher;

  import client.enums.PositionSlot;

  import client.events.NameResultEvent;
  import client.events.ClientUpdateEvent;
  import client.events.ResultEvent;
  import client.events.ReconnectEvent;

  import config.InjectorLocator;

  import client.ui.panels.PartyInvitePanel;

  import client.ui.panels.TradeRequestPanel;
  import client.ui.panels.GuildInvitePanel;

  import game.signals.DeathSignal;
  import game.signals.SingletonSignal;

  import account.Account;

  import audio.SoundEffects;
  import audio.MusicManager;

  import thrownobjects.ThrownObjectSpawner;

  import com.company.assembleegameclient.game.GameSprite;
  import com.company.assembleegameclient.map._X_l;
  import com.company.assembleegameclient.map._pf;
  import com.company.assembleegameclient.net.messages.data.*;
  import com.company.assembleegameclient.net.messages.data.ObjectStatusData;
  import com.company.assembleegameclient.net.messages.data.StatData;
  import com.company.assembleegameclient.net.messages.data._0H_9;
  import com.company.assembleegameclient.net.messages.data._iZ_;
  import com.company.assembleegameclient.objects.*;
  import com.company.assembleegameclient.objects.Container;
  import com.company.assembleegameclient.objects.GameObject;
  import com.company.assembleegameclient.objects.Merchant;
  import com.company.assembleegameclient.objects.NameChanger;
  import com.company.assembleegameclient.objects.ObjectLibrary;
  import com.company.assembleegameclient.objects.Player;
  import com.company.assembleegameclient.objects.Portal;
  import com.company.assembleegameclient.objects.Projectile;
  import com.company.assembleegameclient.objects.SellableObject;
  import com.company.assembleegameclient.objects._T_f;
  import com.company.assembleegameclient.parameters.Parameters;
  import com.company.assembleegameclient.ui.FrameHolder;
  import com.company.assembleegameclient.ui.FrameHolderNoDim;
  import com.company.assembleegameclient.ui._B_N_;
  import com.company.assembleegameclient.util.Currency;
  import com.company.assembleegameclient.util._wW_;
  import com.company.net.ServerConnection;
  import com.company.net.NetworkMessage;
  import com.company.util.Random;
  import com.company.util._L_2;
  import com.hurlant.crypto.rsa.RSAKey;
  import com.hurlant.util.Base64;
  import com.hurlant.util.der.PEM;

  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.events.ErrorEvent;
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.geom.Point;
  import flash.net.FileReference;
  import flash.utils.ByteArray;
  import flash.utils.Timer;
  import flash.utils.getTimer;

  public class PacketManager {

    public static const FAILURE:int = 0;
    public static const CREATE_SUCCESS:int = 31;
    public static const CREATE:int = 36;
    public static const PLAYERSHOOT:int = 38;
    public static const MOVE:int = 7;
    public static const PLAYERTEXT:int = 69;
    public static const TEXT:int = 25;
    public static const _lE_:int = 13;
    public static const DAMAGE:int = 47;
    public static const UPDATE:int = 26;
    public static const _F_3:int = 11;
    public static const NOTIFICATION:int = 63;
    public static const _29:int = 62;
    public static const INVSWAP:int = 65;
    public static const USEITEM:int = 30;
    public static const _0E_H_:int = 56;
    public static const HELLO:int = 17;
    public static const GOTO:int = 52;
    public static const INVDROP:int = 35;
    public static const INVRESULT:int = 4;
    public static const RECONNECT:int = 39;
    public static const PING:int = 6;
    public static const PONG:int = 16;
    public static const MAPINFO:int = 60;
    public static const LOAD:int = 45;
    public static const PIC:int = 28;
    public static const SETCONDITION:int = 10;
    public static const TELEPORT:int = 49;
    public static const USEPORTAL:int = 3;
    public static const DEATH:int = 41;
    public static const BUY:int = 50;
    public static const BUYRESULT:int = 27;
    public static const AOE_:int = 68;
    public static const GROUNDDAMAGE:int = 64;
    public static const PLAYERHIT:int = 24;
    public static const ENEMYHIT:int = 76;
    public static const AOEACK:int = 59;
    public static const SHOOTACK:int = 22;
    public static const OTHERHIT:int = 66;
    public static const SQUAREHIT:int = 51;
    public static const GOTOACK:int = 14;
    public static const EDITACCOUNTLIST:int = 53;
    public static const ACCOUNTLIST:int = 46;
    public static const QUESTOBJID:int = 34;
    public static const CHOOSENAME:int = 33;
    public static const NAMERESULT:int = 20;
    public static const CREATEGUILD:int = 15;
    public static const _0F_w:int = 58;
    public static const GUILDREMOVE:int = 78;
    public static const GUILDINVITE:int = 8;
    public static const ALLYSHOOT:int = 74;
    public static const _0_k:int = 19;
    public static const REQUESTTRADE:int = 21;
    public static const TRADEREQUESTED:int = 61;
    public static const TRADESTART:int = 67;
    public static const CHANGETRADE:int = 37;
    public static const TRADECHANGED:int = 23;
    public static const ACCEPTTRADE:int = 57;
    public static const CANCELTRADE:int = 1;
    public static const TRADEDONE:int = 12;
    public static const TRADEACCEPTED:int = 18;
    public static const CLIENTSTAT:int = 75;
    public static const CHECKCREDITS:int = 48;
    public static const ESCAPE:int = 42;
    public static const _02h:int = 55;
    public static const INVITEDTOGUILD:int = 77;
    public static const JOINGUILD:int = 5;
    public static const CHANGEGUILDRANK:int = 40;
    public static const PLAYSOUND:int = 44;
    public static const GLOBAL_NOTIFICATION:int = 9;
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
    private static const _vb:Vector.<uint> = new <uint>[14802908, 0xFFFFFF, 0x545454];
    private static const _Z_y:Vector.<uint> = new <uint>[5644060, 16549442, 13484223];
    private static const _0A_F_:Vector.<uint> = new <uint>[2493110, 61695, 13880567];
    private static const _pS_:Vector.<uint> = new <uint>[0x3E8A00, 10944349, 13891532];
    private static const partyColors:Vector.<uint> = new <uint>[0x5656B7, 0x7474F7, 13880567];

    private static var _0L_b:int = int.MIN_VALUE;//-2147483648

    public function PacketManager(_arg1:GameSprite, _arg2:Server, _arg3:int, _arg4:Boolean, _arg5:int, _arg6:int, _arg7:ByteArray, _arg8:String) {
      this.gs_ = _arg1;
      this.server_ = _arg2;
      this.gameId_ = _arg3;
      this._96 = _arg4;
      this.charId_ = _arg5;
      this.keyTime_ = _arg6;
      this.key_ = _arg7;
      this._2B_ = _arg8;
      this._08 = new ServerConnection(false);
      this._08.registerMessage(FAILURE, Failure, this._nc);
      this._08.registerMessage(CREATE_SUCCESS, CreateSuccess, this._cw);
      this._08.registerMessage(CREATE, Create, null);
      this._08.registerMessage(PLAYERSHOOT, PlayerShoot, null);
      this._08.registerMessage(MOVE, Move, null);
      this._08.registerMessage(PLAYERTEXT, PlayerText, null);
      this._08.registerMessage(TEXT, Text, this._A_i);
      this._08.registerMessage(_lE_, ServerPlayerShoot, this._C_i);
      this._08.registerMessage(DAMAGE, Damage, this._0A_K_);
      this._08.registerMessage(UPDATE, Update, this._mC_);
      this._08.registerMessage(_F_3, NetworkMessage, null);
      this._08.registerMessage(NOTIFICATION, Notification, this._L_x);
      this._08.registerMessage(GLOBAL_NOTIFICATION, GlobalNotification, this._nG_);
      this._08.registerMessage(_29, NewTick, this._02H_);
      this._08.registerMessage(INVSWAP, InvSwap, null);
      this._08.registerMessage(USEITEM, UseItem, null);
      this._08.registerMessage(_0E_H_, ShowEffect, this._V_z);
      this._08.registerMessage(HELLO, Hello, null);
      this._08.registerMessage(GOTO, Goto, this._gk);
      this._08.registerMessage(INVDROP, InvDrop, null);
      this._08.registerMessage(INVRESULT, InvResult, this._I_I_);
      this._08.registerMessage(RECONNECT, Reconnect, this._X_3);
      this._08.registerMessage(PING, Ping, this._94);
      this._08.registerMessage(PONG, Pong, null);
      this._08.registerMessage(MAPINFO, MapInfo, this._ju);
      this._08.registerMessage(LOAD, Load, null);
      this._08.registerMessage(PIC, Pic, this._F_E_);
      this._08.registerMessage(SETCONDITION, SetCondition, null);
      this._08.registerMessage(TELEPORT, Teleport, null);
      this._08.registerMessage(USEPORTAL, UsePortal, null);
      this._08.registerMessage(DEATH, Death, this._038);
      this._08.registerMessage(BUY, Buy, null);
      this._08.registerMessage(BUYRESULT, BuyResult, this._cN_);
      this._08.registerMessage(AOE_, AOE, this._06y);
      this._08.registerMessage(GROUNDDAMAGE, GroundDamage, null);
      this._08.registerMessage(PLAYERHIT, PlayerHit, null);
      this._08.registerMessage(ENEMYHIT, EnemyHit, null);
      this._08.registerMessage(AOEACK, AoeAck, null);
      this._08.registerMessage(SHOOTACK, ShootAck, null);
      this._08.registerMessage(OTHERHIT, OtherHit, null);
      this._08.registerMessage(SQUAREHIT, SquareHit, null);
      this._08.registerMessage(GOTOACK, GotoAck, null);
      this._08.registerMessage(EDITACCOUNTLIST, EditAccountList, null);
      this._08.registerMessage(ACCOUNTLIST, AccountList, this._0J_R_);
      this._08.registerMessage(QUESTOBJID, QuestObjId, this._fF_);
      this._08.registerMessage(CHOOSENAME, ChooseName, null);
      this._08.registerMessage(NAMERESULT, NameResult, this._0D_s);
      this._08.registerMessage(CREATEGUILD, CreateGuild, null);
      this._08.registerMessage(_0F_w, CreateGuildResult, this._Z_g);
      this._08.registerMessage(GUILDREMOVE, GuildRemove, null);
      this._08.registerMessage(GUILDINVITE, GuildInvite, null);
      this._08.registerMessage(ALLYSHOOT, AllyShoot, this._P_F_);
      this._08.registerMessage(_0_k, EnemyShoot, this._0K_7);
      this._08.registerMessage(REQUESTTRADE, RequestTrade, null);
      this._08.registerMessage(TRADEREQUESTED, TradeRequested, this._G_r);
      this._08.registerMessage(TRADESTART, TradeStart, this._47);
      this._08.registerMessage(CHANGETRADE, ChangeTrade, null);
      this._08.registerMessage(TRADECHANGED, TradeChanged, this._0D_U_);
      this._08.registerMessage(ACCEPTTRADE, AcceptTrade, null);
      this._08.registerMessage(CANCELTRADE, CancelTrade, null);
      this._08.registerMessage(TRADEDONE, TradeDone, this._2d);
      this._08.registerMessage(TRADEACCEPTED, TradeAccepted, this._087);
      this._08.registerMessage(CLIENTSTAT, ClientStat, this._oA_);
      this._08.registerMessage(CHECKCREDITS, CheckCredits, null);
      this._08.registerMessage(ESCAPE, Escape, null);
      this._08.registerMessage(_02h, File, this._J_0);
      this._08.registerMessage(INVITEDTOGUILD, InvitedToGuild, this._cS_);
      this._08.registerMessage(JOINGUILD, JoinGuild, null);
      this._08.registerMessage(CHANGEGUILDRANK, ChangeGuildRank, null);
      this._08.registerMessage(PLAYSOUND, PlaySound, this._A_C_);
      this._08.registerMessage(CRAFT, Craft, null);
      this._08.registerMessage(VISIBULLET, Visibullet, null);
      this._08.registerMessage(SWITCHMUSIC, SwitchMusic, this.switchMusic);
      this._08.registerMessage(INVITEDTOPARTY, InvitedToParty, this.inviteToParty);
      this._08.registerMessage(JOINPARTY, JoinParty, null);
      this._08.registerMessage(PARTYINVITE, PartyInvite, null);
      this._08.registerMessage(ITEMSELECTSTART, ItemSelectStart, this.itemSelectStart);
      this._08.registerMessage(ITEMSELECTRESULT, ItemSelectResult, null);
      this._08.registerMessage(ITEMRESULT, ItemResult, this.itemResult);
      this._08.registerMessage(GETTEXTINPUT, GetTextInput, this.showTextInput);
      this._08.registerMessage(TEXTINPUTRESULT, TextInputResult, null);
      this._08.registerMessage(GIVEITEM, GiveItem, null);
      this._08.registerMessage(PLAYERCHEAT, PlayerCheat, null);
      this._08.registerMessage(MARKETTRADE, MarketTrade, null);
      this._08.registerMessage(MARKETTRADERESULT, MarketTradeResult, this.marketTradeResult);
      this._08.registerMessage(MARKETCREATE, MarketCreate, null);
      this._08.addEventListener(Event.CONNECT, this._ux);
      this._08.addEventListener(Event.CLOSE, this._of);
      this._08.addEventListener(ErrorEvent.ERROR, this.onError);
    }
    public var gs_:GameSprite;
    public var server_:Server;
    public var gameId_:int;
    public var _96:Boolean;
    public var charId_:int;
    public var keyTime_:int;
    public var key_:ByteArray;
    public var _2B_:String;
    public var lastTickId_:int = -1;
    public var _0l:_17 = null;
    public var _08:ServerConnection = null;
    public var outstandingBuy_:_W_v = null;
    private var _5z:int = -1;
    private var _P_A_:Boolean = true;
    private var _7G_:Random = null;
    private var _0c:Timer;
    private var conTimes:int = 1;

    public function connect():void {
      this.gs_.textBox_.addText(Parameters.SendClient, ("Connecting to " + this.server_.name_));
      if (Parameters._wZ_) {
        this._08.setOutgoingCipher("rc4", _L_2._Z_S_("311f80691451c71b09a13a2a6e"));
        this._08.setIncomingCipher("rc4", _L_2._Z_S_("72c5583cafb6818995cbd74b80"));
      }
      this._08.connect(this.server_.address_, this.server_.port_);
    }

    public function getNextDamage(_arg1:uint, _arg2:uint):uint {
      return (this._7G_._0M_K_(_arg1, _arg2));
    }

    public function _9G_():void {
      if (this._0l == null) {
        this._0l = new _17();
      }
    }

    public function _rT_():void {
      if (this._0l != null) {
        this._0l = null;
      }
    }

    public function playerShoot(_arg1:int, _arg2:Projectile):void {
      var _local3:PlayerShoot = (this._08.acquireMessage(PLAYERSHOOT) as PlayerShoot);
      _local3.time_ = _arg1;
      _local3.bulletId_ = _arg2.bulletId_;
      _local3.containerType_ = _arg2.containerType_;
      _local3.startingPos_.x_ = _arg2.x_;
      _local3.startingPos_.y_ = _arg2.y_;
      _local3.angle_ = _arg2.angle_;
      this._08.sendMessage(_local3);
    }

    public function playerCheatCheck():void {
      var _local3:PlayerCheat = (this._08.acquireMessage(PLAYERCHEAT) as PlayerCheat);
      this._08.sendMessage(_local3);
    }

    public function playerHit(_arg1:int, _arg2:int):void {
      var _local3:PlayerHit = (this._08.acquireMessage(PLAYERHIT) as PlayerHit);
      _local3.bulletId_ = _arg1;
      _local3.objectId_ = _arg2;
      this._08.sendMessage(_local3);
    }

    public function enemyHit(_arg1:int, _arg2:int, _arg3:int, _arg4:Boolean, _arg5:int):void {
      var _local5:EnemyHit = (this._08.acquireMessage(ENEMYHIT) as EnemyHit);
      _local5.time_ = _arg1;
      _local5.bulletId_ = _arg2;
      _local5.targetId_ = _arg3;
      _local5.kill_ = _arg4;
      _local5.dmg_ = _arg5;
      this._08.sendMessage(_local5);
    }

    public function otherHit(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void {
      var _local5:OtherHit = (this._08.acquireMessage(OTHERHIT) as OtherHit);
      _local5.time_ = _arg1;
      _local5.bulletId_ = _arg2;
      _local5.objectId_ = _arg3;
      _local5.targetId_ = _arg4;
      this._08.sendMessage(_local5);
    }

    public function squareHit(_arg1:int, _arg2:int, _arg3:int):void {
      var _local4:SquareHit = (this._08.acquireMessage(SQUAREHIT) as SquareHit);
      _local4.time_ = _arg1;
      _local4.bulletId_ = _arg2;
      _local4.objectId_ = _arg3;
      this._08.sendMessage(_local4);
    }

    public function _H_q(_arg1:int, _arg2:Number, _arg3:Number):void {
      var _local4:AoeAck = (this._08.acquireMessage(AOEACK) as AoeAck);
      _local4.time_ = _arg1;
      _local4.position_.x_ = _arg2;
      _local4.position_.y_ = _arg3;
      this._08.sendMessage(_local4);
    }

    public function groundDamage(_arg1:int, _arg2:Number, _arg3:Number):void {
      var _local4:GroundDamage = (this._08.acquireMessage(GROUNDDAMAGE) as GroundDamage);
      _local4.time_ = _arg1;
      _local4.position_.x_ = _arg2;
      _local4.position_.y_ = _arg3;
      this._08.sendMessage(_local4);
    }

    public function _eC_(_arg1:int):void {
      var _local2:ShootAck = (this._08.acquireMessage(SHOOTACK) as ShootAck);
      _local2.time_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function playerText(_arg1:String):void {
      var _local2:PlayerText = (this._08.acquireMessage(PLAYERTEXT) as PlayerText);
      _local2.text_ = _arg1;
      this._08.sendMessage(_local2);
    }

    /*public function invSwap(_arg1:int, _arg2:Number, _arg3:Number, _arg4:int, _arg5:int, _arg6:int, _arg7:int, _arg8:int, _arg9:int):void {
     var _local10:_99 = (this._08._Y_E_(INVSWAP) as _99);
     _local10.time_ = _arg1;
     _local10.position_.x_ = _arg2;
     _local10.position_.y_ = _arg3;
     _local10.slotObject1_.objectId_ = _arg4;
     _local10.slotObject1_.slotId_ = _arg5;
     _local10.slotObject1_.objectType_ = _arg6;
     _local10.slotObject2_.objectId_ = _arg7;
     _local10.slotObject2_.slotId_ = _arg8;
     _local10.slotObject2_.objectType_ = _arg9;
     this._08.sendMessage(_local10);
     }*/

    public function invSwap(_arg1:Player, _arg2:GameObject, _arg3:int, _arg4:int, _arg5:GameObject, _arg6:int, _arg7:int):Boolean{
      if (!gs_) {
        return (false);
      }
      var _local8:InvSwap = (this._08.acquireMessage(INVSWAP) as InvSwap);
      _local8.time_ = gs_.lastUpdate_;
      _local8.position_.x_ = _arg1.x_;
      _local8.position_.y_ = _arg1.y_;
      _local8.slotObject1_.objectId_ = _arg2.objectId_;
      _local8.slotObject1_.slotId_ = _arg3;
      _local8.slotObject1_.objectType_ = _arg4;
      _local8.slotObject2_.objectId_ = _arg5.objectId_;
      _local8.slotObject2_.slotId_ = _arg6;
      _local8.slotObject2_.objectType_ = _arg7;
      this._08.sendMessage(_local8);
      var _local9:int = _arg2.equipment_[_arg3];
      var _local10:Object = _arg2.equipData_[_arg3];
      _arg2.equipData_[_arg3] = _arg5.equipData_[_arg6];
      _arg2.equipment_[_arg3] = _arg5.equipment_[_arg6];
      _arg5.equipment_[_arg6] = _local9;
      _arg5.equipData_[_arg6] = _local10;
      SoundEffects.play("inventory_move_item");
      return (true);
    }

    public function _8q(_arg1:int, _arg2:int, _arg3:int):void {
      var _local4:InvDrop = (this._08.acquireMessage(INVDROP) as InvDrop);
      _local4.slotObject_.objectId_ = _arg1;
      _local4.slotObject_.slotId_ = _arg2;
      _local4.slotObject_.objectType_ = _arg3;
      this._08.sendMessage(_local4);
    }

    public function useItem(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:Number, _arg6:Number):void {
      var _local7:UseItem = (this._08.acquireMessage(USEITEM) as UseItem);
      _local7.time_ = _arg1;
      _local7.slotObject_.objectId_ = _arg2;
      _local7.slotObject_.slotId_ = _arg3;
      _local7.slotObject_.objectType_ = _arg4;
      _local7.itemUsePos_.x_ = _arg5;
      _local7.itemUsePos_.y_ = _arg6;
      this._08.sendMessage(_local7);
    }

    public function _6v(_arg1:uint, _arg2:Number):void {
      var _local3:SetCondition = (this._08.acquireMessage(SETCONDITION) as SetCondition);
      _local3.conditionEffect_ = _arg1;
      _local3.conditionDuration_ = _arg2;
      this._08.sendMessage(_local3);
    }

    public function move(_arg1:int, _arg2:Player):void {
      var _local7:int;
      var _local8:int;
      var _local3:Number = -1;
      var _local4:Number = -1;
      if (((!((_arg2 == null))) && (!(_arg2.isPaused())))) {
        _local3 = _arg2.x_;
        _local4 = _arg2.y_;
      }
      var _local5:Move = (this._08.acquireMessage(MOVE) as Move);
      _local5.tickId_ = _arg1;
      _local5.time_ = this.gs_.lastUpdate_;
      _local5.newPosition_.x_ = _local3;
      _local5.newPosition_.y_ = _local4;
      var _local6:int = this.gs_.moveRecords_.lastClearTime_;
      _local5.records_.length = 0;
      if ((((_local6 >= 0)) && (((_local5.time_ - _local6) > 125)))) {
        _local7 = Math.min(10, this.gs_.moveRecords_.records_.length);
        _local8 = 0;
        while (_local8 < _local7) {
          if (this.gs_.moveRecords_.records_[_local8].time_ >= (_local5.time_ - 25)) break;
          _local5.records_.push(this.gs_.moveRecords_.records_[_local8]);
          _local8++;
        }
      }
      this.gs_.moveRecords_.clear(_local5.time_);
      this._08.sendMessage(_local5);
      _arg2._01w();
    }

    public function teleport(_arg1:int):void {
      var _local2:Teleport = (this._08.acquireMessage(TELEPORT) as Teleport);
      _local2.objectId_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function usePortal(_arg1:int):void {
      var _local2:UsePortal = (this._08.acquireMessage(USEPORTAL) as UsePortal);
      _local2.objectId_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function buy(_arg1:int):void {
      if (this.outstandingBuy_ != null) {
        return;
      }
      var _local2:SellableObject = this.gs_.map_.goDict_[_arg1];
      if (_local2 == null) {
        return;
      }
      var _local3:Boolean;
      if (_local2.currency_ == Currency._class) {
        _local3 = ((((this.gs_.charList_.converted_) || ((this.gs_.map_.player_.credits_ > 100)))) || ((_local2.price_ > this.gs_.map_.player_.credits_)));
      }
      this.outstandingBuy_ = new _W_v(_local2.soldObjectInternalName(), _local2.price_, _local2.currency_, _local3);
      var _local4:Buy = (this._08.acquireMessage(BUY) as Buy);
      _local4.objectId_ = _arg1;
      this._08.sendMessage(_local4);
    }

    public function _S__(_arg1:int):void {
      var _local2:GotoAck = (this._08.acquireMessage(GOTOACK) as GotoAck);
      _local2.time_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function _eH_(_arg1:int, _arg2:Boolean, _arg3:int):void {
      var _local4:EditAccountList = (this._08.acquireMessage(EDITACCOUNTLIST) as EditAccountList);
      _local4.accountListId_ = _arg1;
      _local4.add_ = _arg2;
      _local4.objectId_ = _arg3;
      this._08.sendMessage(_local4);
    }

    public function _K_Q_(_arg1:String):void {
      var _local2:ChooseName = (this._08.acquireMessage(CHOOSENAME) as ChooseName);
      _local2.name_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function _S_W_(_arg1:String):void {
      var _local2:CreateGuild = (this._08.acquireMessage(CREATEGUILD) as CreateGuild);
      _local2.name_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function guildRemove(_arg1:String):void {
      var _local2:GuildRemove = (this._08.acquireMessage(GUILDREMOVE) as GuildRemove);
      _local2.name_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function _H_X_(_arg1:String):void {
      var _local2:GuildInvite = (this._08.acquireMessage(GUILDINVITE) as GuildInvite);
      _local2.name_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function partyInvite(_arg1:String):void {
      var _local2:PartyInvite = (this._08.acquireMessage(PARTYINVITE) as PartyInvite);
      _local2.name_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function requestTrade(_arg1:String):void {
      var _local2:RequestTrade = (this._08.acquireMessage(REQUESTTRADE) as RequestTrade);
      _local2.name_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function _rQ_(_arg1:Vector.<Boolean>):void {
      var _local2:ChangeTrade = (this._08.acquireMessage(CHANGETRADE) as ChangeTrade);
      _local2.offer_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function _E_i(_arg1:Vector.<Boolean>, _arg2:Vector.<Boolean>):void {
      var _local3:AcceptTrade = (this._08.acquireMessage(ACCEPTTRADE) as AcceptTrade);
      _local3.myOffer_ = _arg1;
      _local3.yourOffer_ = _arg2;
      this._08.sendMessage(_local3);
    }

    public function selectItem(_arg1:int):void {
      var _local3:ItemSelectResult = (this._08.acquireMessage(ITEMSELECTRESULT) as ItemSelectResult);
      _local3.slot_ = _arg1;
      this._08.sendMessage(_local3);
    }

    public function textInputResult(_arg1:Boolean, _arg2:String, _arg3:String):void {
      var _local3:TextInputResult = (this._08.acquireMessage(TEXTINPUTRESULT) as TextInputResult);
      _local3.success_ = _arg1;
      _local3.action_ = _arg2;
      _local3.input_ = _arg3;
      this._08.sendMessage(_local3);
    }

    public function marketTrade(_arg1:int):void {
      var _local3:MarketTrade = (this._08.acquireMessage(MARKETTRADE) as MarketTrade);
      _local3.tradeId_ = _arg1;
      this._08.sendMessage(_local3);
    }

    public function marketCreate(_arg1:Vector.<int>, _arg2:Vector.<int>, _arg3:Vector.<Object>):void {
      var _local3:MarketCreate = (this._08.acquireMessage(MARKETCREATE) as MarketCreate);
      _local3.includedSlots_ = _arg1;
      _local3.requestItems_ = _arg2;
      _local3.requestData_ = _arg3;
      this._08.sendMessage(_local3);
    }

    public function giveItem(_arg1:int, _arg2:Object):void {
      var _local3:GiveItem = (this._08.acquireMessage(GIVEITEM) as GiveItem);
      _local3.itemType_ = _arg1;
      if(_arg2 != null) {
        _local3.itemData_ = _arg2;
      } else {
        _local3.itemData_ = {};
      }
      this._08.sendMessage(_local3);
    }


    public function __set():void {
      this._08.sendMessage(this._08.acquireMessage(CANCELTRADE));
    }

    public function _0J_l():void {
      this._08.sendMessage(this._08.acquireMessage(CHECKCREDITS));
    }

    public function _M_6():void {
      this._08.sendMessage(this._08.acquireMessage(ESCAPE));
    }

    public function joinGuild(_arg1:String):void {
      var _local2:JoinGuild = (this._08.acquireMessage(JOINGUILD) as JoinGuild);
      _local2.guildName_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function joinParty(_arg1:int):void {
      var _local2:JoinParty = (this._08.acquireMessage(JOINPARTY) as JoinParty);
      _local2.partyID_ = _arg1;
      this._08.sendMessage(_local2);
    }

    public function _k8(_arg1:String, _arg2:int):void {
      var _local3:ChangeGuildRank = (this._08.acquireMessage(CHANGEGUILDRANK) as ChangeGuildRank);
      _local3.name_ = _arg1;
      _local3.guildRank_ = _arg2;
      this._08.sendMessage(_local3);
    }

    public function craftItems(_arg1:int):void {
      var _loc2_:Craft = this._08.acquireMessage(CRAFT) as Craft;
      _loc2_.objectId_ = _arg1;
      this._08.sendMessage(_loc2_);
    }

    public function sendVisibullet(_damage:int, _enemyId:int, _bulletId:int, _armorPiercing:Boolean):void {
      var _packet:Visibullet = this._08.acquireMessage(VISIBULLET) as Visibullet;
      _packet.damage_ = _damage;
      _packet.enemyId_ = _enemyId;
      _packet.bulletId_ = _bulletId;
      _packet.armorPiercing_ = _armorPiercing;
      this._08.sendMessage(_packet);
    }

    private function _sM_():void {
      SingletonSignal.instance.dispatch();
    }

    private function create():void {
      var _local1:Create = (this._08.acquireMessage(CREATE) as Create);
      _local1.objectType_ = Parameters.data_.playerObjectType;
      this._08.sendMessage(_local1);
    }

    private function load():void {
      var _local1:Load = (this._08.acquireMessage(LOAD) as Load);
      _local1.charId_ = this.charId_;
      this._08.sendMessage(_local1);
    }

    private function _J_X_(_arg1:String):String {
      var _local2:RSAKey = PEM.readRSAPublicKey(Parameters.RSAKey);
      var _local3:ByteArray = new ByteArray();
      _local3.writeUTFBytes(_arg1);
      var _local4:ByteArray = new ByteArray();
      _local2.encrypt(_local3, _local4, _local3.length);
      return (Base64.encodeByteArray(_local4));
    }

    private function _cw(_arg1:CreateSuccess):void {
      this._5z = _arg1.objectId_;
      this.charId_ = _arg1.charId_;
      this.gs_.initialize();
      this._96 = false;
    }

    private function _0A_K_(_arg1:Damage):void {
      var _local5:int;
      var _local2:_X_l = this.gs_.map_;
      var _local3:Projectile;
      if ((((_arg1.objectId_ >= 0)) && ((_arg1.bulletId_ > 0)))) {
        _local5 = Projectile._61(_arg1.objectId_, _arg1.bulletId_);
        _local3 = (_local2._cl[_local5] as Projectile);
        if (((!((_local3 == null))) && (!(_local3._ko._0C_c)))) {
          _local2.removeObj(_local5);
        }
      }
      var _local4:GameObject = _local2.goDict_[_arg1.targetId_];
      if (_local4 != null) {
        _local4.damage(-1, _arg1.damageAmount_, _arg1.effects_, _arg1.kill_, _local3);
      }
    }

    private function _C_i(_arg1:ServerPlayerShoot):void {
      var _local2 = (_arg1.ownerId_ == this._5z);
      var _local3:GameObject = this.gs_.map_.goDict_[_arg1.ownerId_];
      if ((((_local3 == null)) || (_local3._aE_))) {
        if (_local2) {
          this._eC_(-1);
        }
        return;
      }
      var _local4:Projectile = (_wW_._B_1(Projectile) as Projectile);
      _local4.reset(_arg1.containerType_, 0, _arg1.ownerId_, _arg1.bulletId_, _arg1.angle_, this.gs_.lastUpdate_);
      _local4._T_j(_arg1.damage_);
      this.gs_.map_.addObj(_local4, _arg1.startingPos_.x_, _arg1.startingPos_.y_);
      if (_local2) {
        this._eC_(this.gs_.lastUpdate_);
      }
    }

    private function _P_F_(_arg1:AllyShoot):void {
      var _local2:GameObject = this.gs_.map_.goDict_[_arg1.ownerId_];
      if ((((_local2 == null)) || (_local2._aE_) || (Parameters.data_.disableAllyProjectiles))) {
        return;
      }
      var _local3:Projectile = (_wW_._B_1(Projectile) as Projectile);
      _local3.reset(_arg1.containerType_, 0, _arg1.ownerId_, _arg1.bulletId_, _arg1.angle_, this.gs_.lastUpdate_);
      _local3._T_j(_arg1.dmg_);
      this.gs_.map_.addObj(_local3, _local2.x_, _local2.y_);
      _local2.setAttack(_arg1.containerType_, _arg1.angle_);
    }

    private function _0K_7(_arg1:EnemyShoot):void {
      var _local4:Projectile;
      var _local5:Number;
      var _local2:GameObject = this.gs_.map_.goDict_[_arg1.ownerId_];
      if ((((_local2 == null)) || (_local2._aE_))) {
        this._eC_(-1);
        return;
      }
      var _local3:int;
      while (_local3 < _arg1.numShots_) {
        _local4 = (_wW_._B_1(Projectile) as Projectile);
        _local5 = (_arg1.angle_ + (_arg1.angleInc_ * _local3));
        _local4.reset(_local2.objectType_, _arg1.bulletType_, _arg1.ownerId_, ((_arg1.bulletId_ + _local3) % 0x0100), _local5, this.gs_.lastUpdate_);
        _local4._T_j(_arg1.damage_);
        this.gs_.map_.addObj(_local4, _arg1.startingPos_.x_, _arg1.startingPos_.y_);
        _local3++;
      }
      this._eC_(this.gs_.lastUpdate_);
      _local2.setAttack(_local2.objectType_, (_arg1.angle_ + (_arg1.angleInc_ * ((_arg1.numShots_ - 1) / 2))));
    }

    private function _G_r(_arg1:TradeRequested):void {
      if (Parameters.data_.showTradePopup) {
        this.gs_._V_1._U_T_.setOverridePanel(new TradeRequestPanel(this.gs_, _arg1.name_));
      }
      this.gs_.textBox_.addText("", ((((_arg1.name_ + " wants to ") + 'trade with you.  Type "/trade ') + _arg1.name_) + '" to trade.'));
    }

    private function _47(_arg1:TradeStart):void {
      this.gs_._V_1._0L_v(_arg1);
    }

    private function itemSelectStart(_arg1:ItemSelectStart):void {
      this.gs_._V_1.selectItem(_arg1);
    }

    private function _0D_U_(_arg1:TradeChanged):void {
      this.gs_._V_1._ss(_arg1);
    }

    private function _2d(_arg1:TradeDone):void {
      this.gs_._V_1._A_a();
      this.gs_.textBox_.addText("", _arg1.description_);
    }

    private function _087(_arg1:TradeAccepted):void {
      this.gs_._V_1._mH_(_arg1);
    }

    private function _lu(_arg1:_0H_9):void {
      var _local2:_X_l = this.gs_.map_;
      var _local3:GameObject = ObjectLibrary._075(_arg1.objectType_);
      if (_local3 == null) {
        return;
      }
      var _local4:ObjectStatusData = _arg1._zM_;
      _local3.setObjectId(_local4.objectId_);
      _local2.addObj(_local3, _local4.pos_.x_, _local4.pos_.y_);
      if (_local3.objectId_ == this._5z) {
        _local2.player_ = (_local3 as Player);
      }
      this._9s(_local4, 0, -1);
      if (((((_local3.props_.static_) && (_local3.props_.occupySquare_))) && (!(_local3.props_._ia)))) {
        this.gs_._V_1._F_._0A_R_(_local3.x_, _local3.y_, _local3);
      }
    }

    private function _mC_(_arg1:Update):void {
      var _local3:int;
      var _local4:_iZ_;
      var _local2:NetworkMessage = this._08.acquireMessage(_F_3);
      this._08.sendMessage(_local2);
      _local3 = 0;
      while (_local3 < _arg1.tiles_.length) {
        _local4 = _arg1.tiles_[_local3];
        this.gs_.map_.setGroundTile(_local4.x_, _local4.y_, _local4.type_);
        this.gs_._V_1._F_.setGroundTile(_local4.x_, _local4.y_, _local4.type_);
        _local3++;
      }
      _local3 = 0;
      while (_local3 < _arg1.newObjs_.length) {
        this._lu(_arg1.newObjs_[_local3]);
        _local3++;
      }
      _local3 = 0;
      while (_local3 < _arg1.drops_.length) {
        this.gs_.map_.removeObj(_arg1.drops_[_local3]);
        _local3++;
      }
    }

    private function _L_x(_arg1:Notification):void {
      var _local2:GameObject = this.gs_.map_.goDict_[_arg1.objectId_];
      if (_local2 != null) {
        this.gs_.map_.mapOverlay_.addChild(new CharacterStatusText(_local2, _arg1.text_, _arg1.color_, 2000));
        if ((((_local2 == this.gs_.map_.player_)) && ((_arg1.text_ == "Quest Complete!")))) {
          this.gs_.map_.quest_.completed();
        }
      }
    }

    private function _nG_(_arg1:GlobalNotification):void {
      switch (_arg1.text) {
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

    private function _02H_(_arg1:NewTick):void {
      var _local3:ObjectStatusData;
      if (this._0l != null) {
        this._0l._06m();
      }
      var _local2:_X_l = this.gs_.map_;
      this.move(_arg1.tickId_, _local2.player_);
      for each (_local3 in _arg1.statuses_) {
        this._9s(_local3, _arg1.tickTime_, _arg1.tickId_);
      }
      this.lastTickId_ = _arg1.tickId_;
    }

    private function _V_z(_arg1:ShowEffect):void {
      var _local3:GameObject;
      var _local4:ParticleEffect;
      var _local5:Point;
      var _local6:Point;
      var _local2:_X_l = this.gs_.map_;
      switch (_arg1.effectType_) {
        case ShowEffect.HEAL_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local2.addObj(new AuraEffect(_local3, _arg1.color_), _local3.x_, _local3.y_);
          return;
        case ShowEffect.TELEPORT_EFFECT:
          _local2.addObj(new TeleportEffect(), _arg1.pos1_.x_, _arg1.pos1_.y_);
          return;
        case ShowEffect.STREAM_EFFECT:
          _local4 = new StreamEffect(_arg1.pos1_, _arg1.pos2_, _arg1.color_);
          _local2.addObj(_local4, _arg1.pos1_.x_, _arg1.pos1_.y_);
          return;
        case ShowEffect.THROW_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          _local5 = (((_local3) != null) ? new Point(_local3.x_, _local3.y_) : _arg1.pos2_._6g());
          _local4 = new ThrowEffect(_local5, _arg1.pos1_._6g(), _arg1.color_);
          _local2.addObj(_local4, _local5.x, _local5.y);
          return;
        case ShowEffect.NOVA_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local4 = new NovaEffect(_local3, _arg1.pos1_.x_, _arg1.color_);
          _local2.addObj(_local4, _local3.x_, _local3.y_);
          return;
        case ShowEffect.POISON_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local4 = new SparkEffect(_local3, _arg1.color_);
          _local2.addObj(_local4, _local3.x_, _local3.y_);
          return;
        case ShowEffect.LINE_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local4 = new LineEffect(_local3, _arg1.pos1_, _arg1.color_);
          _local2.addObj(_local4, _arg1.pos1_.x_, _arg1.pos1_.y_);
          return;
        case ShowEffect.BURST_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local4 = new BurstEffect(_local3, _arg1.pos1_, _arg1.pos2_, _arg1.color_);
          _local2.addObj(_local4, _arg1.pos1_.x_, _arg1.pos1_.y_);
          return;
        case ShowEffect.FLOW_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local4 = new FlowEffect(_arg1.pos1_, _local3, _arg1.color_);
          _local2.addObj(_local4, _arg1.pos1_.x_, _arg1.pos1_.y_);
          return;
        case ShowEffect.RING_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local4 = new RingEffect(_local3, _arg1.pos1_.x_, _arg1.color_);
          _local2.addObj(_local4, _local3.x_, _local3.y_);
          return;
        case ShowEffect.LIGHTNING_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local4 = new LightningEffect(_local3, _arg1.pos1_, _arg1.color_, _arg1.pos2_.x_);
          _local2.addObj(_local4, _local3.x_, _local3.y_);
          return;
        case ShowEffect.COLLAPSE_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local4 = new CollapseEffect(_local3, _arg1.pos1_, _arg1.pos2_, _arg1.color_);
          _local2.addObj(_local4, _arg1.pos1_.x_, _arg1.pos1_.y_);
          return;
        case ShowEffect.CONEBLAST_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local4 = new ConeBlastEffect(_local3, _arg1.pos1_, _arg1.pos2_.x_, _arg1.color_);
          _local2.addObj(_local4, _local3.x_, _local3.y_);
          return;
        case ShowEffect.JITTER_EFFECT:
          this.gs_.camera_._uE_();
          return;
        case ShowEffect.FLASH_EFFECT:
          _local3 = _local2.goDict_[_arg1.targetObjectId_];
          if (_local3 == null) break;
          _local3._B_t = new _T_f(getTimer(), _arg1.color_, _arg1.pos1_.x_, _arg1.pos1_.y_);
          return;
        case ShowEffect.THROW_PROJECTILE_EFFECT:
          _local5 = _arg1.pos1_._6g();
          _local6 = _arg1.pos2_._6g();
          _local4 = new ThrownObjectSpawner(_arg1.pos2_._6g(), _arg1.pos1_._6g());
          _local2.addObj(_local4, _local5.x, _local5.y);
          return;
      }
    }

    private function _gk(_arg1:Goto):void {
      this._S__(this.gs_.lastUpdate_);
      var _local2:GameObject = this.gs_.map_.goDict_[_arg1.objectId_];
      if (_local2 == null) {
        return;
      }
      _local2._gk(_arg1.pos_.x_, _arg1.pos_.y_, this.gs_.lastUpdate_);
    }

    private function _066(_arg1:GameObject, _arg2:Vector.<StatData>, _arg3:Boolean):void {
      var _local4:StatData;
      var _local8:int;
      var _local9:int;
      for each (_local4 in _arg2) {
        _local8 = _local4._h;
        switch (_local4._0F_4) {
          case StatData._0I_1:
            _arg1.maxHP_ = _local8;
            break;
          case StatData._V_A_:
            _arg1.HP_ = _local8;
            break;
          case StatData._g0:
            _arg1.size_ = _local8;
            break;
          case StatData._079:
            (_arg1 as Player).maxMP_ = _local8;
            break;
          case StatData._aC_:
            (_arg1 as Player).MP_ = _local8;
            break;
          case StatData._K_P_:
            (_arg1 as Player)._7V_ = _local8;
            break;
          case StatData._0_8:
            (_arg1 as Player).exp_ = _local8;
            break;
          case StatData._70:
            _arg1.level_ = _local8;
            break;
          case StatData._0R_:
            (_arg1 as Player).attack_ = _local8;
            break;
          case StatData._sw:
            _arg1.defense_ = _local8;
            break;
          case StatData._00l:
            (_arg1 as Player).speed_ = _local8;
            break;
          case StatData._0J_z:
            (_arg1 as Player).dexterity_ = _local8;
            break;
          case StatData._S_2:
            (_arg1 as Player).vitality_ = _local8;
            break;
          case StatData._0G_F_:
            (_arg1 as Player).wisdom_ = _local8;
            break;
          case StatData._luckData:
            (_arg1 as Player).luck_ = _local8;
            break;
          case StatData._critData:
            (_arg1 as Player).crit_ = _local8;
            break;
          case StatData._x_:
            _arg1._9B_ = _local8;
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
         /* case StatData.InvData12:
          case StatData.InvData13:
          case StatData.InvData14:
          case StatData.InvData15:
          case StatData.InvData16:
          case StatData.InvData17:
          case StatData.InvData18:
          case StatData.InvData19:
          case StatData.InvData20:
          case StatData.InvData21:
          case StatData.InvData22:
          case StatData.InvData23:
          case StatData.InvData24:
          case StatData.InvData25:
          case StatData.InvData26:
          case StatData.InvData27: */
            _arg1.equipData_[(_local4._0F_4 - StatData.INVDATA_0_STAT)] = JSON.parse(_local4._3x);
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
            _arg1.equipment_[(_local4._0F_4 - StatData.INVENTORY_0_STAT)] = _local8;
            break;
         /* case StatData.Backpack1_0:
          case StatData.Backpack1_1:
          case StatData.Backpack1_2:
          case StatData.Backpack1_3:
          case StatData.Backpack1_4:
          case StatData.Backpack1_5:
          case StatData.Backpack1_6:
          case StatData.Backpack1_7:
              _arg1.backpack1[(_local4._0F_4 - StatData.Backpack1_0)] = _local4._h;
            break;

          case StatData.Backpack2_0:
          case StatData.Backpack2_1:
          case StatData.Backpack2_2:
          case StatData.Backpack2_3:
          case StatData.Backpack2_4:
          case StatData.Backpack2_5:
          case StatData.Backpack2_6:
          case StatData.Backpack2_7:
              _arg1.backpack2[(_local4._0F_4 - StatData.Backpack2_0)] = _local4._h;
            break;
          case StatData.HasBackpack1:
            if(_arg1.backpack1 == null && _local4._h == 1) {
              _arg1.backpack1 = new <int>[-1, -1, -1, -1, -1, -1, -1, -1];
            }
            break;
          case StatData.HasBackpack2:
            if(_arg1.backpack2 == null && _local4._h == 1) {
              _arg1.backpack2 = new <int>[-1, -1, -1, -1, -1, -1, -1, -1];
            }
            break; */
          case StatData._s9:
            (_arg1 as Player).numStars_ = _local8;
            break;
          case StatData._hK_:
            if (_arg1.name_ != _local4._3x) {
              _arg1.name_ = _local4._3x;
              _arg1._U_g = null;
            }
            break;
          case StatData.TEX1_STAT:
            _arg1.setTex1(_local8);
            break;
          case StatData.TEX2_STAT:
            _arg1.setTex2(_local8);
            break;
          case StatData._K_u:
            (_arg1 as Merchant).setMerchandiseType(_local8);
            break;
          case StatData._Q_c:
            (_arg1 as Player)._F_S_(_local8);
            break;
          case StatData._h1:
            (_arg1 as SellableObject).setPrice(_local8);
            break;
          case StatData._1m:
            (_arg1 as Portal)._09S_ = !((_local8 == 0));
            break;
          case StatData._Z_N_:
            (_arg1 as Player).accountId_ = _local8;
            break;
          case StatData._0M_V_:
            (_arg1 as Player).fame_ = _local8;
            break;
          case StatData._06_:
            (_arg1 as SellableObject)._gF_(_local8);
            break;
          case StatData._3y:
            _arg1._O_l = _local8;
            break;
          case StatData._e7:
            (_arg1 as Merchant)._1I_ = _local8;
            (_arg1 as Merchant)._z5 = 0;
            break;
          case StatData._ud:
            (_arg1 as Merchant)._gt = _local8;
            (_arg1 as Merchant)._z5 = 0;
            break;
          case StatData._V_c:
            (_arg1 as Merchant)._S_I_ = _local8;
            (_arg1 as Merchant)._z5 = 0;
            break;
          case StatData._H_I_:
            (_arg1 as SellableObject).setRankReq(_local8);
            break;
          case StatData._P_z:
            (_arg1 as Player)._P_7 = _local8;
            break;
          case StatData._vc:
            (_arg1 as Player)._0D_G_ = _local8;
            break;
          case StatData._06o:
            (_arg1 as Player)._05s = _local8;
            break;
          case StatData._07D_:
            (_arg1 as Player)._07f = _local8;
            break;
          case StatData._luckBonus:
            (_arg1 as Player).stat_luck = _local8;
            break;
          case StatData._critBonus:
            (_arg1 as Player).stat_crit = _local8;
            break;
          case StatData._7F_:
            (_arg1 as Player)._065 = _local8;
            break;
          case StatData._rx:
            (_arg1 as Player)._pP_ = _local8;
            break;
          case StatData._wT_:
            (_arg1 as Player)._B_e = _local8;
            break;
          case StatData._0M_9:
            (_arg1 as Player)._cu = _local8;
            break;
          case StatData._0E_c:
            (_arg1 as Container)._75(_local8);
            break;
          case StatData._4z:
            (_arg1 as NameChanger)._Y__(_local8);
            break;
          case StatData._m0:
            (_arg1 as Player)._hv = !((_local8 == 0));
            _arg1._U_g = null;
            break;
          case StatData._03k:
            (_arg1 as Player)._0L_o = _local8;
            break;
          case StatData._dR_:
            (_arg1 as Player)._n8 = _local8;
            break;
          case StatData._095:
            (_arg1 as Player)._2v = _local8;
            break;
          case StatData._hi:
            if (!_arg3) {
              (_arg1 as Player)._0F_ = _local8;
            }
            break;
          case StatData._0F_5:
            _arg1._5w(_local8);
            break;
          case StatData._07q:
            (_arg1 as Player)._Y_C_(_local4._3x);
            break;
          case StatData._L_i:
            (_arg1 as Player).guildRank_ = _local8;
            break;
          case StatData._5J_:
            (_arg1 as Player)._R_4 = _local8;
            break;
          case StatData._bk:
            (_arg1 as Player)._gz = _local8;
            break;
          case StatData.SKIN_STAT:
            _arg1.setSkin(_local8);
            break;
            break;
          case StatData.PVP_STAT:
            _arg1.pvp_ = _local8 != 0;
            break;
          case StatData.TEAM_STAT:
            _arg1.team_ = _local8;
            break;
          case StatData.KEYS:
            (_arg1 as Player).setKeys(_local8);
            break;
          case StatData.CANNEXUS:
            (_arg1 as Player).canNexus = _local8 != 0;
            break;
          case StatData.PARTY_STAT:
            (_arg1 as Player).UpdateParty(_local8);
            break;
          case StatData.PARTY_LEADER_STAT:
            (_arg1 as Player).partyLeader = _local8 != 0;
            break;
          case StatData.EFFECT_STAT:
            (_arg1 as Player).setEffect(_local4._3x);
        }
      }
    }

    private function _9s(_arg1:ObjectStatusData, _arg2:int, _arg3:int):void {
      var _local8:int;
      var _local9:int;
      var _local10:Array;
      var _local4:_X_l = this.gs_.map_;
      var _local5:GameObject = _local4.goDict_[_arg1.objectId_];
      if (_local5 == null) {
        return;
      }
      var _local6 = (_arg1.objectId_ == this._5z);
      if (((!((_arg2 == 0))) && (!(_local6)))) {
        _local5._0I_u(_arg1.pos_.x_, _arg1.pos_.y_, _arg2, _arg3);
      }
      var _local7:Player = (_local5 as Player);
      if (_local7 != null) {
        _local8 = _local7.level_;
        _local9 = _local7.exp_;
      }
      this._066(_local5, _arg1._086, _local6);
      if (((!((_local7 == null))) && (!((_local8 == -1))))) {
        if (_local7.level_ > _local8) {
          if (_local6) {
            _local10 = this.gs_.charList_.classesUnlockedBy(_local7.objectType_, _local7.level_);
            _local7._ut(!((_local10.length == 0)));
          } else {
            _local7._x1("Level Up!");
          }
        } else {
          if (_local7.exp_ > _local9) {
            _local7._0I_I_((_local7.exp_ - _local9));
          }
        }
      }
    }

    private function _A_i(_arg1:Text):void {
      var _local6:Player = this.gs_.map_.player_;
      var _local3:GameObject;
      var _local4:Vector.<uint>;
      var _local2:String = _arg1.text_;
      var _local5:Boolean = (_arg1.numStars_ == -1 || _arg1.objectId_ == -1);
      if ((_arg1.numStars_ < Parameters.data_.chatStarRequirement) && !(nameCheck(_arg1.name_, _local6)) && !(_local5) && !(this.chatCheck(_arg1.recipient_)) && _arg1.name_.charAt(0) != "@") {
        return;
      }
      if ((((((_arg1.cleanText_.length > 0)) && (!((_arg1.objectId_ == this._5z))))) && (Parameters.data_.filterLanguage))) {
        _local2 = _arg1.cleanText_;
      }
      if (_arg1.objectId_ >= 0) {
        _local3 = this.gs_.map_.goDict_[_arg1.objectId_];
        if (_local3 != null) {
          _local4 = _vb;
          if (_local3.props_.isEnemy_) {
            _local4 = _Z_y;
          } else {
            if (_arg1.recipient_ == Parameters.SendGuild) {
              _local4 = _pS_;
            } else if (_arg1.recipient_ == Parameters.SendParty) {
              _local4 = partyColors;
            } else {
              if (_arg1.recipient_ != "") {
                _local4 = _0A_F_;
              }
            }
          }
          this.gs_.map_.mapOverlay_.addSpeechBalloon(new SpeechBalloon(_local3, _local2, _local4[0], 1, _local4[1], 1, _local4[2], _arg1.bubbleTime_, false, true));
        }
      }
      if ((_local2) || !Parameters.data_.hidePlayerChat || (this.chatCheck(_arg1.name_))) {
        this.gs_.textBox_._ro(_arg1.name_, _arg1.objectId_, _arg1.numStars_, _arg1.recipient_, _local2);
      }
    }

    private function nameCheck(_arg1:String, _arg2:Player):Boolean {
      var _local1:String = _arg1;
      var _local2:String = _arg2.name_;
      return _local1 == _local2;

    }

    private function chatCheck(_arg1:String):Boolean {
      return (_arg1.length > 0 && (_arg1.charAt(0) == "*" || _arg1.charAt(0) == "#" || _arg1.charAt(0) == "@" || _arg1.charAt(0) == "!"));
    }

    private function _I_I_(_arg1:InvResult):void {
      if (_arg1.result_ != 0) {
        this._v6();
      }
    }

    private function _v6():void {
      SoundEffects.play("error");
      this.gs_._V_1._02y._e9.refresh();
      this.gs_._V_1._02y.equips_.refresh();
      this.gs_._V_1._U_T_.redraw();
    }

    private function _X_3(_arg1:Reconnect):void {
      var _local2:ReconnectEvent = new ReconnectEvent(new Server(_arg1.name_, _arg1.host_ != "" ? _arg1.host_ : this.server_.address_, _arg1.host_ != "" ? _arg1.port_ : this.server_.port_), _arg1.gameId_, this._96, this.charId_, _arg1.keyTime_, _arg1.key_);
      this.gs_.dispatchEvent(_local2);
    }

    private function _94(_arg1:Ping):void {
      var _local2:Pong = (this._08.acquireMessage(PONG) as Pong);
      _local2.serial_ = _arg1.serial_;
      _local2.time_ = getTimer();
      this._08.sendMessage(_local2);
    }

    private function _7N_(_arg1:String):void {
      var _local2:XML = XML(_arg1);
      _pf._nY_(_local2);
      ObjectLibrary._nY_(_local2);
    }

    private function _ju(_arg1:MapInfo):void {
      var _local2:String;
      var _local3:String;
      for each (_local2 in _arg1.clientXML_) {
        this._7N_(_local2);
      }
      for each (_local3 in _arg1.extraXML_) {
        this._7N_(_local3);
      }
      this.gs_._S_z(_arg1);
      this._7G_ = new Random(_arg1.fp_);
      if (this._96) {
        this.create();
      } else {
        this.load();
      }
    }

    private function _F_E_(_arg1:Pic):void {
      this.gs_.addChild(new _B_N_(_arg1.bitmapData_));
    }

    private function _038(_arg1:Death):void {
      audio.MusicManager.reload("Death");
      var _local2:BitmapData = new BitmapData(800, 600);
      _local2.draw(this.gs_);
      _arg1.background = _local2;
      if (this.gs_.isEditor) {
        return;
      }
      InjectorLocator.getInjector().getInstance(DeathSignal).dispatch(_arg1);
    }

    private function _cN_(_arg1:BuyResult):void {
      if (_arg1.result_ == BuyResult.RESULT_0) {
        if (this.outstandingBuy_ != null) {
          this.outstandingBuy_._06m();
        }
      }
      this.outstandingBuy_ = null;
      switch (_arg1.result_) {
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
          this.gs_.textBox_.addText((((_arg1.result_ == BuyResult.RESULT_0)) ? Parameters.SendInfo : Parameters.SendError), _arg1.resultString_);
      }
    }

    private function _0J_R_(_arg1:AccountList):void {
      if (_arg1.accountListId_ == 0) {
        this.gs_.map_.party_.setStars(_arg1);
      }
      if (_arg1.accountListId_ == 1) {
        this.gs_.map_.party_.setIgnores(_arg1);
      }
    }

    private function _fF_(_arg1:QuestObjId):void {
      this.gs_.map_.quest_.setObject(_arg1.objectId_);
    }

    private function _06y(_arg1:AOE):void {
      var _local5:int;
      var _local6:Vector.<uint>;
      var _local2:Player = this.gs_.map_.player_;
      if (_local2 == null) {
        this._H_q(this.gs_.lastUpdate_, 0, 0);
        return;
      }
      var _local3:AoeEffect = new AoeEffect(_arg1.pos_._6g(), _arg1.radius_, 0xFF0000);
      this.gs_.map_.addObj(_local3, _arg1.pos_.x_, _arg1.pos_.y_);
      if (((_local2._0C_4()) || (_local2.isPaused()))) {
        this._H_q(this.gs_.lastUpdate_, _local2.x_, _local2.y_);
        return;
      }
      var _local4 = (_local2._F_Y_(_arg1.pos_) < _arg1.radius_);
      if (_local4) {
        _local5 = GameObject._C_f(_arg1.damage_, _local2.defense_, false, _local2._9B_);
        _local6 = null;
        if (_arg1.effect_ != 0) {
          _local6 = new Vector.<uint>();
          _local6.push(_arg1.effect_);
        }
        _local2.damage(_arg1.origType_, _local5, _local6, false, null);
      }
      this._H_q(this.gs_.lastUpdate_, _local2.x_, _local2.y_);
    }

    private function _0D_s(_arg1:NameResult):void {
      this.gs_.dispatchEvent(new NameResultEvent(_arg1));
    }

    private function _Z_g(_arg1:CreateGuildResult):void {
      if (_arg1.errorText_ != "")
        this.gs_.textBox_.addText(Parameters.SendError, _arg1.errorText_);
      this.gs_.dispatchEvent(new ResultEvent(_arg1.success_, _arg1.errorText_));
    }

    private function marketTradeResult(_arg1:MarketTradeResult):void {
      if (_arg1.errorText_ != "")
        this.gs_.textBox_.addText(_arg1.success_ ? "" : Parameters.SendError, _arg1.errorText_);
      this.gs_.dispatchEvent(new ResultEvent(_arg1.success_, _arg1.errorText_, ResultEvent.MARKET_RESULT));
    }

    private function _oA_(_arg1:ClientStat):void {
      Account.getInstance().reportIntStat(_arg1.name_, _arg1.value_);
    }

    private function _J_0(_arg1:File):void {
      new FileReference().save(_arg1.file_, _arg1.filename_);
    }

    private function _cS_(_arg1:InvitedToGuild):void {
      if (Parameters.data_.showGuildInvitePopup) {
        this.gs_._V_1._U_T_.setOverridePanel(new GuildInvitePanel(this.gs_, _arg1.name_, _arg1.guildName_));
      }
      this.gs_.textBox_.addText("", (((((("You have been invited by " + _arg1.name_) + " to join the guild ") + _arg1.guildName_) + '.\n  If you wish to join type "/join ') + _arg1.guildName_) + '"'));
    }

    private function inviteToParty(_arg1:InvitedToParty):void {
      if (Parameters.data_.showGuildInvitePopup) {
        this.gs_._V_1._U_T_.setOverridePanel(new PartyInvitePanel(this.gs_, _arg1.name_, _arg1.partyID_));
      }
      this.gs_.textBox_.addText("", "You have been invited by " + _arg1.name_ + " to join a party.\nIf you wish to join, type \"/party join " + _arg1.name_ + "\"");
    }

    private function _A_C_(_arg1:PlaySound):void {
      var _local2:GameObject = this.gs_.map_.goDict_[_arg1.ownerId_];
      if (_local2 == null) {
        return;
      }
      _local2._05M_(_arg1.soundId_);
    }

    private function _P_p(_arg1:int):void {
      this._0c = new Timer((_arg1 * 1000), 1);
      this._0c.addEventListener(TimerEvent.TIMER_COMPLETE, this._F_z);
      this._0c.start();
    }

    private function _nc(_arg1:Failure):void {
      switch (_arg1.errorId_) {
        case Failure.INCORRECT_VERSION:
          this._ee(_arg1);
          return;
        case Failure.BAD_KEY:
          this._0H_6(_arg1);
          return;
        case Failure.INVALID_TELEPORT_TARGET:
          this._0K_Z_(_arg1);
          return;
        case Failure.EMAIL_VERIFICATION_NEEDED:
          this._0z_K_(_arg1);
          return;
        case Failure.TELEPORT_REALM_BLOCK:
          this._ga1(_arg1);
          return;
        default:
          this._0M_G_(_arg1);
      }
    }

    private function _ga1(_arg1:Failure):void {
      this._P_A_ = false;
      this.gs_.dispatchEvent(new Event(Event.COMPLETE));
    }

    private function _0z_K_(_arg1:Failure):void {
      var _local2:Dialog = new Dialog("Guest accounts have been disabled for improved security.", "Anti-Guest Guard", "Ok", null, "/noGuests");
      _local2.addEventListener(Dialog.BUTTON1_EVENT, this._Y_h);
      this.gs_.stage.addChild(_local2);
      this._P_A_ = false;
    }

    private function _0K_Z_(_arg1:Failure):void {
      this.gs_.textBox_.addText(Parameters.SendError, _arg1.errorDescription_);
      this.gs_.map_.player_.nextTeleportAt_ = 0;
    }

    private function _0H_6(_arg1:Failure):void {
      this.gs_.textBox_.addText(Parameters.SendError, _arg1.errorDescription_);
      this._P_A_ = false;
      this.gs_.dispatchEvent(new Event(Event.COMPLETE));
    }

    private function _ee(_arg1:Failure):void {
      var _local2:Dialog = new Dialog(((("Client version: " + Parameters.clientVersion) + "\nServer version: ") + _arg1.errorDescription_ + "\n\nPlease use one of these links to play: " + '<font color="#7777EE"> <a href="http://bledixon.com/client/WebMain.swf">' + "          Client #1 </a></font>" + '<font color="#7777EE"> <a href="http://bledixon.com/xclient/WebMain.swf">' + "          Client #2</a></font>"), "Client Update Needed", "Ok", null, "/clientUpdate");
      _local2.addEventListener(Dialog.BUTTON1_EVENT, this._Y_h);
      this.gs_.stage.addChild(_local2);
      this._P_A_ = false;
    }

    private function _0M_G_(_arg1:Failure):void {
      this.gs_.textBox_.addText(Parameters.SendError, _arg1.errorDescription_);
    }

    private function _H_8():void {
      this.gs_.dispatchEvent(new Event(Event.COMPLETE));
    }

    private function switchMusic(_arg1:SwitchMusic):void {
      audio.MusicManager.reload(_arg1.music_);
    }

    private function itemResult(_arg1:ItemResult):void {
      var _local1:ItemResultBox = new ItemResultBox(this.gs_, _arg1.item_, "acquired", JSON.parse(_arg1.data_));
      this.gs_.stage.addChild(new FrameHolder(_local1));
    }

    private function showTextInput(_arg1:GetTextInput):void {
      var _local1:TextInputForm = new TextInputForm(this.gs_, _arg1.name_, _arg1.action_);
      this.gs_.stage.addChild(new FrameHolder(_local1));
    }

    private function _ux(_arg1:Event):void {
      this.gs_.textBox_.addText(Parameters.SendClient, "Enjoy your Stay!");
      var _local2:Hello = (this._08.acquireMessage(HELLO) as Hello);
      _local2.copyright_ = "450d6aefthfasdt45z4asd78b8227atfh37xdff";
      _local2._5c2_ = "bledixon.com";
      _local2.buildVersion_ = Parameters.clientVersion;
      _local2.gameId_ = this.gameId_;
      _local2.guid_ = this._J_X_(Account.getInstance().guid());
      _local2.password_ = this._J_X_(Account.getInstance().password());
      _local2.secret_ = this._J_X_(Account.getInstance().secret());
      _local2.keyTime_ = this.keyTime_;
      _local2.key_.length = 0;
      if (this.key_ != null) {
        _local2.key_.writeBytes(this.key_);
      }
      _local2.mapJSON_ = (((this._2B_ == null)) ? "" : this._2B_);
      _local2._8U_ = Account.getInstance().entrytag();
      _local2._yt = Account.getInstance().gameNetwork();
      _local2._J_k = Account.getInstance().gameNetworkUserId();
      _local2.playPlatform = Account.getInstance().playPlatform();
      this._08.sendMessage(_local2);
    }

    private function _of(_arg1:Event):void {
      if (this._5z != -1) {
        this.gs_.dispatchEvent(new Event(Event.COMPLETE));
        return;
      } else {
        if (this._P_A_)
        {
          if (this.conTimes < 5)
          {
            this._P_p(this.conTimes++);
          }
          else
          {
            this.gs_.dispatchEvent(new Event(Event.COMPLETE));
          }
          this.gs_.textBox_.addText(Parameters.SendError, "Connection failed!  Retrying...");
        }
      }
    }

    private function _F_z(_arg1:TimerEvent):void {
      this.connect();
    }

    private function onError(_arg1:ErrorEvent):void {
      this.gs_.textBox_.addText(Parameters.SendError, _arg1.text);
    }

    private function _Y_h(_arg1:Event):void {
      var _local2:Dialog = (_arg1.currentTarget as Dialog);
      _local2.parent.removeChild(_local2);
      this.gs_.dispatchEvent(new ClientUpdateEvent());
    }

  }
}//package com.company.assembleegameclient.net


