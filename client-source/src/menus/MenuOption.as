package menus
{
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.ui.SimpleText;
    import com.company.util.MoreColorUtil;
    import com.company.util.BitmapEffectCache;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.geom.ColorTransform;

    public class MenuOption extends Sprite
    {
        protected static const HOVER_TRANSFORM:ColorTransform = new ColorTransform(1, 220 / 0xFF, 133 / 0xFF);

        protected var icon_:BitmapData;
        protected var scaledIcon_:BitmapData;
        protected var iconBitmap_:Bitmap;
        protected var text_:SimpleText;
        protected var currentTransform_:ColorTransform = null;

        public function MenuOption(icon:BitmapData, textColor:uint, label:String)
        {
            this.icon_ = icon;
            this.scaledIcon_ = TextureRedrawer.redraw(icon, this.getIconScale(), true, 0, 0);
            this.iconBitmap_ = new Bitmap(this.scaledIcon_);
            this.iconBitmap_.filters = [new DropShadowFilter(0, 0, 0)];
            this.iconBitmap_.x = -12;
            this.iconBitmap_.y = -12;
            addChild(this.iconBitmap_);
            this.text_ = new SimpleText(18, textColor, false, 0, 0, "Myriad Pro");
            this.text_.setBold(true);
            this.text_.text = label;
            this.text_.updateMetrics();
            this.text_.filters = [new DropShadowFilter(0, 0, 0)];
            this.text_.x = 20;
            this.text_.y = -6;
            addChild(this.text_);
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }

        public function setColorTransform(transform:ColorTransform):void
        {
            var tinted:BitmapData;
            if (transform == this.currentTransform_)
            {
                return;
            }
            this.currentTransform_ = transform;
            if (this.currentTransform_ == null)
            {
                this.iconBitmap_.bitmapData = this.scaledIcon_;
                this.text_.transform.colorTransform = MoreColorUtil.identity;
            }
            else
            {
                tinted = BitmapEffectCache.getColorTransformed(this.icon_, this.currentTransform_);
                tinted = TextureRedrawer.redraw(tinted, this.getIconScale(), true, 0, 0);
                this.iconBitmap_.bitmapData = tinted;
                this.text_.transform.colorTransform = this.currentTransform_;
            }
        }

        protected function getIconScale():int
        {
            return 40 / (this.icon_.width / 8);
        }

        protected function onMouseOver(event:MouseEvent):void
        {
            this.setColorTransform(HOVER_TRANSFORM);
        }

        protected function onMouseOut(event:MouseEvent):void
        {
            this.setColorTransform(null);
        }
    }
}
