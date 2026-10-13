package com.company.assembleegameclient.appengine {
import account.Account;

import com.company.assembleegameclient.net.Server;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util._04d;
import com.company.util._0K_N_;

import config.InjectorLocator;

import flash.events.Event;

import injection.Injector;

/** Parsed response of the /char/list call. */
public class CharListEvent extends Event {

    public static const SAVED_CHARS_LIST:String = "SAVED_CHARS_LIST";

    private static const ONE_DAY_MS:int = 86400000;
    private static const DEFAULT_LAT_LONG:_0K_N_ = new _0K_N_(37.4436, -122.412);

    public var rawXML_:String;
    public var xml_:XML;
    public var accountId_:int;
    public var nextCharId_:int;
    public var maxNumChars_:int;
    public var numChars_:int = 0;
    public var savedChars_:Vector.<SavedCharacter>;
    public var charStats_:Object;
    public var totalFame_:int = 0;
    public var keys_:int = 0;
    public var fame_:int = 0;
    public var credits_:int = 0;
    public var numStars_:int = 0;
    public var nextCharSlotPrice_:int;
    public var guildName_:String;
    public var guildRank_:int;
    public var servers_:Vector.<Server>;
    public var name_:String = null;
    public var nameChosen_:Boolean;
    public var converted_:Boolean;
    public var isAdmin_:Boolean;
    public var newsItems_:Vector.<NewsEntry>;
    public var clientLatLong_:_0K_N_;
    public var classAvailability_:Object;

    public function CharListEvent(rawXML:String) {
        this.savedChars_ = new Vector.<SavedCharacter>();
        this.charStats_ = {};
        this.servers_ = new Vector.<Server>();
        this.newsItems_ = new Vector.<NewsEntry>();
        super(SAVED_CHARS_LIST);
        this.rawXML_ = rawXML;
        this.xml_ = new XML(rawXML);
        var accountXML:XML = XML(this.xml_.Account);
        this.parseAccount(accountXML);
        this.parseBeginnerOffer(accountXML);
        this.parseGuild(accountXML);
        this.parseCharacters();
        this.parseClassStats();
        this.parseServers();
        this.parseNews();
        this.parseLatLong();
        this.reportClassesUnlocked();
        this.reportBestStats();
        this.parseClassAvailability();
    }

    override public function clone():Event {
        return new CharListEvent(this.rawXML_);
    }

    override public function toString():String {
        return "[ numChars: " + this.numChars_ + " maxNumChars: " + this.maxNumChars_ + " ]";
    }

    public function bestLevel(classType:int):int {
        var stats:ClassStats = this.charStats_[classType];
        return (stats == null) ? 0 : stats.bestLevel();
    }

    public function bestFame(classType:int):int {
        var stats:ClassStats = this.charStats_[classType];
        return (stats == null) ? 0 : stats.bestFame();
    }

    public function bestOverallLevel():int {
        var best:int = 0;
        for each (var stats:ClassStats in this.charStats_) {
            if (stats.bestLevel() > best) {
                best = stats.bestLevel();
            }
        }
        return best;
    }

    public function bestOverallFame():int {
        var best:int = 0;
        for each (var stats:ClassStats in this.charStats_) {
            if (stats.bestFame() > best) {
                best = stats.bestFame();
            }
        }
        return best;
    }

    public function isAvailable(classType:int):Boolean {
        var classXML:XML = ObjectLibrary.typeToXML_[classType];
        for each (var requirement:XML in classXML.UnlockLevel) {
            var requiredType:int = ObjectLibrary.idToType_[requirement.toString()];
            if (this.bestLevel(requiredType) < int(requirement.@level)) {
                return false;
            }
        }
        return true;
    }

    public function availableCharSlots():int {
        return this.maxNumChars_ - this.numChars_;
    }

    public function hasAvailableCharSlot():Boolean {
        return this.numChars_ < this.maxNumChars_;
    }

    /**
     * Locked classes whose only missing requirement is
     * reaching `level` with class `classType`.
     */
    public function classesUnlockedBy(classType:int, level:int):Array {
        var result:Array = [];
        for (var i:int = 0; i < ObjectLibrary.playerChars_.length; i++) {
            var classXML:XML = ObjectLibrary.playerChars_[i];
            var type:int = int(classXML.@type);
            if (this.isAvailable(type)) {
                continue;
            }
            var onlyThisMissing:Boolean = true;
            var thisMissing:Boolean = false;
            for each (var requirement:XML in classXML.UnlockLevel) {
                var requiredType:int = ObjectLibrary.idToType_[requirement.toString()];
                var requiredLevel:int = int(requirement.@level);
                if (this.bestLevel(requiredType) < requiredLevel) {
                    if (requiredType != classType || requiredLevel != level) {
                        onlyThisMissing = false;
                        break;
                    }
                    thisMissing = true;
                }
            }
            if (onlyThisMissing && thisMissing) {
                result.push(type);
            }
        }
        return result;
    }

    public function getBestServer():Server {
        if (!Parameters.isTesting) {
            return new Server("Ent", "localhost", Parameters.gamePort);
        }
        var best:Server = null;
        var bestDistance:Number = Number.MAX_VALUE;
        var bestPriority:int = int.MAX_VALUE;
        for each (var server:Server in this.servers_) {
            if (server.isFull() && !this.isAdmin_) {
                continue;
            }
            if (server.name_ == Parameters.data_.preferredServer) {
                return server;
            }
            var priority:int = server.priority();
            var distance:Number = _0K_N_.distance(this.clientLatLong_, server.latLong_);
            if (priority < bestPriority || (priority == bestPriority && distance < bestDistance)) {
                best = server;
                bestDistance = distance;
                bestPriority = priority;
            }
        }
        return best;
    }

    private function parseAccount(accountXML:XML):void {
        this.accountId_ = int(accountXML.AccountId);
        this.name_ = String(accountXML.Name);
        this.nameChosen_ = accountXML.hasOwnProperty("NameChosen");
        this.converted_ = accountXML.hasOwnProperty("Converted");
        this.isAdmin_ = accountXML.hasOwnProperty("Admin");
        Player._e_D = this.isAdmin_;
        this.totalFame_ = int(accountXML.Stats.TotalFame);
        this.fame_ = int(accountXML.Stats.Fame);
        this.credits_ = int(accountXML.Credits);
        this.keys_ = int(accountXML.Keys);
        this.nextCharSlotPrice_ = int(accountXML.NextCharSlotPrice);
    }

    private function parseBeginnerOffer(accountXML:XML):void {
        if (!accountXML.hasOwnProperty("BeginnerPackageTimeLeft")) {
            return;
        }
        var timeLeft:int = _04d._3r(accountXML.BeginnerPackageTimeLeft);
        Parameters.data_.beginnersOfferTimeLeft = timeLeft;
        var now:Number = new Date().time;
        var showNow:Boolean = timeLeft > 0 && Parameters.data_.beginnersOfferShowNowTime < now;
        Parameters.data_.beginnersOfferShowNow = showNow;
        if (showNow) {
            Parameters.data_.beginnersOfferShowNowTime = now + ONE_DAY_MS;
        }
    }

    private function parseGuild(accountXML:XML):void {
        if (!accountXML.hasOwnProperty("Guild")) {
            return;
        }
        var guildXML:XML = XML(accountXML.Guild);
        this.guildName_ = String(guildXML.Name);
        this.guildRank_ = int(guildXML.Rank);
    }

    private function parseCharacters():void {
        this.nextCharId_ = int(this.xml_.@nextCharId);
        this.maxNumChars_ = int(this.xml_.@maxNumChars);
        for each (var charXML:XML in this.xml_.Char) {
            this.savedChars_.push(new SavedCharacter(charXML, this.name_));
            this.numChars_++;
        }
        this.savedChars_.sort(SavedCharacter.compareByUsage);
    }

    private function parseClassStats():void {
        var statsXML:XML = XML(this.xml_.Account.Stats);
        for each (var classStatsXML:XML in statsXML.ClassStats) {
            var classStats:ClassStats = new ClassStats(classStatsXML);
            this.numStars_ += classStats.numStars();
            this.charStats_[int(classStatsXML.@objectType)] = classStats;
        }
    }

    private function parseServers():void {
        var serversXML:XML = XML(this.xml_.Servers);
        for each (var serverXML:XML in serversXML.Server) {
            this.servers_.push(new Server(
                    String(serverXML.Name),
                    String(serverXML.DNS),
                    Parameters.gamePort,
                    new _0K_N_(Number(serverXML.Lat), Number(serverXML.Long)),
                    Number(serverXML.Usage),
                    serverXML.hasOwnProperty("AdminOnly")));
        }
    }

    private function parseNews():void {
        var newsXML:XML = XML(this.xml_.News);
        for each (var itemXML:XML in newsXML.Item) {
            this.newsItems_.push(new NewsEntry(
                    String(itemXML.Icon),
                    String(itemXML.Title),
                    String(itemXML.TagLine),
                    String(itemXML.Link),
                    int(itemXML.Date)));
        }
    }

    private function parseLatLong():void {
        if (this.xml_.hasOwnProperty("Lat") && this.xml_.hasOwnProperty("Long")) {
            this.clientLatLong_ = new _0K_N_(Number(this.xml_.Lat), Number(this.xml_.Long));
        } else {
            this.clientLatLong_ = DEFAULT_LAT_LONG;
        }
    }

    private function parseClassAvailability():void {
        this.classAvailability_ = {};
        for each (var availabilityXML:XML in this.xml_.ClassAvailabilityList.ClassAvailability) {
            this.classAvailability_[availabilityXML.@id.toString()] = availabilityXML.toString();
        }
    }

    private function reportClassesUnlocked():void {
        var acct:Account = Account.getInstance();
        var unlocked:int = 0;
        for (var i:int = 0; i < ObjectLibrary.playerChars_.length; i++) {
            var classXML:XML = ObjectLibrary.playerChars_[i];
            if (this.isAvailable(int(classXML.@type))) {
                acct.reportIntStat(classXML.@id + "Unlocked", 1);
                unlocked++;
            }
        }
        acct.reportIntStat("ClassesUnlocked", unlocked);
    }

    private function reportBestStats():void {
        var injector:Injector = InjectorLocator.getInjector();
        if (injector == null) {
            return;
        }
        var acct:Account = injector.getInstance(Account);
        acct.reportIntStat("BestLevel", this.bestOverallLevel());
        acct.reportIntStat("BestFame", this.bestOverallFame());
        acct.reportIntStat("NumStars", this.numStars_);
    }

}
}
