package spriteeditor {
import flash.display.Sprite;

import flash.events.MouseEvent;

import client.util.color.RGB;

/** Fixed grid of preset colors. Dispatches ColorEvent while the mouse is pressed over it. */
public class ColorPalette extends Sprite {

    public static const CELL_SIZE:int = 12;
    public static const PALETTE_LEFT:Vector.<Vector.<uint>> = new <Vector.<uint>>[new <uint>[0, 0x262626, 0x4D4D4D, 0x737373, 0x999999, 0xBFBFBF, 0xE6E6E6, 0xFFFFFF], new <uint>[7483, 15480, 23733, 30699, 2397439, 6534143, 11786751, 14413311], new <uint>[15156, 21578, 30826, 38019, 47267, 777926, 6553581, 12255223], new <uint>[15121, 21528, 30754, 37930, 47156, 777799, 6553487, 12189619], new <uint>[0x283B00, 0x3A5400, 0x527800, 0x659400, 0x7EB800, 10214923, 13565795, 15269816], new <uint>[0x3B3900, 0x545100, 0x787400, 0x948F00, 0xB8B200, 14604043, 16775779, 16776632], new <uint>[0x3B2A00, 0x543C00, 0x785600, 0x946A00, 0xB88400, 14590475, 16765795, 16772024], new <uint>[0x3B1200, 0x541900, 0x782400, 0x942C00, 0xB83700, 14567947, 16749155, 16764344]];
    public static const PALETTE_RIGHT:Vector.<Vector.<uint>> = new <Vector.<uint>>[new <uint>[0x3B0000, 0x780000, 0xB50000, 14556445, 16730698, 16745861, 16757683, 16767963], new <uint>[0x4F001D, 0x780040, 0xB5006D, 0xE3006E, 16730764, 16745905, 16757711, 16767976], new <uint>[0x4E004F, 0x770078, 11154347, 13847252, 14642912, 14656736, 15583981, 16767999], new <uint>[0x22004F, 0x340078, 6763435, 8735444, 10448608, 12494048, 14273261, 15391743], new <uint>[65615, 131192, 3486635, 4999892, 7368416, 10855648, 13355757, 14474239], new <uint>[4413806, 5006200, 5139591, 6258588, 6918840, 7710420, 8368350, 10010595], new <uint>[4484675, 5011532, 5211982, 6331487, 6994025, 7722101, 8445567, 10085272], new <uint>[7223327, 7879971, 8863005, 10241571, 12080942, 13919027, 14581590, 14913903]];

    public function ColorPalette() {
        this.addSwatches(PALETTE_LEFT, 0);
        this.addSwatches(PALETTE_RIGHT, (CELL_SIZE * 8));
        addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
    }

    public function addSwatches(rows:Vector.<Vector.<uint>>, xOffset:int):void {
        var col:int;
        var rgbColor:RGB;
        var swatch:ColorSwatch;
        var row:int;
        while (row < rows.length) {
            col = 0;
            while (col < rows[row].length) {
                rgbColor = RGB.fromHex(rows[row][col]);
                swatch = new ColorSwatch(CELL_SIZE, rgbColor.toHSV(), true);
                swatch.x = (xOffset + (col * CELL_SIZE));
                swatch.y = (row * CELL_SIZE);
                addChild(swatch);
                col++;
            }
            row++;
        }
    }

    public function onMouseDown(event:MouseEvent):void {
        this.dispatchColorUnder(event);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
    }

    private function onMouseMove(event:MouseEvent):void {
        this.dispatchColorUnder(event);
    }

    private function onMouseUp(event:MouseEvent):void {
        this.dispatchColorUnder(event);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
    }

    private function dispatchColorUnder(event:MouseEvent):void {
        var swatch:ColorSwatch = (event.target as ColorSwatch);
        if (swatch != null) {
            dispatchEvent(new ColorEvent(swatch.color_));
        }
    }

}
}//package spriteeditor
