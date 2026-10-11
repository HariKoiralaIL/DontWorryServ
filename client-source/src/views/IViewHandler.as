package views {

import flash.display.DisplayObject;

/** Receives each view added to a watched container, along with its class. */
public interface IViewHandler {

    function handleView(view:DisplayObject, type:Class):void;

}
}
