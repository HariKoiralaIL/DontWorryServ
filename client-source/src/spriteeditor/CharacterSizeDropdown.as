package spriteeditor {

import com.company.util.IntPoint;

public class CharacterSizeDropdown extends SizeDropdown {

    private static const SIZES:Vector.<IntPoint> = new <IntPoint>[new IntPoint(8, 8), new IntPoint(16, 8), new IntPoint(16, 16)];

    public function CharacterSizeDropdown() {
        super(SIZES);
    }
}
}//package spriteeditor
