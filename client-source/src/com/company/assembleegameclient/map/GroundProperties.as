package com.company.assembleegameclient.map {
import com.company.assembleegameclient.objects.TextureData;
import com.company.util.BitmapUtil;

import flash.display.BitmapData;

/** Properties of one ground tile type, parsed from a <Ground> XML node. */
public class GroundProperties {

    public var type_:int;
    public var id_:String;
    public var noWalk_:Boolean = true;
    public var minDamage_:int = 0;
    public var maxDamage_:int = 0;
    public var animate_:AnimateProperties;
    public var blendPriority_:int = -1;
    public var compositePriority_:int = 0;
    public var speed_:Number = 1;
    public var xOffset_:Number = 0;
    public var yOffset_:Number = 0;
    public var push_:Boolean = false;
    public var sink_:Boolean = false;
    public var sinking_:Boolean = false;
    public var randomOffset_:Boolean = false;
    public var hasEdge_:Boolean = false;
    public var sameTypeEdgeMode_:Boolean = false;
    public var topData_:TextureData = null;
    public var topAnimate_:AnimateProperties = null;
    private var edgeData_:TextureData = null;
    private var cornerData_:TextureData = null;
    private var innerCornerData_:TextureData = null;
    private var edgeTextures_:Vector.<BitmapData> = null;
    private var innerCornerTextures_:Vector.<BitmapData> = null;

    public function GroundProperties(xml:XML) {
        this.animate_ = new AnimateProperties();
        this.type_ = int(xml.@type);
        this.id_ = String(xml.@id);
        this.noWalk_ = xml.hasOwnProperty("NoWalk");
        if (xml.hasOwnProperty("MinDamage")) {
            this.minDamage_ = int(xml.MinDamage);
        }
        if (xml.hasOwnProperty("MaxDamage")) {
            this.maxDamage_ = int(xml.MaxDamage);
        }
        if (xml.hasOwnProperty("Animate")) {
            this.animate_.parse(XML(xml.Animate));
        }
        if (xml.hasOwnProperty("BlendPriority")) {
            this.blendPriority_ = int(xml.BlendPriority);
        }
        if (xml.hasOwnProperty("CompositePriority")) {
            this.compositePriority_ = int(xml.CompositePriority);
        }
        if (xml.hasOwnProperty("Speed")) {
            this.speed_ = Number(xml.Speed);
        }
        this.xOffset_ = xml.hasOwnProperty("XOffset") ? Number(xml.XOffset) : 0;
        this.yOffset_ = xml.hasOwnProperty("YOffset") ? Number(xml.YOffset) : 0;
        this.push_ = xml.hasOwnProperty("Push");
        this.sink_ = xml.hasOwnProperty("Sink");
        this.sinking_ = xml.hasOwnProperty("Sinking");
        this.randomOffset_ = xml.hasOwnProperty("RandomOffset");
        if (xml.hasOwnProperty("Edge")) {
            this.hasEdge_ = true;
            this.edgeData_ = new TextureData(XML(xml.Edge));
            if (xml.hasOwnProperty("Corner")) {
                this.cornerData_ = new TextureData(XML(xml.Corner));
            }
            if (xml.hasOwnProperty("InnerCorner")) {
                this.innerCornerData_ = new TextureData(XML(xml.InnerCorner));
            }
        }
        this.sameTypeEdgeMode_ = xml.hasOwnProperty("SameTypeEdgeMode");
        if (xml.hasOwnProperty("Top")) {
            this.topData_ = new TextureData(XML(xml.Top));
            this.topAnimate_ = new AnimateProperties();
            if (xml.hasOwnProperty("TopAnimate")) {
                this.topAnimate_.parse(XML(xml.TopAnimate));
            }
        }
    }

    /** 3x3 grid of edge/corner textures (index 4 = centre, unused). Built lazily. */
    public function getEdgeTextures():Vector.<BitmapData> {
        if (!this.hasEdge_ || this.edgeTextures_ != null) {
            return this.edgeTextures_;
        }
        this.edgeTextures_ = new Vector.<BitmapData>(9);
        this.edgeTextures_[3] = this.edgeData_.getTexture(0);
        this.edgeTextures_[1] = BitmapUtil._c(this.edgeTextures_[3], 1);
        this.edgeTextures_[5] = BitmapUtil._c(this.edgeTextures_[3], 2);
        this.edgeTextures_[7] = BitmapUtil._c(this.edgeTextures_[3], 3);
        if (this.cornerData_ != null) {
            this.edgeTextures_[0] = this.cornerData_.getTexture(0);
            this.edgeTextures_[2] = BitmapUtil._c(this.edgeTextures_[0], 1);
            this.edgeTextures_[8] = BitmapUtil._c(this.edgeTextures_[0], 2);
            this.edgeTextures_[6] = BitmapUtil._c(this.edgeTextures_[0], 3);
        }
        return this.edgeTextures_;
    }

    /** Same grid as getEdgeTextures() but with inner-corner textures. Built lazily. */
    public function getInnerCornerTextures():Vector.<BitmapData> {
        if (this.innerCornerData_ == null || this.innerCornerTextures_ != null) {
            return this.innerCornerTextures_;
        }
        this.innerCornerTextures_ = this.edgeTextures_.concat();
        this.innerCornerTextures_[0] = this.innerCornerData_.getTexture(0);
        this.innerCornerTextures_[2] = BitmapUtil._c(this.innerCornerTextures_[0], 1);
        this.innerCornerTextures_[8] = BitmapUtil._c(this.innerCornerTextures_[0], 2);
        this.innerCornerTextures_[6] = BitmapUtil._c(this.innerCornerTextures_[0], 3);
        return this.innerCornerTextures_;
    }

}
}
