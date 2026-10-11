package spriteeditor {
import editorcommands.SelectableButtonGroup;
import com.company.util._H_V_;
import editorcommands.SelectableButton;
import editorcommands.CommandEvent;

/** Toolbar with the drawing tools (draw / erase / sample) and the undo, redo, clear, load, save actions. */
public class EditorToolbar extends SelectableButtonGroup {

    /** Used for buttons that are one-shot actions rather than selectable tools. */
    public static const MODE_NONE:int = 0;
    public static const MODE_DRAW:int = 1;
    public static const MODE_ERASE:int = 2;
    public static const MODE_SAMPLE:int = 3;

    public function EditorToolbar() {
        addButton("(D)raw", _H_V_.D, this.onDraw, MODE_DRAW);
        addButton("(E)rase", _H_V_.E, this.onErase, MODE_ERASE);
        addButton("S(A)mple", _H_V_.A, this.onSample, MODE_SAMPLE);
        addButton("(U)ndo", _H_V_.U, this.onUndo, MODE_NONE);
        addButton("(R)edo", _H_V_.R, this.onRedo, MODE_NONE);
        addButton("(C)lear", _H_V_.C, this.onClear, MODE_NONE);
        addSpacer();
        addButton("(L)oad", _H_V_.L, this.onLoad, MODE_NONE);
        addButton("(S)ave", _H_V_.S, this.onSave, MODE_NONE);
    }

    private function onDraw(button:SelectableButton):void {
        setSelected(button);
    }

    private function onErase(button:SelectableButton):void {
        setSelected(button);
    }

    private function onSample(button:SelectableButton):void {
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

}
}//package spriteeditor
