package spriteeditor {

import com.company.util.IntPoint;

public class ObjectSizeDropdown extends SizeDropdown {

    private static const SIZES:Vector.<IntPoint> = new <IntPoint>[new IntPoint(8, 8), new IntPoint(16, 8), new IntPoint(16, 16), new IntPoint(40, 40)];

    public function ObjectSizeDropdown() {
        super(SIZES);
    }
}
}//package spriteeditor
