package com.company.assembleegameclient.appengine {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.AnimatedCharLibrary;
import com.company.assembleegameclient.util.MaskedImage;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.util._G_;

import flash.display.BitmapData;
import flash.geom.ColorTransform;

public class SavedCharacter {

    private static const NO_SKIN:int = -1;

    public var charXML_:XML;
    public var name_:String = null;

    public function SavedCharacter(charXML:XML, name:String) {
        this.charXML_ = charXML;
        this.name_ = name;
    }

    public static function getImage(savedChar:SavedCharacter, playerXML:XML, dir:int, action:int, p:Number, available:Boolean, selected:Boolean):BitmapData {
        var tex1:int = (savedChar != null) ? savedChar.tex1() : 0;
        var tex2:int = (savedChar != null) ? savedChar.tex2() : 0;
        var animChar:AnimatedChar = getAnimatedChar(playerXML);
        if (savedChar != null && savedChar.skin() != NO_SKIN) {
            var skinXML:XML = ObjectLibrary.typeToXML_[savedChar.skin()];
            if (skinXML != null) {
                animChar = getAnimatedChar(skinXML);
            }
        }
        var frame:MaskedImage = animChar.imageFromDir(dir, action, p);
        var image:BitmapData = TextureRedrawer.resize(frame.image_, frame.mask_, 100, false, tex1, tex2);
        image = TextureRedrawer.outlineGlow(image, 0, 0);
        if (!available) {
            image = _G_._B_2(image, new ColorTransform(0, 0, 0, 0.5, 0, 0, 0, 0));
        } else if (!selected) {
            image = _G_._B_2(image, new ColorTransform(0.75, 0.75, 0.75, 1, 0, 0, 0, 0));
        }
        return image;
    }

    private static function getAnimatedChar(xml:XML):AnimatedChar {
        return AnimatedCharLibrary.getAnimatedChar(String(xml.AnimatedTexture.File), int(xml.AnimatedTexture.Index));
    }

    /** Sort comparator: most-used characters first, then highest exp. */
    public static function compareByUsage(a:SavedCharacter, b:SavedCharacter):Number {
        var useMap:Object = Parameters.data_.charIdUseMap;
        var usesA:Number = useMap.hasOwnProperty(a.charId()) ? useMap[a.charId()] : 0;
        var usesB:Number = useMap.hasOwnProperty(b.charId()) ? useMap[b.charId()] : 0;
        if (usesA != usesB) {
            return usesB - usesA;
        }
        return b.exp() - a.exp();
    }

    public function charId():int {
        return int(this.charXML_.@id);
    }

    public function name():String {
        return this.name_;
    }

    public function objectType():int {
        return int(this.charXML_.ObjectType);
    }

    public function level():int {
        return int(this.charXML_.Level);
    }

    public function tex1():int {
        return int(this.charXML_.Tex1);
    }

    public function tex2():int {
        return int(this.charXML_.Tex2);
    }

    public function skin():int {
        return int(this.charXML_.Skin);
    }

    public function exp():int {
        return int(this.charXML_.Exp);
    }

    public function fame():int {
        return int(this.charXML_.CurrentFame);
    }

    public function displayId():String {
        return ObjectLibrary.typeToDisplayId_[this.objectType()];
    }

    public function toString():String {
        return "SavedCharacter: {" + this.charXML_ + "}";
    }

}
}
