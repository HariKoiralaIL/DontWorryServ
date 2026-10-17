package spriteeditor {
import flash.display.Sprite;

import flash.display.Bitmap;
import flash.display.BitmapData;

import com.company.ui.SimpleText;

import client.util.color.RGB;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.events.Event;

import client.util.color.HSV;

import com.company.util.MoreColorUtil;

/**
 * HSV color picker: a row of user-editable swatches, a fixed preset palette,
 * a hue/saturation field, a value (brightness) slider and a hex input.
 * Dispatches Event.CHANGE whenever the selected swatch's color changes.
 */
public class ColorPicker extends Sprite {

    private static const SWATCH_COLUMNS:int = 6;
    private static const SWATCH_ROWS:int = 2;
    private static const SWATCH_SIZE:int = 19;
    private static const SWATCH_SPACING:int = 8;
    private static const DEFAULT_SWATCH_COLORS:Vector.<uint> = new <uint>[16245355, 0, 0xFFFFFF, 7291927, 10839330, 12461619, 3389995, 5777425, 7113244, 0x980001, 4013116, 12873770, 15436081, 8805672, 0xEE0000, 7368395, 3252978, 10735143, 16383286, 13982555, 6969880, 12566461, 2534694, 7573493];

    private static const PALETTE_X:int = 172;
    private static const PALETTE_Y:int = 2;
    private static const FIELD_X:int = 380;
    private static const FIELD_WIDTH:int = 360;
    private static const FIELD_HEIGHT:int = 100;
    private static const SLIDER_X:int = 750;
    private static const SLIDER_WIDTH:int = 20;
    private static const SLIDER_HEIGHT:int = 100;
    private static const HEX_INPUT_Y:int = 60;

    private static var SelectionFrameClass:Class = SelectionFrameAsset;
    private static var FieldMarkerClass:Class = FieldMarkerAsset;
    private static var SliderMarkerClass:Class = SliderMarkerAsset;

    private var swatches_:Vector.<ColorSwatch>;
    private var selected_:ColorSwatch = null;
    private var selectionFrame_:Bitmap;
    private var palette_:ColorPalette;
    private var hueSaturationData_:BitmapData;
    private var hueSaturationField_:Sprite;
    private var fieldMarker_:Bitmap;
    private var valueStripData_:BitmapData;
    private var valueSlider_:Sprite;
    private var sliderMarker_:Bitmap;
    private var hexInput_:SimpleText;
    private var dragProxy_:Sprite = null;

    public function ColorPicker() {
        var bitmap:Bitmap;
        var col:int;
        var row:int;
        var rgbColor:RGB;
        var swatch:ColorSwatch;
        this.swatches_ = new Vector.<ColorSwatch>();
        super();
        col = 0;
        while (col < SWATCH_COLUMNS) {
            row = 0;
            while (row < SWATCH_ROWS) {
                rgbColor = RGB.fromHex(DEFAULT_SWATCH_COLORS[((row * SWATCH_COLUMNS) + col)]);
                swatch = new ColorSwatch(SWATCH_SIZE, rgbColor.toHSV(), false);
                swatch.x = (col * (SWATCH_SIZE + SWATCH_SPACING));
                swatch.y = (row * (SWATCH_SIZE + SWATCH_SPACING));
                addChild(swatch);
                swatch.addEventListener(MouseEvent.MOUSE_DOWN, this.onSwatchMouseDown);
                this.swatches_.push(swatch);
                row++;
            }
            col++;
        }
        this.selectionFrame_ = new SelectionFrameClass();
        addChild(this.selectionFrame_);
        this.palette_ = new ColorPalette();
        this.palette_.x = PALETTE_X;
        this.palette_.y = PALETTE_Y;
        this.palette_.addEventListener(ColorEvent.COLOR_EVENT, this.onPaletteColor);
        addChild(this.palette_);
        this.hueSaturationData_ = new BitmapData(FIELD_WIDTH, FIELD_HEIGHT, false, 0xFF0000);
        bitmap = new Bitmap(this.hueSaturationData_);
        this.hueSaturationField_ = new Sprite();
        this.hueSaturationField_.addChild(bitmap);
        this.hueSaturationField_.x = FIELD_X;
        addChild(this.hueSaturationField_);
        this.hueSaturationField_.addEventListener(MouseEvent.MOUSE_DOWN, this.onFieldMouseDown);
        this.fieldMarker_ = new FieldMarkerClass();
        this.hueSaturationField_.addChild(this.fieldMarker_);
        this.valueStripData_ = new BitmapData(1, SLIDER_HEIGHT, false, 0xFF00);
        bitmap = new Bitmap(this.valueStripData_);
        bitmap.width = SLIDER_WIDTH;
        this.valueSlider_ = new Sprite();
        this.valueSlider_.addChild(bitmap);
        this.valueSlider_.x = SLIDER_X;
        addChild(this.valueSlider_);
        this.valueSlider_.addEventListener(MouseEvent.MOUSE_DOWN, this.onValueMouseDown);
        this.sliderMarker_ = new SliderMarkerClass();
        this.sliderMarker_.x = -3;
        this.valueSlider_.addChild(this.sliderMarker_);
        this.hexInput_ = new SimpleText(18, 0xFFFFFF, true, 100, 26, "Myriad Pro");
        this.hexInput_.text = "FFFFFF";
        this.hexInput_.restrict = "0123456789aAbBcCdDeEfF";
        this.hexInput_.maxChars = 6;
        this.hexInput_._08S_();
        this.hexInput_.filters = [new DropShadowFilter(0, 0, 0)];
        this.hexInput_.y = HEX_INPUT_Y;
        this.hexInput_.x = ((154 / 2) - (this.hexInput_.width / 2));
        this.hexInput_.addEventListener(Event.CHANGE, this.onHexTextChange);
        addChild(this.hexInput_);
        this.setSelected(this.swatches_[0]);
    }

    public function getColor():HSV {
        return (this.selected_.color_);
    }

    public function setColor(color:HSV):void {
        this.updateColor(color.h, color.s, color.v);
    }

    private function setSelected(swatch:ColorSwatch):void {
        this.selected_ = swatch;
        this.selectionFrame_.x = this.selected_.x - 1;
        this.selectionFrame_.y = this.selected_.y - 1;
        this.redrawHueSaturationField();
        this.redrawValueStrip();
        this.positionMarkers();
        this.updateHexText();
        dispatchEvent(new Event(Event.CHANGE));
    }

    /** Applies an HSV color to the selected swatch and redraws only the parts that depend on what changed. */
    private function updateColor(hue:Number, saturation:Number, value:Number):void {
        var newColor:HSV = new HSV(hue, saturation, value);
        var hueOrSaturationChanged:Boolean = ((newColor.h != this.selected_.color_.h) || (newColor.s != this.selected_.color_.s));
        var valueChanged:Boolean = (newColor.v != this.selected_.color_.v);
        this.selected_.setColor(newColor);
        if (valueChanged) {
            this.redrawHueSaturationField();
        }
        if (hueOrSaturationChanged) {
            this.redrawValueStrip();
        }
        this.positionMarkers();
        this.updateHexText();
        dispatchEvent(new Event(Event.CHANGE));
    }

    /** Does not overwrite the text while the user is typing in it. */
    private function updateHexText():void {
        if (((!((stage == null))) && ((stage.focus == this.hexInput_)))) {
            return;
        }
        this.hexInput_.text = this.selected_.color_.toRGB().toString();
    }

    /** The hue/saturation field is drawn at the selected color's current value (brightness). */
    private function redrawHueSaturationField():void {
        var y:int;
        var rgb:uint;
        var x:int;
        while (x < this.hueSaturationData_.width) {
            y = 0;
            while (y < this.hueSaturationData_.height) {
                rgb = MoreColorUtil.hsvToRgb(x, ((this.hueSaturationData_.height - y) / this.hueSaturationData_.height), this.selected_.color_.v);
                this.hueSaturationData_.setPixel(x, y, rgb);
                y++;
            }
            x++;
        }
    }

    /** The value strip is drawn at the selected color's current hue and saturation. */
    private function redrawValueStrip():void {
        var rgb:uint;
        var y:int;
        while (y < this.valueStripData_.height) {
            rgb = MoreColorUtil.hsvToRgb(this.selected_.color_.h, this.selected_.color_.s, ((this.valueStripData_.height - y) / this.valueStripData_.height));
            this.valueStripData_.setPixel(0, y, rgb);
            y++;
        }
    }

    private function positionMarkers():void {
        this.fieldMarker_.x = (this.selected_.color_.h - int((this.fieldMarker_.width / 2)));
        this.fieldMarker_.y = (((1 - this.selected_.color_.s) * this.hueSaturationData_.height) - int((this.fieldMarker_.height / 2)));
        this.sliderMarker_.y = (((1 - this.selected_.color_.v) * this.valueStripData_.height) - int((this.sliderMarker_.height / 2)));
    }

    private function updateFromField():void {
        this.updateColor(this.hueSaturationField_.mouseX, ((this.hueSaturationField_.height - this.hueSaturationField_.mouseY) / FIELD_HEIGHT), this.selected_.color_.v);
    }

    private function updateFromValueSlider():void {
        this.updateColor(this.selected_.color_.h, this.selected_.color_.s, ((this.valueSlider_.height - this.valueSlider_.mouseY) / SLIDER_HEIGHT));
    }

    private function onPaletteColor(event:ColorEvent):void {
        this.setColor(event.color_);
    }

    private function onSwatchMouseDown(event:MouseEvent):void {
        var swatch:ColorSwatch = (event.target as ColorSwatch);
        this.setSelected(swatch);
        var proxySwatch:ColorSwatch = new ColorSwatch((SWATCH_SIZE / 2), swatch.color_, true);
        proxySwatch.x = (-(proxySwatch.width) / 2);
        proxySwatch.y = (-(proxySwatch.height) / 2);
        this.dragProxy_ = new Sprite();
        this.dragProxy_.addChild(proxySwatch);
        stage.addEventListener(MouseEvent.MOUSE_UP, this.onDragMouseUp);
        stage.addChild(this.dragProxy_);
        this.dragProxy_.startDrag(true, null);
    }

    /** Dropping a dragged swatch onto another swatch copies its color there. */
    private function onDragMouseUp(event:MouseEvent):void {
        this.dragProxy_.stopDrag();
        this.dragProxy_.parent.removeChild(this.dragProxy_);
        stage.removeEventListener(MouseEvent.MOUSE_UP, this.onDragMouseUp);
        var dropTarget:ColorSwatch = (this.dragProxy_.dropTarget as ColorSwatch);
        this.dragProxy_ = null;
        var source:ColorSwatch = (event.target as ColorSwatch);
        if ((((dropTarget == null)) || ((source == null)))) {
            return;
        }
        dropTarget.setColor(source.color_);
    }

    private function onHexTextChange(event:Event):void {
        this.setColor(RGB.fromHex(uint(("0x" + this.hexInput_.text))).toHSV());
    }

    private function onFieldMouseDown(event:MouseEvent):void {
        this.updateFromField();
        stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onFieldMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_UP, this.onFieldMouseUp);
    }

    private function onFieldMouseMove(event:MouseEvent):void {
        this.updateFromField();
    }

    private function onFieldMouseUp(event:MouseEvent):void {
        this.updateFromField();
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onFieldMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, this.onFieldMouseUp);
    }

    private function onValueMouseDown(event:MouseEvent):void {
        this.updateFromValueSlider();
        stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onValueMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_UP, this.onValueMouseUp);
    }

    private function onValueMouseMove(event:MouseEvent):void {
        this.updateFromValueSlider();
    }

    private function onValueMouseUp(event:MouseEvent):void {
        this.updateFromValueSlider();
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onValueMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, this.onValueMouseUp);
    }

}
}//package spriteeditor
