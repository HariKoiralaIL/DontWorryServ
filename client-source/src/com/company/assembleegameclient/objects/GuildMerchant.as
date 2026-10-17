package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.util.Currency;
    import com.company.assembleegameclient.util.GuildUtil;

    import com.company.assembleegameclient.ui.tooltip.TitleDescriptionToolTip;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;

    import flash.display.BitmapData;

    public class GuildMerchant extends SellableObject implements IInteractable {

        public function GuildMerchant(xml:XML) {
            super(xml);
            price_ = int(xml.Price);
            currency_ = Currency.GUILD_FAME;
            this.description_ = xml.Description;
            guildRankReq_ = GuildUtil.LEADER;
        }
        public var description_:String;

        override public function soldObjectName():String {
            return (ObjectLibrary.typeToDisplayId_[objectType_]);
        }

        override public function soldObjectInternalName():String {
            var _local1:XML = ObjectLibrary.typeToXML_[objectType_];
            return (_local1.@id.toString());
        }

        override public function getTooltip():ToolTip {
            return (new TitleDescriptionToolTip(0x2A2A2A, 0x9B9B9B, this.soldObjectName(), this.description_, 200));
        }

        override public function getIcon():BitmapData {
            return (ObjectLibrary.getRedrawnTextureFromType(objectType_, 80, true));
        }

    }
}//package com.company.assembleegameclient.objects
