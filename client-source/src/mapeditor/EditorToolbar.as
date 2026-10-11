package mapeditor {
import com.company.util._H_V_;

import editorcommands.CommandEvent;
import editorcommands.SelectableButton;
import editorcommands.SelectableButtonGroup;

/** Tool/action button strip of the map editor. */
public class EditorToolbar extends SelectableButtonGroup {

    /** Value for plain action buttons (undo, save, ...) that never become the selected tool. */
    public static const TOOL_NONE:int = 0;
    public static const TOOL_DRAW:int = 1;
    public static const TOOL_ERASE:int = 2;
    public static const TOOL_SAMPLE:int = 3;
    public static const TOOL_EDIT:int = 4;

    public function EditorToolbar() {
        addButton("(D)raw", _H_V_.D, this.select, TOOL_DRAW);
        addButton("(E)rase", _H_V_.E, this.select, TOOL_ERASE);
        addButton("S(A)mple", _H_V_.A, this.select, TOOL_SAMPLE);
        addButton("Ed(I)t", _H_V_.I, this.select, TOOL_EDIT);
        addButton("(U)ndo", _H_V_.U, this.onUndo, TOOL_NONE);
        addButton("(R)edo", _H_V_.R, this.onRedo, TOOL_NONE);
        addButton("(C)lear", _H_V_.C, this.onClear, TOOL_NONE);
        addSpacer();
        addButton("(L)oad", _H_V_.L, this.onLoad, TOOL_NONE);
        addButton("(S)ave", _H_V_.S, this.onSave, TOOL_NONE);
        addButton("(T)est", _H_V_.T, this.onTest, TOOL_NONE);
    }

    private function select(button:SelectableButton):void {
        setSelected(button);
    }

    private function onUndo(button:SelectableButton):void {
        dispatchEvent(new CommandEvent(CommandEvent.UNDO_COMMAND_EVENT));
    }

    private function onRedo(button:SelectableButton):void {
        dispatchEvent(new CommandEvent(CommandEvent.REDO_COMMAND_EVENT));
    }

    private function onClear(button:SelectableButton):void {
        dispatchEvent(new CommandEvent(CommandEvent.CLEAR_COMMAND_EVENT));
    }

    private function onLoad(button:SelectableButton):void {
        dispatchEvent(new CommandEvent(CommandEvent.LOAD_COMMAND_EVENT));
    }

    private function onSave(button:SelectableButton):void {
        dispatchEvent(new CommandEvent(CommandEvent.SAVE_COMMAND_EVENT));
    }

    private function onTest(button:SelectableButton):void {
        dispatchEvent(new CommandEvent(CommandEvent.TEST_COMMAND_EVENT));
    }

}
}
