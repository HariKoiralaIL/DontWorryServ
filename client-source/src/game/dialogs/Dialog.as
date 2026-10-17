package game.dialogs {
    import com.company.assembleegameclient.ui._7f;
    import com.company.assembleegameclient.util.StageEventDispatcher;
    import com.company.ui.SimpleText;
    import com.company.util.GraphicHelper;

    import flash.display.CapsStyle;
    import flash.display.Graphics;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsData;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.text.TextFieldAutoSize;

    /** Base modal dialog: dimmed overlay, title, message and up to two buttons. */
    public class Dialog extends Sprite {

        public static const BUTTON1_EVENT:String = "DIALOG_BUTTON1";
        public static const BUTTON2_EVENT:String = "DIALOG_BUTTON2";

        private static const WIDTH:int = 300;
        private static const STAGE_WIDTH:int = 800;
        private static const STAGE_HEIGHT:int = 600;
        private static const FONT:String = "Myriad Pro";
        private static const MESSAGE_COLOR:uint = 0xB3B3B3;
        private static const TITLE_COLOR:uint = 0x57AD62;

        public var eventDispatch:StageEventDispatcher;

        protected var overlay_:Shape;
        protected var box_:Sprite;
        protected var rect_:Shape;
        protected var messageText_:SimpleText;
        protected var titleText_:SimpleText = null;
        protected var button1_:_7f = null;
        protected var button2_:_7f = null;
        /** Reserved for pageview tracking (currently disabled). */
        protected var analyticsPage_:String = null;

        private var graphicsData_:Vector.<IGraphicsData>;
        private var outlineFill_:GraphicsSolidFill;
        private var outlineStroke_:GraphicsStroke;
        private var backgroundFill_:GraphicsSolidFill;
        private var path_:GraphicsPath;

        public function Dialog(message:String, title:String, button1Label:String, button2Label:String, analyticsPage:String) {
            super();
            this.box_ = new Sprite();
            this.outlineFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
            this.outlineStroke_ = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
            this.backgroundFill_ = new GraphicsSolidFill(0x2A2A2A, 1);
            this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            this.graphicsData_ = new <IGraphicsData>[this.outlineStroke_, this.backgroundFill_, this.path_, GraphicHelper.END_FILL, GraphicHelper.NO_STROKE];
            this.analyticsPage_ = analyticsPage;

            this.messageText_ = new SimpleText(14, MESSAGE_COLOR, false, (WIDTH - 40), 0, FONT);
            this.messageText_.x = 20;
            this.messageText_.multiline = true;
            this.messageText_.wordWrap = true;
            this.messageText_.htmlText = centered(message);
            this.messageText_.autoSize = TextFieldAutoSize.CENTER;
            this.messageText_.mouseEnabled = true;
            this.messageText_.updateMetrics();
            this.messageText_.filters = [new DropShadowFilter(0, 0, 0, 1, 6, 6, 1)];

            if (title != null) {
                this.titleText_ = new SimpleText(18, TITLE_COLOR, false, WIDTH, 0, FONT);
                this.titleText_.setBold(true);
                this.titleText_.htmlText = centered(title);
                this.titleText_.updateMetrics();
                this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
            }
            if (button1Label != null) {
                this.button1_ = new _7f(16, button1Label, 120);
                this.button1_.addEventListener(MouseEvent.CLICK, this.onButton1Click);
            }
            if (button2Label != null) {
                this.button2_ = new _7f(16, button2Label, 120);
                this.button2_.addEventListener(MouseEvent.CLICK, this.onButton2Click);
            }
            this.draw();
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        }

        /** Removes the dialog from its parent, if it has one. */
        protected function close():void {
            if (this.parent != null) {
                this.parent.removeChild(this);
            }
        }

        private function centered(text:String):String {
            return '<p align="center">' + text + "</p>";
        }

        private function draw():void {
            var buttonY:int;
            if (this.titleText_ != null) {
                this.titleText_.y = 2;
                this.box_.addChild(this.titleText_);
                this.messageText_.y = (this.box_.height + 8);
            } else {
                this.messageText_.y = 4;
            }
            this.box_.addChild(this.messageText_);
            if (this.button1_ != null) {
                buttonY = (this.box_.height + 16);
                this.box_.addChild(this.button1_);
                this.button1_.y = buttonY;
                if (this.button2_ == null) {
                    this.button1_.x = ((WIDTH / 2) - (this.button1_.width / 2));
                } else {
                    this.button1_.x = ((WIDTH / 4) - (this.button1_.width / 2));
                    this.box_.addChild(this.button2_);
                    this.button2_.x = (((3 * WIDTH) / 4) - (this.button2_.width / 2));
                    this.button2_.y = buttonY;
                }
            }
            GraphicHelper.clearPath(this.path_);
            GraphicHelper.drawUI(0, 0, WIDTH, (this.box_.height + 10), 4, [1, 1, 1, 1], this.path_);
            this.rect_ = new Shape();
            this.rect_.graphics.drawGraphicsData(this.graphicsData_);
            this.box_.addChildAt(this.rect_, 0);
            this.box_.filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16, 1)];
            addChild(this.box_);
            this.overlay_ = new Shape();
        }

        private function onAddedToStage(e:Event):void {
            this.box_.x = ((STAGE_WIDTH / 2) - (this.box_.width / 2));
            this.box_.y = ((STAGE_HEIGHT / 2) - (this.box_.height / 2));
            var g:Graphics = this.overlay_.graphics;
            g.clear();
            g.beginFill(0, 0.8);
            g.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
            g.endFill();
            addChildAt(this.overlay_, 0);
        }

        private function onButton1Click(e:MouseEvent):void {
            dispatchEvent(new Event(BUTTON1_EVENT));
        }

        private function onButton2Click(e:MouseEvent):void {
            dispatchEvent(new Event(BUTTON2_EVENT));
        }
    }
}
