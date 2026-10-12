package mapoverlay {
import com.company.assembleegameclient.map.GameCamera;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.GraphicHelper;

import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * Speech bubble shown above a game object for a limited time.
 */
public class SpeechBalloon extends Sprite implements IMapOverlayElement {

    private static const FONT:String = "Myriad Pro";
    private static const FONT_SIZE:int = 14;
    private static const TEXT_WIDTH:int = 150;
    private static const TEXT_PADDING:int = 4;

    private static const BOX_PADDING:int = 6;
    private static const BOX_CORNER_RADIUS:int = 4;
    private static const OUTLINE_THICKNESS:int = 2;

    private static const TAIL_HALF_WIDTH:int = 8;
    private static const TAIL_BASE_OFFSET:int = 6;
    private static const TAIL_TIP_OFFSET:int = 18;
    private static const TAIL_COMMAND_INDEX:int = 6;
    private static const TAIL_DATA_INDEX:int = 12;

    private static const OBJECT_HEIGHT_FACTOR:int = 5;
    private static const OFFSET_MARGIN:int = 2;

    public var go_:GameObject;
    public var lifetime_:int;
    public var hideable:Boolean;
    public var offset:Point;
    public var text_:TextField;
    private var graphicsData_:Vector.<IGraphicsData>;
    private var backgroundFill:GraphicsSolidFill;
    private var outlineFill_:GraphicsSolidFill;
    private var outlineStroke:GraphicsStroke;
    private var path_:GraphicsPath;
    private var startTime_:int = 0;

    /**
     * @param lifetimeSeconds how long the balloon stays, in seconds
     * @param hideable        if true, the balloon is hidden when the
     *                        "text bubbles" option is turned off
     */
    public function SpeechBalloon(go:GameObject, text:String, backgroundColor:uint, backgroundAlpha:Number,
                                  outlineColor:uint, outlineAlpha:Number, textColor:uint,
                                  lifetimeSeconds:int, bold:Boolean, hideable:Boolean) {
        this.offset = new Point();
        this.backgroundFill = new GraphicsSolidFill(0, 1);
        this.outlineFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
        this.outlineStroke = new GraphicsStroke(OUTLINE_THICKNESS, false, LineScaleMode.NORMAL, CapsStyle.NONE,
                JointStyle.ROUND, 3, this.outlineFill_);
        this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[this.outlineStroke, this.backgroundFill, this.path_,
            GraphicHelper.END_FILL, GraphicHelper._H_B_];
        mouseEnabled = false;
        mouseChildren = false;
        this.go_ = go;
        this.lifetime_ = (lifetimeSeconds * 1000);
        this.hideable = hideable;
        createTextField(text, textColor, bold);
        var bubbleWidth:int = (this.text_.textWidth + TEXT_PADDING);
        this.offset.x = (-(bubbleWidth) / 2);
        this.backgroundFill.color = backgroundColor;
        this.backgroundFill.alpha = backgroundAlpha;
        this.outlineFill_.color = outlineColor;
        this.outlineFill_.alpha = outlineAlpha;
        drawBubble(bubbleWidth);
        filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16)];
        // height now includes the bubble padding and tail
        this.offset.y = ((-(height) - ((this.go_.texture_.height * (go.size_ / 100)) * OBJECT_HEIGHT_FACTOR))
                - OFFSET_MARGIN);
        visible = false;
    }

    public function draw(camera:GameCamera, time:int):Boolean {
        if (this.startTime_ == 0) {
            this.startTime_ = time;
        }
        var elapsed:int = (time - this.startTime_);
        if (elapsed > this.lifetime_ || (this.go_ != null && this.go_.map_ == null)) {
            return false;
        }
        if (this.go_ == null || !this.go_._1D_) {
            visible = false;
            return true;
        }
        if (this.hideable && !Parameters.data_.textBubbles) {
            visible = false;
            return true;
        }
        visible = true;
        x = int((this.go_._bY_[0] + this.offset.x));
        y = int((this.go_._bY_[1] + this.offset.y));
        return true;
    }

    private function createTextField(text:String, textColor:uint, bold:Boolean):void {
        this.text_ = new TextField();
        this.text_.autoSize = TextFieldAutoSize.LEFT;
        this.text_.embedFonts = true; // CHANGED - was true, changed to false so that text shows (there is a problem with embeded fonts)
        this.text_.width = TEXT_WIDTH;
        var format:TextFormat = new TextFormat();
        format.font = FONT;
        format.size = FONT_SIZE;
        format.bold = bold;
        format.color = textColor;
        this.text_.defaultTextFormat = format;
        this.text_.selectable = false;
        this.text_.mouseEnabled = false;
        this.text_.multiline = true;
        this.text_.wordWrap = true;
        this.text_.text = text;
        addChild(this.text_);
    }

    private function drawBubble(bubbleWidth:int):void {
        graphics.clear();
        GraphicHelper._0L_6(this.path_);
        GraphicHelper.drawUI(-BOX_PADDING, -BOX_PADDING, (bubbleWidth + (BOX_PADDING * 2)),
                (height + (BOX_PADDING * 2)), BOX_CORNER_RADIUS, [1, 1, 1, 1], this.path_);
        // insert the speech tail (three extra points) into the rounded rectangle path
        this.path_.commands.splice(TAIL_COMMAND_INDEX, 0, GraphicsPathCommand.LINE_TO,
                GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO);
        var textHeight:int = height;
        this.path_.data.splice(TAIL_DATA_INDEX, 0,
                ((bubbleWidth / 2) + TAIL_HALF_WIDTH), (textHeight + TAIL_BASE_OFFSET),
                (bubbleWidth / 2), (textHeight + TAIL_TIP_OFFSET),
                ((bubbleWidth / 2) - TAIL_HALF_WIDTH), (textHeight + TAIL_BASE_OFFSET));
        graphics.drawGraphicsData(this.graphicsData_);
    }
}
}
