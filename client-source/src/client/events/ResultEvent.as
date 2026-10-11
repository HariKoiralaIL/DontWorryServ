package client.events {
import flash.events.Event;

/** Result of a guild or market request: a success flag and, on failure, an error text. */
public class ResultEvent extends Event {

    public static const GUILD_RESULT:String = "GUILDRESULTEVENT";
    public static const MARKET_RESULT:String = "MARKETRESULTEVENT";

    public var success_:Boolean;
    public var errorText_:String;

    public function ResultEvent(success:Boolean, errorText:String, type:String = GUILD_RESULT) {
        super(type);
        success_ = success;
        errorText_ = errorText;
    }

}
}
