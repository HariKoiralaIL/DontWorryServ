package com.company.util {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

public class DisplayUtil {

    public static function safeAddChild(parent:DisplayObjectContainer, child:DisplayObject):void {
        if (parent != null && child != null && !parent.contains(child)) {
            parent.addChild(child);
        }
    }

    public static function safeRemoveChild(parent:DisplayObjectContainer, child:DisplayObject):void {
        if (parent != null && child != null && parent.contains(child)) {
            parent.removeChild(child);
        }
    }

}
}//package com.company.util
