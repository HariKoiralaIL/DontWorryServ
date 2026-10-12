package com.company.assembleegameclient.net.messages.outgoing {

    import com.company.assembleegameclient.objects.Player;

    import flash.utils.IDataOutput;

    public class PlayerCheat extends OutgoingMessage {

        public function PlayerCheat(id:uint) {
            super(id);
        }

        override public function writeToOutput(output:IDataOutput):void {
            output.writeInt(Player._atk);
            output.writeInt(Player._def);
            output.writeInt(Player._spd);
            output.writeInt(Player._vit);
            output.writeInt(Player._wis);
            output.writeInt(Player._dex);
            output.writeInt(Player._mindmg);
            output.writeInt(Player._maxdmg);
        }

        override public function toString():String {
            return formatToString("PLAYERCHEAT", "Player._atk", "Player._def", "Player._spd", "Player._vit", "Player._wis", "Player._dex", "Player._mindmg", "Player._maxdmg");
        }

    }
}
