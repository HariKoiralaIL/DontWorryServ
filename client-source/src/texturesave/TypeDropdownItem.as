package texturesave
{
    import spriteeditor.TextureCategory;

    import com.company.ui.SimpleText;

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;

    public class TypeDropdownItem extends Sprite
    {
        public static const WIDTH:int = 260;
        public static const HEIGHT:int = 44;

        private static const COLOR_NORMAL:uint = 0x363636;
        private static const COLOR_HOVER:uint = 0x565656;

        public var type_:int = -1;
        private var nameText_:SimpleText;
        private var examplesText_:SimpleText;

        public function TypeDropdownItem(type:int)
        {
            this.type_ = type;
            var isInvalid:Boolean = (type == TextureCategory.INVALID);
            var typeName:String = isInvalid ? null : TextureCategory.CATEGORIES[type].name_;

            this.nameText_ = new SimpleText(16, 0xB3B3B3, false, 0, 0, "Myriad Pro");
            this.nameText_.setBold(true);
            this.nameText_.text = isInvalid ? "Select Type" : typeName;
            this.nameText_.updateMetrics();
            this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.nameText_.x = (WIDTH / 2) - (this.nameText_.width / 2);
            this.nameText_.y = 2;
            addChild(this.nameText_);

            if (typeName != null)
            {
                this.examplesText_ = new SimpleText(14, 0xB3B3B3, false, 0, 0, "Myriad Pro");
                this.examplesText_.text = TextureCategory.CATEGORIES[type].examples_;
                this.examplesText_.updateMetrics();
                this.examplesText_.filters = [new DropShadowFilter(0, 0, 0)];
                this.examplesText_.x = (WIDTH / 2) - (this.examplesText_.width / 2);
                this.examplesText_.y = 20;
                addChild(this.examplesText_);
            }
            else
            {
                this.nameText_.y = (HEIGHT / 2) - (this.nameText_.height / 2);
            }

            this.drawBackground(COLOR_NORMAL);
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }

        private function drawBackground(color:uint):void
        {
            graphics.clear();
            graphics.lineStyle(1, 0xB3B3B3);
            graphics.beginFill(color, 1);
            graphics.drawRect(0, 0, WIDTH, HEIGHT);
            graphics.endFill();
            graphics.lineStyle();
        }

        private function onMouseOver(event:MouseEvent):void
        {
            this.drawBackground(COLOR_HOVER);
        }

        private function onMouseOut(event:MouseEvent):void
        {
            this.drawBackground(COLOR_NORMAL);
        }
    }
}
