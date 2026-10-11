package spriteeditor {
import com.company.ui.dropdown.DropdownBox;

import com.company.util.IntPoint;

/** Dropdown of canvas sizes ("W x H"). Subclasses supply the list of sizes. */
public class SizeDropdown extends DropdownBox {

    protected var sizes_:Vector.<IntPoint>;

    public function SizeDropdown(sizes:Vector.<IntPoint>) {
        var size:IntPoint;
        this.sizes_ = sizes;
        var labels:Vector.<String> = new Vector.<String>();
        for each (size in this.sizes_) {
            labels.push((((("" + size.x_) + " x ") + size.y_)));
        }
        super(labels, 120, 26, "Size");
    }

    /** Selects the entry matching the given size, if there is one. */
    public function selectSize(sizeX:int, sizeY:int):void {
        var i:int;
        while (i < this.sizes_.length) {
            if (((this.sizes_[i].x_ == sizeX) && (this.sizes_[i].y_ == sizeY))) {
                setIndex(i);
                return;
            }
            i++;
        }
    }

    public function getSelectedSize():IntPoint {
        return (this.sizes_[getIndex()]);
    }

}
}//package spriteeditor
