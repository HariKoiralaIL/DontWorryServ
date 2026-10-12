package game.marketplace {
    /** Shared layout constants for the marketplace screens (800x600 stage). */
    public class MarketplaceLayout {

        public static const STAGE_WIDTH:int = 800;
        public static const STAGE_HEIGHT:int = 600;

        /** Width of the scrolling content area. */
        public static const CONTENT_WIDTH:int = 756;
        /** Visible height of the scrolling list (also the scroll bar track). */
        public static const VIEW_HEIGHT:int = 400;
        /** Height of the masked viewport. */
        public static const VIEWPORT_HEIGHT:int = 423;
        public static const VIEWPORT_X:int = 10;
        public static const VIEWPORT_Y:int = 101;

        public static const SCROLL_BAR_WIDTH:int = 16;
        public static const FONT:String = "Myriad Pro";
        public static const TEXT_COLOR:uint = 0xB3B3B3;
        public static const ACCENT_COLOR:uint = 0xEE9327;

        /** Horizontal centre of the Trade / Create / Search action button. */
        public static const ACTION_BUTTON_CENTER_X:Number = (3 * CONTENT_WIDTH) / 3.25;
    }
}
