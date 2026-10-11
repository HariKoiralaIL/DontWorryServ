package org.hamcrest.core {
import matchers.Description;
import matchers.DiagnosingMatcher;
import matchers.Matcher;

/**
 * Matches only if the item matches every one of the given matchers.
 * Stops at the first matcher that fails and describes that mismatch.
 */
public class AllOfMatcher extends DiagnosingMatcher {

    private var matchers:Array;

    public function AllOfMatcher(matchers:Array) {
        this.matchers = ((matchers) || ([]));
    }

    override protected function matchesOrDescribesMismatch(item:Object, mismatchDescription:Description):Boolean {
        var matcher:Matcher;
        for each (matcher in this.matchers) {
            if (!matcher.matches(item)) {
                mismatchDescription.appendDescriptionOf(matcher).appendText(" ").appendMismatchOf(matcher, item);
                return false;
            }
        }
        return true;
    }

    override public function describeTo(description:Description):void {
        description.appendList("(", " and ", ")", this.matchers);
    }
}
}
