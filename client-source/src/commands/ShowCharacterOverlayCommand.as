package commands {

import com.company.assembleegameclient.appengine.SavedCharacter;

import rootview.Layers;

import services.DeleteCharacterTask;
import _0L_C_._0D_W_;

/**
 * Adds the _0D_W_ view to the overlay layer.
 *
 * NOTE: `character` and `deleteTask` are injected but never read in
 * execute(). They are kept so the signal/command mapping stays identical;
 * they can be dropped if nothing relies on them.
 */
public class ShowCharacterOverlayCommand {

    [Inject]
    public var character:SavedCharacter;
    [Inject]
    public var deleteTask:DeleteCharacterTask;
    [Inject]
    public var layers:Layers;

    public function execute():void {
        this.layers.overlay.addChild(new _0D_W_());
    }

}
}
