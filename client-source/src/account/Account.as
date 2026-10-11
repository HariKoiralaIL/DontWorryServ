package account
{
    import com.company.assembleegameclient.account.web.WebAccount;
    import com.company.assembleegameclient.parameters.Parameters;

    import flash.display.Sprite;
    import flash.display.Stage;

    public class Account
    {
        private static var instance_:Account = null;

        public static function load(stage:Stage, onLoaded:Function):void
        {
            instance_ = new WebAccount();
            instance_.internalLoad(stage, onLoaded);
        }

        public static function getInstance():Account
        {
            if (instance_ == null)
            {
                instance_ = new WebAccount();
            }
            return instance_;
        }

        public function guid():String
        {
            return null;
        }

        public function password():String
        {
            return "";
        }

        public function secret():String
        {
            return "";
        }

        public function credentials():Object
        {
            return null;
        }

        public function isRegistered():Boolean
        {
            return false;
        }

        public function modify(guid:String, password:String, secret:String):void
        {
        }

        public function clear():void
        {
            Parameters._hk = true;
        }

        public function reportIntStat(name:String, value:int):void
        {
        }

        public function newAccountText():AccountTextView
        {
            return null;
        }

        public function newAccountManagement():Sprite
        {
            return null;
        }

        public function showInGameRegister(stage:Stage):void
        {
        }

        public function cacheOffers():void
        {
        }

        public function showMoneyManagement(stage:Stage):void
        {
        }

        public function gameNetworkUserId():String
        {
            return "";
        }

        public function gameNetwork():String
        {
            return null;
        }

        public function playPlatform():String
        {
            return null;
        }

        public function entrytag():String
        {
            return null;
        }

        protected function internalLoad(stage:Stage, onLoaded:Function):void
        {
        }
    }
}
