// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.enums.PositionSlot

package client.enums {
public class PositionSlot {

    public static const SLOT_0:PositionSlot = new PositionSlot(0);
    public static const SLOT_1:PositionSlot = new PositionSlot(1);
    public static const SLOT_2:PositionSlot = new PositionSlot(2);
    public static const SLOT_3:PositionSlot = new PositionSlot(3);

    public function PositionSlot(position:int) {
        this.position = position;
    }
    public var position:int;
}
}//package client.enums

