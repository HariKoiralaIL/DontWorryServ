package client.ui.controls {

/** An item with a string value that can be shown as selected or unselected. */
public interface ISelectableItem {

    function getValue():String;

    function setSelected(selected:Boolean):void;

}
}
