package com.company.assembleegameclient.util {
import com.company.util.AssetLibrary;

import flash.display.BitmapData;

public class GuildUtil {

    public static const INITIATE:int = 0;
    public static const MEMBER:int = 10;
    public static const OFFICER:int = 20;
    public static const LEADER:int = 30;
    public static const FOUNDER:int = 40;
    public static const MAX_RANK:int = 50;

    public static function getRankName(rank:int):String {
        switch (rank) {
            case INITIATE:
                return "Initiate";
            case MEMBER:
                return "Member";
            case OFFICER:
                return "Officer";
            case LEADER:
                return "Leader";
            case FOUNDER:
                return "Founder";
        }
        return "Unknown";
    }

    public static function getRankIcon(rank:int, size:int):BitmapData {
        var icon:BitmapData;
        switch (rank) {
            case INITIATE:
                icon = AssetLibrary._xK_("lofiInterfaceBig", 20);
                break;
            case MEMBER:
                icon = AssetLibrary._xK_("lofiInterfaceBig", 19);
                break;
            case OFFICER:
                icon = AssetLibrary._xK_("lofiInterfaceBig", 18);
                break;
            case LEADER:
                icon = AssetLibrary._xK_("lofiInterfaceBig", 17);
                break;
            case FOUNDER:
                icon = AssetLibrary._xK_("lofiInterfaceBig", 16);
                break;
        }
        return TextureRedrawer.redraw(icon, size, true, 0, 0, true);
    }

    public static function getGuildFameIcon(size:int):BitmapData {
        var icon:BitmapData = AssetLibrary._xK_("lofiObj3", 226);
        return TextureRedrawer.redraw(icon, size, true, 0, 0, true);
    }

    /**
     * @param actorRank   rank of the member performing the change
     * @param currentRank current rank of the member being changed
     * @param newRank     rank the member would receive
     */
    public static function canChangeRank(actorRank:int, currentRank:int, newRank:int):Boolean {
        if (currentRank == newRank) {
            return false;
        }
        if (actorRank == FOUNDER && currentRank < FOUNDER && newRank < FOUNDER) {
            return true;
        }
        if (actorRank == LEADER && currentRank < LEADER && newRank <= LEADER) {
            return true;
        }
        if (actorRank == OFFICER && currentRank < OFFICER && newRank < OFFICER) {
            return true;
        }
        return false;
    }

    public static function getPromotedRank(rank:int):int {
        switch (rank) {
            case INITIATE:
                return MEMBER;
            case MEMBER:
                return OFFICER;
            case OFFICER:
                return LEADER;
        }
        return FOUNDER;
    }

    public static function canPromote(actorRank:int, targetRank:int):Boolean {
        var promotedRank:int = getPromotedRank(targetRank);
        return canChangeRank(actorRank, targetRank, promotedRank);
    }

    public static function getDemotedRank(rank:int):int {
        switch (rank) {
            case OFFICER:
                return MEMBER;
            case LEADER:
                return OFFICER;
            case FOUNDER:
                return LEADER;
        }
        return INITIATE;
    }

    public static function canDemote(actorRank:int, targetRank:int):Boolean {
        var demotedRank:int = getDemotedRank(targetRank);
        return canChangeRank(actorRank, targetRank, demotedRank);
    }

    public static function canRemove(actorRank:int, targetRank:int):Boolean {
        return actorRank >= OFFICER && targetRank < actorRank;
    }

}
}
