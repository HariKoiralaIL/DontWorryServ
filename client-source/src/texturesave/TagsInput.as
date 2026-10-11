package texturesave
{
    import com.company.ui.SimpleText;

    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.events.FocusEvent;
    import flash.filters.DropShadowFilter;

    public class TagsInput extends Sprite
    {
        public static const HEIGHT:int = 88;

        public var nameText_:SimpleText;
        public var inputText_:SimpleText;
        public var hintText_:SimpleText;

        public function TagsInput(tags:String)
        {
            this.nameText_ = new SimpleText(18, 0xB3B3B3, false, 0, 0, "Myriad Pro");
            this.nameText_.setBold(true);
            this.nameText_.text = "Tags: ";
            this.nameText_.updateMetrics();
            this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this.nameText_);

            this.inputText_ = new SimpleText(16, 0xB3B3B3, true, 260, 100, "Myriad Pro");
            this.inputText_.x = 80;
            this.inputText_.border = false;
            this.inputText_.maxChars = 0x0100;
            this.inputText_.multiline = true;
            this.inputText_.wordWrap = true;
            this.inputText_.restrict = "a-z0-9 ,";
            this.inputText_.updateMetrics();
            this.inputText_.text = tags;
            addChild(this.inputText_);

            graphics.lineStyle(2, 0x454545, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
            graphics.beginFill(0x333333, 1);
            graphics.drawRect(78, -2, 260, 100);
            graphics.endFill();
            graphics.lineStyle();

            this.inputText_.addEventListener(FocusEvent.FOCUS_IN, this.onFocusIn);
            this.inputText_.addEventListener(FocusEvent.FOCUS_OUT, this.onFocusOut);

            this.hintText_ = new SimpleText(14, 0x939393, false, 260, 0, "Myriad Pro");
            this.hintText_.htmlText = '<p align="center">comma-separated list of tags\n' + '(e.g. "elf, wizard, abyss of demons, \ncrunchy")' + "</p>";
            this.hintText_.updateMetrics();
            this.hintText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
            this.hintText_.x = 80;
            this.hintText_.y = 50 - (this.hintText_.height / 2);
            if (this.inputText_.text == "")
            {
                addChild(this.hintText_);
            }
        }

        public function text():String
        {
            return this.inputText_.text;
        }

        private function onFocusIn(event:FocusEvent):void
        {
            if (contains(this.hintText_))
            {
                removeChild(this.hintText_);
            }
        }

        private function onFocusOut(event:FocusEvent):void
        {
            if (!contains(this.hintText_) && this.inputText_.text == "")
            {
                addChild(this.hintText_);
            }
        }
    }
}
