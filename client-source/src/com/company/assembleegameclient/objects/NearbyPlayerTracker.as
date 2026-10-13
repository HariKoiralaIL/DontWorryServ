package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.map.GameMap;

    import flash.utils.Dictionary;

    import com.company.util.PointUtil;

    import com.company.assembleegameclient.net.messages.incoming.AccountList;

    public class NearbyPlayerTracker {

        public static const MAX_LISTED:int = 8;
        private static const SORT_FIELDS:Array = ["starred_", "distSqFromThisPlayer_", "objectId_"];
        private static const SORT_OPTIONS:Array = [(Array.NUMERIC | Array.DESCENDING), Array.NUMERIC, Array.NUMERIC];
        private static const MAX_DIST_SQ:int = (50 * 50);//2500

        public function NearbyPlayerTracker(map:GameMap) {
            this.members_ = [];
            this.starred_ = new Dictionary(true);
            this.ignored_ = new Dictionary(true);
            super();
            this.map_ = map;
        }
        public var map_:GameMap;
        public var members_:Array;
        private var lastUpdate_:int = -2147483648;
        private var starred_:Dictionary;
        private var ignored_:Dictionary;

        public function update(time:int, dt:int):void {
            var _local4:GameObject;
            var _local5:Player;
            if (time < (this.lastUpdate_ + 500)) {
                return;
            }
            this.lastUpdate_ = time;
            this.members_.length = 0;
            var _local3:Player = this.map_.player_;
            if (_local3 == null) {
                return;
            }
            for each (_local4 in this.map_.goDict_) {
                _local5 = (_local4 as Player);
                if (!(((_local5 == null)) || ((_local5 == _local3)))) {
                    if (this.starred_[_local5.accountId_] != undefined) {
                        _local5.starred_ = true;
                    }
                    _local5.isIgnored_ = !((this.ignored_[_local5.accountId_] == undefined));
                    _local5.distSqFromThisPlayer_ = PointUtil._bm(_local3.x_, _local3.y_, _local5.x_, _local5.y_);
                    if (!(((_local5.distSqFromThisPlayer_ > MAX_DIST_SQ)) && (!(_local5.starred_)))) {
                        if (_local3.canBeHitBy(_local5)) {
                            if (!_local5.isInvisible()) {
                                this.members_.push(_local5);
                            }
                        } else {
                            this.members_.push(_local5);
                        }
                    }
                }
            }
            this.members_.sortOn(SORT_FIELDS, SORT_OPTIONS);
            if (this.members_.length > MAX_LISTED) {
                this.members_.length = MAX_LISTED;
            }
        }

        public function lockPlayer(player:Player):void {
            this.starred_[player.accountId_] = 1;
            this.lastUpdate_ = int.MIN_VALUE;
            this.map_.gs_.gsc_.editAccountList(0, true, player.objectId_);
        }

        public function unlockPlayer(player:Player):void {
            delete this.starred_[player.accountId_];
            player.starred_ = false;
            this.lastUpdate_ = int.MIN_VALUE;
            this.map_.gs_.gsc_.editAccountList(0, false, player.objectId_);
        }

        public function setStars(accountList:AccountList):void {
            var _local3:int;
            var _local2:int;
            while (_local2 < accountList.accountIds_.length) {
                _local3 = accountList.accountIds_[_local2];
                this.starred_[_local3] = 1;
                this.lastUpdate_ = int.MIN_VALUE;
                _local2++;
            }
        }

        public function ignorePlayer(player:Player):void {
            this.ignored_[player.accountId_] = 1;
            this.lastUpdate_ = int.MIN_VALUE;
            this.map_.gs_.gsc_.editAccountList(1, true, player.objectId_);
        }

        public function unignorePlayer(player:Player):void {
            delete this.ignored_[player.accountId_];
            player.isIgnored_ = false;
            this.lastUpdate_ = int.MIN_VALUE;
            this.map_.gs_.gsc_.editAccountList(1, false, player.objectId_);
        }

        public function setIgnores(accountList:AccountList):void {
            var _local3:int;
            this.ignored_ = new Dictionary(true);
            var _local2:int;
            while (_local2 < accountList.accountIds_.length) {
                _local3 = accountList.accountIds_[_local2];
                this.ignored_[_local3] = 1;
                this.lastUpdate_ = int.MIN_VALUE;
                _local2++;
            }
        }

    }
}//package com.company.assembleegameclient.objects
