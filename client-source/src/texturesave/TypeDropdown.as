package texturesave
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class TypeDropdown extends Sprite
    {
        public var items_:Vector.<TypeDropdownItem> = new Vector.<TypeDropdownItem>();
        public var selected_:TypeDropdownItem;

        public function TypeDropdown(types:Vector.<int>)
        {
            super();
            for each (var type:int in types)
            {
                this.items_.push(new TypeDropdownItem(type));
            }
            this.setSelected(this.items_[0]);
        }

        public function selectType(type:int):void
        {
            for each (var item:TypeDropdownItem in this.items_)
            {
                if (item.type_ == type)
                {
                    this.setSelected(item);
                }
            }
        }

        public function getType():int
        {
            return this.selected_.type_;
        }

        private function clearSelected():void
        {
            if (this.selected_ != null)
            {
                if (contains(this.selected_))
                {
                    removeChild(this.selected_);
                }
                this.selected_.removeEventListener(MouseEvent.MOUSE_DOWN, this.onSelectedMouseDown);
            }
        }

        private function setSelected(item:TypeDropdownItem):void
        {
            this.clearSelected();
            this.selected_ = item;
            this.selected_.y = 0;
            addChild(this.selected_);
            this.selected_.addEventListener(MouseEvent.MOUSE_DOWN, this.onSelectedMouseDown);
        }

        private function expand():void
        {
            var offsetY:int = 0;
            for each (var item:TypeDropdownItem in this.items_)
            {
                item.addEventListener(MouseEvent.MOUSE_DOWN, this.onItemMouseDown);
                item.y = offsetY;
                addChild(item);
                offsetY += TypeDropdownItem.HEIGHT;
            }
        }

        private function collapse():void
        {
            for each (var item:TypeDropdownItem in this.items_)
            {
                item.removeEventListener(MouseEvent.MOUSE_DOWN, this.onItemMouseDown);
                removeChild(item);
            }
        }

        private function onSelectedMouseDown(event:MouseEvent):void
        {
            if (this.items_.length == 1)
            {
                return;
            }
            this.clearSelected();
            this.expand();
        }

        private function onItemMouseDown(event:MouseEvent):void
        {
            this.collapse();
            this.setSelected(event.target as TypeDropdownItem);
            dispatchEvent(new Event(Event.CHANGE));
        }
    }
}
