package arrows
{
    import menus.Menu;

    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    import com.company.util.Trig;
    import com.company.util._E_I_;

    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class ScreenArrow extends Sprite
    {
        public static const SMALL_SIZE:int = 8;
        public static const BIG_SIZE:int = 11;
        public static const CENTER_OFFSET:int = 3;

        private static var openMenu_:Menu = null;

        public var lineColor_:uint;
        public var fillColor_:uint;
        public var go_:GameObject = null;
        public var extraObjects_:Vector.<GameObject> = new Vector.<GameObject>();
        public var isMouseOver_:Boolean = false;
        protected var toolTip_:ToolTip = null;
        private var alwaysBig_:Boolean;
        private var arrowShape_:Shape = new Shape();
        private var screenPoint_:Point = new Point();

        public function ScreenArrow(lineColor:uint, fillColor:uint, alwaysBig:Boolean)
        {
            super();
            this.lineColor_ = lineColor;
            this.fillColor_ = fillColor;
            this.alwaysBig_ = alwaysBig;
            addChild(this.arrowShape_);
            this.drawArrow();
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            visible = false;
        }

        public static function closeOpenMenu():void
        {
            if (openMenu_ != null)
            {
                if (openMenu_.parent != null)
                {
                    openMenu_.parent.removeChild(openMenu_);
                }
                openMenu_ = null;
            }
        }

        public function setGameObject(go:GameObject):void
        {
            if (this.go_ != go)
            {
                this.go_ = go;
            }
            this.extraObjects_.length = 0;
            if (this.go_ == null)
            {
                visible = false;
            }
        }

        public function addExtraObject(go:GameObject):void
        {
            this.extraObjects_.push(go);
        }

        public function draw(time:int, camera:GameCamera):void
        {
            if (this.go_ == null)
            {
                visible = false;
                return;
            }
            this.go_._0E_T_(camera);
            var bounds:Rectangle = camera.clipRect_;
            var dx:Number = this.go_._bY_[0];
            var dy:Number = this.go_._bY_[1];
            if (!_E_I_._S_1(camera.clipRect_, 0, 0, dx, dy, this.screenPoint_))
            {
                this.go_ = null;
                visible = false;
                return;
            }
            x = this.screenPoint_.x;
            y = this.screenPoint_.y;
            var angle:Number = Trig._S_C_(270 - (Trig._G_Q_ * Math.atan2(dx, dy)));
            if (this.screenPoint_.x < bounds.left + 5)
            {
                if (angle > 45)
                {
                    angle = 45;
                }
                if (angle < -45)
                {
                    angle = -45;
                }
            }
            else if (this.screenPoint_.x > bounds.right - 5)
            {
                if (angle > 0)
                {
                    if (angle < 135)
                    {
                        angle = 135;
                    }
                }
                else if (angle > -135)
                {
                    angle = -135;
                }
            }
            if (this.screenPoint_.y < bounds.top + 5)
            {
                if (angle < 45)
                {
                    angle = 45;
                }
                if (angle > 135)
                {
                    angle = 135;
                }
            }
            else if (this.screenPoint_.y > bounds.bottom - 5)
            {
                if (angle > -45)
                {
                    angle = -45;
                }
                if (angle < -135)
                {
                    angle = -135;
                }
            }
            this.arrowShape_.rotation = angle;
            if (this.toolTip_ != null)
            {
                this.positionToolTip(this.toolTip_);
            }
            visible = true;
        }

        protected function setToolTip(toolTip:ToolTip):void
        {
            this.removeToolTip();
            this.toolTip_ = toolTip;
            if (this.toolTip_ != null)
            {
                addChild(this.toolTip_);
                this.positionToolTip(this.toolTip_);
            }
        }

        protected function removeToolTip():void
        {
            if (this.toolTip_ != null)
            {
                if (this.toolTip_.parent != null)
                {
                    this.toolTip_.parent.removeChild(this.toolTip_);
                }
                this.toolTip_ = null;
            }
        }

        protected function showMenu(menu:Menu):void
        {
            this.removeToolTip();
            openMenu_ = menu;
            stage.addChild(openMenu_);
        }

        protected function onMouseOver(event:MouseEvent):void
        {
            this.isMouseOver_ = true;
            this.drawArrow();
        }

        protected function onMouseOut(event:MouseEvent):void
        {
            this.isMouseOver_ = false;
            this.drawArrow();
        }

        protected function onMouseDown(event:MouseEvent):void
        {
            event.stopImmediatePropagation();
        }

        private function positionToolTip(toolTip:ToolTip):void
        {
            var tmp:Number;
            var angle:Number = this.arrowShape_.rotation;
            var distance:int = CENTER_OFFSET + BIG_SIZE + 12;
            var offsetX:Number = distance * Math.cos(angle * Trig._km);
            var offsetY:Number = distance * Math.sin(angle * Trig._km);
            var width:Number = toolTip.contentWidth_;
            var height:Number = toolTip.contentHeight_;
            if (angle >= 45 && angle <= 135)
            {
                tmp = offsetX + (width / Math.tan(angle * Trig._km));
                toolTip.x = ((offsetX + tmp) / 2) - (width / 2);
                toolTip.y = offsetY;
            }
            else if (angle <= -45 && angle >= -135)
            {
                tmp = offsetX - (width / Math.tan(angle * Trig._km));
                toolTip.x = ((offsetX + tmp) / 2) - (width / 2);
                toolTip.y = offsetY - height;
            }
            else if (angle < 45 && angle > -45)
            {
                toolTip.x = offsetX;
                tmp = offsetY + (height * Math.tan(angle * Trig._km));
                toolTip.y = ((offsetY + tmp) / 2) - (height / 2);
            }
            else
            {
                toolTip.x = offsetX - width;
                tmp = offsetY - (height * Math.tan(angle * Trig._km));
                toolTip.y = ((offsetY + tmp) / 2) - (height / 2);
            }
        }

        private function drawArrow():void
        {
            var g:Graphics = this.arrowShape_.graphics;
            g.clear();
            var size:int = (this.alwaysBig_ || this.isMouseOver_) ? BIG_SIZE : SMALL_SIZE;
            g.lineStyle(1, this.lineColor_);
            g.beginFill(this.fillColor_);
            g.moveTo(CENTER_OFFSET, 0);
            g.lineTo(size + CENTER_OFFSET, size);
            g.lineTo(size + CENTER_OFFSET, -size);
            g.lineTo(CENTER_OFFSET, 0);
            g.endFill();
            g.lineStyle();
        }
    }
}
