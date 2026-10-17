package preview {
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.AnimatedCharLibrary;
import com.company.assembleegameclient.util.MaskedImage;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.util._kp;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;

public class PlayerTexturePreview extends PreviewBase {

    private static const PLAYER_IDS:Vector.<int> = new <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

    private static var iconsEmbed_:Class = TexturePreviewIcons;
    private static var icons:_kp = function ():_kp {
        var set:* = new _kp();
        set.addFromBitmapData(new iconsEmbed_().bitmapData, 16, 16);
        return set;
    }();

    private var useTex1_:Boolean = true;
    private var playerIndex:int = 0;
    private var dir_:int = 0;
    private var nextButton:Sprite;
    private var prevButton:Sprite;
    private var upButton:Sprite;
    private var rightButton:Sprite;
    private var downButton:Sprite;
    private var leftButton:Sprite;
    private var tex1Button:Sprite;
    private var tex2Button:Sprite;

    public function PlayerTexturePreview(w:int, h:int) {
        super(w, h);
        nextButton = addIcon(new Bitmap(icons._W_u[1]), nextPlayer);
        nextButton.x = w_ - nextButton.width - 5;
        nextButton.y = h_ - nextButton.height - 5;
        prevButton = addIcon(new Bitmap(icons._W_u[0]), prevPlayer);
        prevButton.x = nextButton.x - prevButton.width - 5;
        prevButton.y = h_ - prevButton.height - 5;
        rightButton = addIcon(new Bitmap(icons._W_u[3]), function ():void {
            dir_ = AnimatedChar.RIGHT;
        });
        rightButton.x = w_ - rightButton.width - 100;
        rightButton.y = h_ - rightButton.height - 5;
        downButton = addIcon(new Bitmap(icons._W_u[4]), function ():void {
            dir_ = AnimatedChar.DOWN;
        });
        downButton.x = rightButton.x - downButton.width - 5;
        downButton.y = h_ - downButton.height - 5;
        upButton = addIcon(new Bitmap(icons._W_u[2]), function ():void {
            dir_ = AnimatedChar.UP;
        });
        upButton.x = downButton.x;
        upButton.y = downButton.y - upButton.height - 5;
        leftButton = addIcon(new Bitmap(icons._W_u[5]), function ():void {
            dir_ = AnimatedChar.LEFT;
        });
        leftButton.x = downButton.x - leftButton.width - 5;
        leftButton.y = h_ - leftButton.height - 5;
        tex1Button = addIcon(new Bitmap(icons._W_u[6]), function ():void {
            useTex1_ = true;
        });
        tex1Button.x = 5;
        tex1Button.y = h_ - tex1Button.height - 5;
        tex2Button = addIcon(new Bitmap(icons._W_u[7]), function ():void {
            useTex1_ = false;
        });
        tex2Button.x = tex1Button.x + tex1Button.width + 5;
        tex2Button.y = h_ - tex2Button.height - 5;
    }

    override public function redraw():void {
        super.redraw();
        nextButton.filters = (playerIndex == PLAYER_IDS.length - 1) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        prevButton.filters = (playerIndex == 0) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        rightButton.filters = (dir_ == AnimatedChar.RIGHT) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        downButton.filters = (dir_ == AnimatedChar.DOWN) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        upButton.filters = (dir_ == AnimatedChar.UP) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        leftButton.filters = (dir_ == AnimatedChar.LEFT) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        tex1Button.filters = useTex1_ ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        tex2Button.filters = useTex1_ ? [] : [new ColorMatrixFilter(DISABLED_FILTER)];
        var animChar:AnimatedChar = AnimatedCharLibrary.getAnimatedChar("players", PLAYER_IDS[playerIndex]);
        var frame:MaskedImage = animChar.imageFromDir(dir_, AnimatedChar.STAND, 0);
        TextureRedrawer.sharedTexture_ = source_;
        var color:int = (source_ != null) ? 0xFFFFFFFF : 0;
        var bmd:BitmapData = TextureRedrawer.resize(frame.image_, frame.mask_, size_, true, useTex1_ ? color : 0, useTex1_ ? 0 : color);
        bmd = TextureRedrawer.outlineGlow(bmd, 0, 0);
        bitmap_.bitmapData = bmd;
    }

    private function nextPlayer():void {
        if (playerIndex == PLAYER_IDS.length - 1) {
            return;
        }
        playerIndex++;
    }

    private function prevPlayer():void {
        if (playerIndex == 0) {
            return;
        }
        playerIndex--;
    }

}
}
