package account.ui {
import flash.events.Event;

internal class AccountFrameEvent extends Event {

    public static const DONE:String = "ACCOUNT_DONE";
    public static const CURRENT:String = "ACCOUNT_CURRENT";
    public static const REGISTER:String = "ACCOUNT_REGISTER";
    public static const SIGN_IN:String = "ACCOUNT_SIGN_IN";
    public static const FORGOT:String = "ACCOUNT_FORGOT";
    public static const CHANGE:String = "ACCOUNT_CHANGE";

    public function AccountFrameEvent(type:String) {
        super(type);
    }

}
}
