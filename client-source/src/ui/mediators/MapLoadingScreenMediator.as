package ui.mediators {
import _011.MapInfo;

import client.ui.screens.MapLoadingOverlay;

import client.game.GameInitData;

import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util._0B_c;
import com.company.assembleegameclient.util._J_H_;
import com.company.assembleegameclient.util._lJ_;

import env.ServerListState;

import flash.display.BitmapData;

import game.signals.MapInfoSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

/**
 * Mediator for the map loading screen (_F_1._02a). When the map info arrives, it
 * renders two portrait frames of the selected character and hands everything to the view.
 */
public class MapLoadingScreenMediator extends Mediator {

    private static const PORTRAIT_SIZE:int = 100;
    private static const FRAME_FIRST:Number = 0;
    private static const FRAME_SECOND:Number = 0.5;

    [Inject]
    public var view:MapLoadingScreen;
    [Inject]
    public var serverList:ServerListState;
    /** Unused; kept so dependency injection behaves exactly as before. */
    [Inject]
    public var gameInitData:GameInitData;

    override public function initialize():void {
        MapInfoSignal.getInstance().addOnce(this.onMapInfo);
    }

    private function onMapInfo(mapInfo:MapInfo):void {
        var portrait1:BitmapData = null;
        var portrait2:BitmapData = null;
        var character:SavedCharacter = this.findSelectedCharacter();
        if (character) {
            var animatedChar:_lJ_ = this.getAnimatedChar(character);
            portrait1 = this.renderPortrait(animatedChar, FRAME_FIRST, character);
            portrait2 = this.renderPortrait(animatedChar, FRAME_SECOND, character);
        }
        this.view.display(mapInfo, mapInfo.difficulty_, portrait1, portrait2);
    }

    /**
     * Returns the character whose id matches the selected one. Behaviour kept from the
     * original loop: if nothing matches, the last character in the list is returned.
     */
    private function findSelectedCharacter():SavedCharacter {
        var selected:SavedCharacter = null;
        for each (var character:SavedCharacter in this.serverList.servers.savedChars_) {
            selected = character;
            if (this.serverList.count == character.charId()) {
                break;
            }
        }
        return selected;
    }

    /** Animated texture of the character's class, or of its skin when it has one. */
    private function getAnimatedChar(character:SavedCharacter):_lJ_ {
        var classXml:XML = ObjectLibrary._Q_F_[int(character._iJ_.ObjectType)];
        var animatedChar:_lJ_ = _0B_c._J_v(String(classXml.AnimatedTexture.File), int(classXml.AnimatedTexture.Index));
        var skinType:int = character.skin();
        if (skinType != -1) {
            var skinXml:XML = ObjectLibrary._Q_F_[skinType];
            if (skinXml != null) {
                animatedChar = _0B_c._J_v(String(skinXml.AnimatedTexture.File), int(skinXml.AnimatedTexture.Index));
            }
        }
        return animatedChar;
    }

    private function renderPortrait(animatedChar:_lJ_, frame:Number, character:SavedCharacter):BitmapData {
        var image:_J_H_ = animatedChar.imageFromDir(_lJ_.RIGHT, _lJ_._m1, frame);
        var tex1:int = character.tex1();
        var tex2:int = character.tex2();
        return TextureRedrawer.resize(image.image_, image.mask_, PORTRAIT_SIZE, false, tex1, tex2);
    }

}
}
