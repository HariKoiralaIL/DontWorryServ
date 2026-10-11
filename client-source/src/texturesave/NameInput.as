package texturesave
{
    import com.company.ui.SimpleText;

    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.filters.DropShadowFilter;

    public class NameInput extends Sprite
    {
        public static const HEIGHT:int = 88;

        public var nameText_:SimpleText;
        public var inputText_:SimpleText;
        public var errorText_:SimpleText;

        public function NameInput(name:String)
        {
            this.nameText_ = new SimpleText(18, 0xB3B3B3, false, 0, 0, "Myriad Pro");
            this.nameText_.setBold(true);
            this.nameText_.text = "Name: ";
            this.nameText_.updateMetrics();
            this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this.nameText_);

            this.inputText_ = new SimpleText(20, 0xB3B3B3, true, 260, 30, "Myriad Pro");
            this.inputText_.x = 80;
            this.inputText_.border = false;
            this.inputText_.maxChars = 32;
            this.inputText_.restrict = "a-zA-Z0-9 ";
            this.inputText_.updateMetrics();
            this.inputText_.text = name;
            addChild(this.inputText_);

            graphics.lineStyle(2, 0x454545, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
            graphics.beginFill(0x333333, 1);
            graphics.drawRect(78, -2, 260, 30);
            graphics.endFill();
            graphics.lineStyle();
        }

        public function text():String
        {
            return this.inputText_.text;
        }
    }
}
