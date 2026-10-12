package game.guild {
    import flash.events.Event;

    public class GuildMemberEvent extends Event {

        public static const SET_RANK:String = "SET_RANK";
        public static const REMOVE_MEMBER:String = "REMOVE_MEMBER";

        public var name_:String;
        public var rank_:int;

        public function GuildMemberEvent(type:String, name:String, rank:int = -1) {
            super(type, true);
            this.name_ = name;
            this.rank_ = rank;
        }
    }
}
