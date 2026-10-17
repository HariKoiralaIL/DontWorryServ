package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.ui.SimpleText;
import com.company.util.DisplayUtil;
import com.company.util.GraphicHelper;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;

/**
 * A slot inside the trade / item-select window. Shows an item, can be marked
 * as "included" in the trade (highlighted outline) and is greyed out when the
 * item is not tradeable.
 *
 * Formerly: _2j
 */
public class TradeSlot extends Slot {

    private static const DOSE_TEXT_MATRIX:Matrix = createDoseTextMatrix();

    private static const OUTLINE_COLOR:uint = 0xFEFE8E;
    private static const INCLUDED_FILL_COLOR:uint = 0xFFCD57;
    private static const EXCLUDED_FILL_COLOR:uint = 0x4C4C4C;

    private static function createDoseTextMatrix():Matrix {
        var matrix:Matrix = new Matrix();
        matrix.translate(10, 5);
        return matrix;
    }

    public var id:uint;
    public var item_:int;
    public var data_:Object;
    /** Whether the item may be traded; formerly _var. */
    public var tradeable_:Boolean;
    public var included_:Boolean;
    /** Formerly _0L_K_ */
    public var itemBitmap_:Bitmap;
    /** Outline drawn around the slot while it is included; formerly _k5. */
    public var outline_:Shape;

    private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(OUTLINE_COLOR, 1);
    private var outlineStroke_:GraphicsStroke = new GraphicsStroke(2, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, outlineFill_);
    private var outlinePath_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[outlineStroke_, outlinePath_, GraphicHelper.NO_STROKE];

    public function TradeSlot(item:int, tradeable:Boolean, included:Boolean, slotType:int, hotkeyNumber:int, corners:Array, id:uint, data:Object) {
        super(slotType, hotkeyNumber, corners);
        this.id = id;
        this.item_ = item;
        this.tradeable_ = tradeable;
        this.included_ = included;
        this.data_ = data;
        if (this.item_ != -1) {
            this.showItem();
        }
        if (!this.tradeable_) {
            transform.colorTransform = MoreColorUtil.GRAY_40;
        }
        this.outline_ = this.createOutline();
        addChild(this.outline_);
        this.setIncluded(included);
    }

    public function setIncluded(included:Boolean):void {
        this.included_ = included;
        this.outline_.visible = this.included_;
        this.fill_.color = this.included_ ? INCLUDED_FILL_COLOR : EXCLUDED_FILL_COLOR;
        this.redraw();
    }

    private function showItem():void {
        DisplayUtil.safeRemoveChild(this, emptyIcon_);
        var texture:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.item_, 80, true);
        if (this.data_ != null && this.data_.hasOwnProperty("TextureFile") && this.data_.TextureFile != "") {
            texture = ObjectLibrary.getRedrawnTextureFromTypeCustom(this.item_, 80, true, this.data_);
        }
        var itemXml:XML = ObjectLibrary.typeToXML_[this.item_];
        if (itemXml.hasOwnProperty("Doses")) {
            texture = texture.clone();
            var doseText:SimpleText = new SimpleText(12, 0xFFFFFF, false, 0, 0, "Myriad Pro");
            doseText.text = String(itemXml.Doses);
            doseText.updateMetrics();
            texture.draw(doseText, DOSE_TEXT_MATRIX);
        }
        var offset:Point = getIconOffset(this.item_, type_, false);
        this.itemBitmap_ = new Bitmap(texture);
        this.itemBitmap_.x = ((WIDTH / 2) - (this.itemBitmap_.width / 2)) + offset.x;
        this.itemBitmap_.y = ((HEIGHT / 2) - (this.itemBitmap_.height / 2)) + offset.y;
        DisplayUtil.safeAddChild(this, this.itemBitmap_);
    }

    private function createOutline():Shape {
        var shape:Shape = new Shape();
        GraphicHelper.clearPath(this.outlinePath_);
        GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, 4, corners_, this.outlinePath_);
        shape.graphics.drawGraphicsData(this.graphicsData_);
        return shape;
    }
}
}
