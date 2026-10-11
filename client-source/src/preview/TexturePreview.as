package preview {
import com.company.assembleegameclient.util.TextureRedrawer;

public class TexturePreview extends PreviewBase {

    public function TexturePreview(w:int, h:int) {
        super(w, h);
    }

    override public function redraw():void {
        super.redraw();
        if (source_ == null) {
            return;
        }
        bitmap_.bitmapData = TextureRedrawer.redraw(source_, size_, true, 0, 0, false);
    }

}
}
