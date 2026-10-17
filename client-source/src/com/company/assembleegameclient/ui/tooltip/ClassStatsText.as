package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.appengine.ClassStats;
import com.company.assembleegameclient.util.FameUtil;

/** Shared text for the class stats blocks in ClassToolTip and CharacterToolTip. */
public class ClassStatsText {

    public static function summary(stats:ClassStats):String {
        var stars:int = stats == null ? 0 : stats.numStars();
        var bestLevel:int = stats == null ? 0 : stats.bestLevel();
        var bestFame:int = stats == null ? 0 : stats.bestFame();
        return stars + " of " + FameUtil.STAR_THRESHOLDS.length + " C-Quests Completed\n"
                + "Best Level Achieved: " + bestLevel + "\n"
                + "Best Fame Achieved: " + bestFame;
    }

    /** Returns null when there is no next star goal. */
    public static function nextGoal(stats:ClassStats, className:String):String {
        var fame:int = FameUtil.nextStarFame(stats == null ? 0 : stats.bestFame(), 0);
        if (fame <= 0) {
            return null;
        }
        return "Next Goal: Earn " + fame + " Fame\n  with a " + className;
    }

}
}
