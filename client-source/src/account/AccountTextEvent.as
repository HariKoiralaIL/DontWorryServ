package account
{
    import flash.display.Sprite;
    import flash.events.Event;

    public class AccountTextEvent extends Event
    {
        public static const ACCOUNT_TEXT_EVENT:String = "ACCOUNT_TEXT_EVENT";

        public var textView:Sprite;

        public function AccountTextEvent(textView:Sprite)
        {
            super(ACCOUNT_TEXT_EVENT);
            this.textView = textView;
        }
    }
}
