package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.util._str152;

    import flash.utils.Dictionary;

    import spriteanimation.AnimationsData;

    import flash.utils.getDefinitionByName;
    import flash.display.BitmapData;

    import com.company.util.AssetLibrary;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.ui.Slot;
    import com.company.util.ConversionUtil;
    import com.company.assembleegameclient.net.messages.data.StatData;

    import com.company.assembleegameclient.objects.Wall;

    public class ObjectLibrary {

        public static const typeToProps_:Dictionary = new Dictionary();
        public static const typeToXML_:Dictionary = new Dictionary();
        public static const idToType_:Dictionary = new Dictionary();
        public static const typeToDisplayId_:Dictionary = new Dictionary();
        public static const typeToTextureData_:Dictionary = new Dictionary();
        public static const typeToTopTextureData_:Dictionary = new Dictionary();
        public static const typeToAnimationsData_:Dictionary = new Dictionary();
        public static const defaultProps_:ObjectProperties = new ObjectProperties(null);
        public static const objLibrary:Object = {
            "CaveWall":CaveWall,
            "Character":Character,
            "CharacterChanger":CharacterChanger,
            "ClosedGiftChest": ClosedGiftChest,
            "ClosedVaultChest":ClosedVaultChest,
            "ConnectedWall":ConnectedWall,
            "Container":LootContainer,
            "DoubleWall":DoubleWall,
            "Forge":Forge,
            "GameObject":GameObject,
            "GuildBoard":GuildBoard,
            "GuildChronicle":GuildChronicle,
            "GuildMerchant":GuildMerchant,
            "GuildRegister":GuildRegister,
            "MarketplaceGround":MarketplaceGround,
            "Merchant":Merchant,
            "MoneyChanger":MoneyChanger,
            "NameChanger":NameChanger,
            "Player":Player,
            "Portal":Portal,
            "GuildHallPortal":GuildHallPortal,
            "Projectile":Projectile,
            "Reforge":Reforge,
            "Sign":Sign,
            "SpiderWeb":SpiderWeb,
            "Stalagmite":Stalagmite,
            "Wall":Wall
        };

        public static var playerChars_:Vector.<XML> = new Vector.<XML>();
        public static var hexableXmls_:Vector.<XML> = new Vector.<XML>();
        public static var playerClassAbbr_:Dictionary = new Dictionary();
        public static var ITEMS_:Vector.<String> = new Vector.<String>();

        private static const TAG_GLOWS:Array = [
        ["RT", 0x351c75], ["Heroic", 0x10d000], ["Ancestral", 0x5080f0],
        ["Godly", 0xE01DBF], ["GodSlayer", 0xd80d38], ["Eternal", 0x6a38ea],
        ["Divine", 0xf04040]
        ];
        private static const glowCache_:Dictionary = new Dictionary();

        public static function getTagGlow(type:int):uint {
            var xml:XML = typeToXML_[type];
            var color:uint = 0;
            if (xml != null) {
                for each (var t:Array in TAG_GLOWS) {
                    if (xml.hasOwnProperty(t[0])) { color = uint(t[1]); break; }
                }
            }
            return color;
        }

        public static function parseFromXML(xml:XML):void {
            var _local2:XML;
            var _local3:String;
            var _local4:String;
            var _local5:int;
            var _local6:Boolean;
            var _local7:int;
            for each (_local2 in xml.Object) {
                _local3 = String(_local2.@id);
                _local4 = _local3;
                if (_local2.hasOwnProperty("DisplayId")) {
                    _local4 = _local2.DisplayId;
                }
                if (_local2.hasOwnProperty("Group")) {
                    if (_local2.Group == "Hexable") {
                        hexableXmls_.push(_local2);
                    }
                }
                _local5 = int(_local2.@type);
                typeToProps_[_local5] = new ObjectProperties(_local2);
                typeToXML_[_local5] = _local2;
                delete glowCache_[_local5];
                idToType_[_local3] = _local5;
                typeToDisplayId_[_local5] = _local4;
                if (String(_local2.Class) == "Equipment") {
                    ITEMS_.push(String(_local2.@id));
                }
                if (String(_local2.Class) == "Player") {
                    playerClassAbbr_[_local5] = String(_local2.@id).substr(0, 2);
                    _local6 = false;
                    _local7 = 0;
                    while (_local7 < playerChars_.length) {
                        if (int(playerChars_[_local7].@type) == _local5) {
                            playerChars_[_local7] = _local2;
                            _local6 = true;
                        }
                        _local7++;
                    }
                    if (!_local6) {
                        playerChars_.push(_local2);
                    }
                }
                typeToTextureData_[_local5] = new TextureData(_local2);
                if (_local2.hasOwnProperty("Top")) {
                    typeToTopTextureData_[_local5] = new TextureData(XML(_local2.Top));
                }
                if (_local2.hasOwnProperty("Animation")) {
                    typeToAnimationsData_[_local5] = new AnimationsData(_local2);
                }
            }
        }

        public static function getIdFromType(type:int):String {
            var _local2:XML = typeToXML_[type];
            if (_local2 == null) {
                return (null);
            }
            return (String(_local2.@id));
        }

        public static function getPropsFromId(id:String):ObjectProperties {
            var _local2:int = idToType_[id];
            return (typeToProps_[_local2]);
        }

        public static function getXMLFromId(id:String):XML {
            var _local2:int = idToType_[id];
            return (typeToXML_[_local2]);
        }

        public static function makeCornerWidget(width:int):_str152{
            var _local2:_str152 = new _str152();
            _local2.y = 4;
            _local2.x = ((width - _local2.width) - 5);
            return (_local2);
        }

        public static function getObjectFromType(type:int):GameObject {
            var _local2:XML = typeToXML_[type];
            var _local3:String = _local2.Class;
            var _local4:Class = ((objLibrary[_local3]) || (getClassByName(_local3)));
            //var _local4:GameObject = new (_local3)(_local2);
            return (new (_local4)(_local2));
        }

        private static function getClassByName(className:String):Class {
            var _local2:String = ("com.company.assembleegameclient.objects." + className);
            return ((getDefinitionByName(_local2) as Class));
        }

        public static function getTextureFromType(type:int):BitmapData {
            var _local2:TextureData = typeToTextureData_[type];
            if (_local2 == null) {
                return (null);
            }
            return (_local2.getTexture());
        }

        public static function getRedrawnTextureFromType(type:int, size:int, includeBottom:Boolean, useCaching:Boolean = true, scaleValue:Number = 5, glowColor:uint = 0, glowAlpha:uint = 0):BitmapData {
            if (glowColor == 0) { glowColor = getTagGlow(type); if (glowColor != 0 && glowAlpha == 0) glowAlpha = 1; }
            var _local6:TextureData = typeToTextureData_[type];
            var _local7:BitmapData = _local6.getTexture();
            if (_local7 == null) {
                _local7 = AssetLibrary._xK_("lofiObj3", 0xFF);
            }
            var _local8:BitmapData = _local6.mask_;
            if (_local8 == null) {
                return (TextureRedrawer.redraw(_local7, size, includeBottom, glowColor, glowAlpha, useCaching, scaleValue));
            }
            var _local9:XML = typeToXML_[type];
            var _local10:int = ((_local9.hasOwnProperty("Tex1")) ? int(_local9.Tex1) : 0);
            var _local11:int = ((_local9.hasOwnProperty("Tex2")) ? int(_local9.Tex2) : 0);
            _local7 = TextureRedrawer.resize(_local7, _local8, size, includeBottom, _local10, _local11);
            _local7 = TextureRedrawer.outlineGlow(_local7, glowColor, glowAlpha);
            return (_local7);
        }

        public static function getRedrawnTextureFromTypeCustom(type:int, size:int, includeBottom:Boolean, textureObj:Object, useCaching:Boolean = true, scaleValue:Number = 5, glowColor:uint = 0, glowAlpha:uint = 0):BitmapData {
            if (scaleValue == 0) { scaleValue = getTagGlow(type); if (scaleValue != 0 && glowColor == 0) glowColor = 1; }
            var _local6:TextureData = typeToTextureData_[type];
            var _local7:BitmapData = AssetLibrary._xK_(textureObj.TextureFile, int(textureObj.TextureIndex));
            if (_local7 == null) {
                _local7 = AssetLibrary._xK_("lofiObj3", 0xFF);
            }
            var _local8:BitmapData = _local6.mask_;
            if (_local8 == null) {
                return (TextureRedrawer.redraw(_local7, size, includeBottom, glowColor, glowAlpha, useCaching, scaleValue));
            }
            var _local9:XML = typeToXML_[type];
            var _local10:int = ((_local9.hasOwnProperty("Tex1")) ? int(_local9.Tex1) : 0);
            var _local11:int = ((_local9.hasOwnProperty("Tex2")) ? int(_local9.Tex2) : 0);
            _local7 = TextureRedrawer.resize(_local7, _local8, size, includeBottom, _local10, _local11);
            _local7 = TextureRedrawer.outlineGlow(_local7, glowColor, glowAlpha);
            return (_local7);
        }

        public static function getSizeFromType(type:int):int {
            var _local2:XML = typeToXML_[type];
            if (!_local2.hasOwnProperty("Size")) {
                return (100);
            }
            return (int(_local2.Size));
        }

        public static function getSlotTypeFromType(type:int):int {
            var _local2:XML = typeToXML_[type];
            if (!_local2.hasOwnProperty("SlotType")) {
                return (-1);
            }
            return (int(_local2.SlotType));
        }

        public static function fitsPlayerSlots(type:int, player:Player):Boolean {
            if (type == -1) {
                return (false);
            }
            var _local3:XML = typeToXML_[type];
            var _local4:int = int(_local3.SlotType.toString());
            var _local5:uint;
            while (_local5 < 4) {
                if (player.slotTypes_[_local5] == _local4) {
                    return (true);
                }
                _local5++;
            }
            return (false);
        }

        public static function canUseItem(type:int, player:Player):Boolean {
            if (player == null) {
                return (true);
            }
            var _local3:XML = typeToXML_[type];
            if ((((_local3 == null)) || (!(_local3.hasOwnProperty("SlotType"))))) {
                return (false);
            }
            if (_local3.Activate == "UnlockSkin" && _local3.Activate.hasOwnProperty("@skinType")) {
                var _skin:XML = ObjectLibrary.typeToXML_[int(_local3.Activate.@skinType)];
                if (_skin == null || !_skin.hasOwnProperty("PlayerClassType") || int(_skin.PlayerClassType) != player.objectType_)
                    return false;
            }
            var _local4:int = _local3.SlotType;
            if (_local4 == Slot.potion_) {
                return (true);
            }
            var _local5:int;
            while (_local5 < player.slotTypes_.length) {
                if (player.slotTypes_[_local5] == _local4) {
                    return (true);
                }
                _local5++;
            }
            return (false);
        }

        public static function checkLevelRequirement(type:int, player:Player):Boolean {
            if(type == -1) {
                return true;
            }
            var _local1:XML = typeToXML_[type];
            if(player == null || _local1 == null || !(_local1.hasOwnProperty("LevelReq"))) {
                return true;
            }
            return player.level_ >= int(_local1.LevelReq);
        }

        public static function isSoulbound(type:int, itemData:Object = null):Boolean {
            var _local2:XML = typeToXML_[type];
            return (((!((_local2 == null))) && ((_local2.hasOwnProperty("Soulbound")) || ((itemData != null && itemData.hasOwnProperty("Soulbound") && itemData.Soulbound == true)))));
        }

        public static function usableByClasses(type:int):Vector.<String> {
            var _local5:XML;
            var _local6:Vector.<int>;
            var _local7:int;
            var _local2:XML = typeToXML_[type];
            if ((((_local2 == null)) || (!(_local2.hasOwnProperty("SlotType"))))) {
                return (null);
            }
            var _local3:int = _local2.SlotType;
            if (_local2.Activate == "UnlockSkin" && _local2.Activate.hasOwnProperty("@skinType")) {
                var _skin:XML = ObjectLibrary.typeToXML_[int(_local2.Activate.@skinType)];
                if (_skin != null && _skin.hasOwnProperty("PlayerClassType"))
                    return new <String>[typeToDisplayId_[int(_skin.PlayerClassType)]];
            }
            if ((((_local3 == Slot.potion_)) || ((_local3 == Slot.accessory_)))) {
                return (null);
            }
            var _local4:Vector.<String> = new Vector.<String>();
            for each (_local5 in playerChars_) {
                _local6 = ConversionUtil._04n(_local5.SlotTypes);
                _local7 = 0;
                while (_local7 < _local6.length) {
                    if (_local6[_local7] == _local3) {
                        _local4.push(typeToDisplayId_[int(_local5.@type)]);
                        break;
                    }
                    _local7++;
                }
            }
            return (_local4);
        }

        public static function meetsEquipRequirements(type:int, player:Player):Boolean {
            var _local4:XML;
            if (player == null) {
                return (true);
            }
            var _local3:XML = typeToXML_[type];
            for each (_local4 in _local3.EquipRequirement) {
                if (!checkEquipRequirement(_local4, player)) {
                    return (false);
                }
            }
            return (true);
        }

        public static function checkEquipRequirement(req:XML, player:Player):Boolean {
            var _local3:int;
            if (req.toString() == "Stat") {
                _local3 = int(req.@value);
                switch (int(req.@stat)) {
                    case StatData.MAX_HP_STAT:
                        return ((player.maxHP_ >= _local3));
                    case StatData.MAX_MP_STAT:
                        return ((player.maxMP_ >= _local3));
                    case StatData.LEVEL_STAT:
                        return ((player.level_ >= _local3));
                    case StatData.ATTACK_STAT:
                        return ((player.attack_ >= _local3));
                    case StatData.DEFENSE_STAT:
                        return ((player.defense_ >= _local3));
                    case StatData.SPEED_STAT:
                        return ((player.speed_ >= _local3));
                    case StatData.VITALITY_STAT:
                        return ((player.vitality_ >= _local3));
                    case StatData.WISDOM_STAT:
                        return ((player.wisdom_ >= _local3));
                    case StatData.DEXTERITY_STAT:
                        return ((player.dexterity_ >= _local3));
                    case StatData._luckData:
                        return ((player.luck_ >= _local3));
                    case StatData._critData:
                        return ((player.crit_ >= _local3));
                }
            }
            return (false);
        }

        public static function searchItems(query:String):Vector.<int> {
            var filterFunction:Function = function(item:String, index:int, vec:Vector.<String>):Boolean {
                if(item.toLowerCase().indexOf(query.toLowerCase()) != -1) {
                    return true;
                }
                return false;
            };
            var ret:Vector.<int> = new Vector.<int>();
            var eacherFunction:Function = function(item:String, index:int, vec:Vector.<String>):void {
                ret.push(idToType_[item]);
            };
            ITEMS_.filter(filterFunction).forEach(eacherFunction);
            return ret;
        }

        public static function getRarity(type:int):String {
            var _local1:XML = typeToXML_[type];
            if(_local1 == null) {
                return "Common";
            }
            var _local2:int = 1;
            if(_local1.hasOwnProperty("Rarity")) {
                _local2 = int(_local1.Rarity);
            }
            switch(_local2) {
                case 0:
                    return "Poor";
                case 1:
                    return "Common";
                case 2:
                    return "Uncommon";
                case 3:
                    return "Rare";
                case 4:
                    return "Epic";
                case 5:
                    return "Legendary";
                default:
                    return "Common";
            }
        }

        public static function getRarityColor(rarity:String):int {
            switch(rarity) {
                case "Poor":
                    return 0x9d9d9d;
                case "Common":
                    return 0xffffff;
                case "Uncommon":
                    return 0x1eff00;
                case "Rare":
                    return 0x0070dd;
                case "Epic":
                    return 0xa335ee;
                case "Legendary":
                    return 0xff8000;
                case "Artifact":
                case "Heirloom":
                    return 0xe6cc80;
                default:
                    return 0xffffff;
            }
        }

        public static function getItemNameColor(type:int):int {
            return getRarityColor(getRarity(type));
        }

    }
}//package com.company.assembleegameclient.objects
