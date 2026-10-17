package mapeditor {
import com.company.util.KeyCodes;

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
        addButton("(D)raw", KeyCodes.D, this.select, TOOL_DRAW);
        addButton("(E)rase", KeyCodes.E, this.select, TOOL_ERASE);
        addButton("S(A)mple", KeyCodes.A, this.select, TOOL_SAMPLE);
        addButton("Ed(I)t", KeyCodes.I, this.select, TOOL_EDIT);
        addButton("(U)ndo", KeyCodes.U, this.onUndo, TOOL_NONE);
        addButton("(R)edo", KeyCodes.R, this.onRedo, TOOL_NONE);
        addButton("(C)lear", KeyCodes.C, this.onClear, TOOL_NONE);
        addSpacer();
        addButton("(L)oad", KeyCodes.L, this.onLoad, TOOL_NONE);
        addButton("(S)ave", KeyCodes.S, this.onSave, TOOL_NONE);
        addButton("(T)est", KeyCodes.T, this.onTest, TOOL_NONE);
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
