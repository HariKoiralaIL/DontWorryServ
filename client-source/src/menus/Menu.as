package menus
{
    import com.company.util.GraphicHelper;
    import com.company.util.RectUtil;

    import flash.display.CapsStyle;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsData;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.geom.Rectangle;

    public class Menu extends Sprite
    {
        private static const SCREEN_WIDTH:int = 800;
        private static const SCREEN_HEIGHT:int = 600;

        private var graphicsData_:Vector.<IGraphicsData>;
        private var backgroundColor_:uint;
        private var outlineColor_:uint;
        private var nextOptionY_:int;
        private var backgroundFill_:GraphicsSolidFill;
        private var outlineFill_:GraphicsSolidFill;
        private var outlineStroke_:GraphicsStroke;
        private var path_:GraphicsPath;

        public function Menu(backgroundColor:uint, outlineColor:uint)
        {
            this.backgroundFill_ = new GraphicsSolidFill(0, 1);
            this.outlineFill_ = new GraphicsSolidFill(0, 1);
            this.outlineStroke_ = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
            this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            this.graphicsData_ = new <IGraphicsData>[this.outlineStroke_, this.backgroundFill_, this.path_, GraphicHelper.END_FILL, GraphicHelper.NO_STROKE];
            super();
            this.backgroundColor_ = backgroundColor;
            this.outlineColor_ = outlineColor;
            this.nextOptionY_ = 40;
            filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16)];
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        protected function addOption(option:MenuOption):void
        {
            option.x = 8;
            option.y = this.nextOptionY_;
            addChild(option);
            this.nextOptionY_ += 28;
        }

        protected function remove():void
        {
            if (parent != null)
            {
                parent.removeChild(this);
            }
        }

        protected function draw():void
        {
            this.backgroundFill_.color = this.backgroundColor_;
            this.outlineFill_.color = this.outlineColor_;
            graphics.clear();
            GraphicHelper.clearPath(this.path_);
            GraphicHelper.drawUI(-6, -6, Math.max(154, width + 12), height + 12, 4, [1, 1, 1, 1], this.path_);
            graphics.drawGraphicsData(this.graphicsData_);
        }

        protected function onAddedToStage(event:Event):void
        {
            this.draw();
            this.position();
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        }

        protected function onRemovedFromStage(event:Event):void
        {
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            removeEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        }

        protected function onEnterFrame(event:Event):void
        {
            if (stage == null)
            {
                return;
            }
            var bounds:Rectangle = getRect(stage);
            var distance:Number = RectUtil.distanceToPoint(bounds, stage.mouseX, stage.mouseY);
            if (distance > 40)
            {
                this.remove();
            }
        }

        protected function onRollOut(event:Event):void
        {
            this.remove();
        }

        private function position():void
        {
            if (stage == null)
            {
                return;
            }
            if (stage.mouseX < SCREEN_WIDTH / 2)
            {
                x = stage.mouseX + 12;
            }
            else
            {
                x = stage.mouseX - width - 1;
            }
            if (x < 12)
            {
                x = 12;
            }
            if (stage.mouseY < SCREEN_HEIGHT / 3)
            {
                y = stage.mouseY + 12;
            }
            else
            {
                y = stage.mouseY - height - 1;
            }
        }
    }
}
