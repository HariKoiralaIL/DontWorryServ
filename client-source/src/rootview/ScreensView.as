package rootview {
import flash.display.Sprite;

/** Shows one screen at a time and remembers the previous one so it can be brought back. */
public class ScreensView extends Sprite {

    private var currentScreen:Sprite;
    private var previousScreen:Sprite;

    public function setScreen(screen:Sprite):void {
        if (this.currentScreen == screen) {
            return;
        }
        this.detachCurrentScreen();
        this.currentScreen = screen;
        addChild(screen);
    }

    public function getPreviousScreen():Sprite {
        return (this.previousScreen);
    }

    /** Takes the current screen off the display list, keeping it as the previous screen. */
    private function detachCurrentScreen():void {
        if (((this.currentScreen) && (contains(this.currentScreen)))) {
            this.previousScreen = this.currentScreen;
            removeChild(this.currentScreen);
        }
    }

}
}//package rootview
