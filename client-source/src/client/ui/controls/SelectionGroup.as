package client.ui.controls {

/** Keeps at most one item of a set selected at a time (radio-button behaviour). */
public class SelectionGroup {

    private var items:Vector.<ISelectableItem>;
    private var selected:ISelectableItem;

    public function SelectionGroup(items:Vector.<ISelectableItem>) {
        this.items = items;
    }

    /** Selects the first item whose value matches; does nothing if none match. */
    public function setSelected(value:String):void {
        var item:ISelectableItem;
        for each (item in items) {
            if (item.getValue() == value) {
                selectItem(item);
                return;
            }
        }
    }

    public function getSelected():ISelectableItem {
        return selected;
    }

    private function selectItem(item:ISelectableItem):void {
        if (selected != null) {
            selected.setSelected(false);
        }
        selected = item;
        selected.setSelected(true);
    }

}
}
