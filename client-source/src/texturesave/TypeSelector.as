package texturesave
{
    import com.company.ui.SimpleText;

    import flash.display.Sprite;
    import flash.filters.DropShadowFilter;

    public class TypeSelector extends Sprite
    {
        public static const HEIGHT:int = 88;

        public var nameText_:SimpleText;
        public var dropdown_:TypeDropdown;

        public function TypeSelector(types:Vector.<int>, selectedType:int)
        {
            this.dropdown_ = new TypeDropdown(types);
            this.dropdown_.selectType(selectedType);
            this.dropdown_.x = 80;
            addChild(this.dropdown_);

            this.nameText_ = new SimpleText(18, 0xB3B3B3, false, 0, 0, "Myriad Pro");
            this.nameText_.setBold(true);
            this.nameText_.text = "Type: ";
            this.nameText_.updateMetrics();
            this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.nameText_.y = (this.dropdown_.height / 2) - (this.nameText_.height / 2);
            addChild(this.nameText_);
        }

        public function getType():int
        {
            return this.dropdown_.getType();
        }
    }
}
