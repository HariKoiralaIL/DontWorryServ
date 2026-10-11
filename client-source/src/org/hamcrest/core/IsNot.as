package org.hamcrest.core {
import matchers.Description;
import matchers.BaseMatcher;
import matchers.Matcher;

/**
 * Inverts another matcher: matches only if the wrapped matcher does not.
 */
public class IsNot extends BaseMatcher {

    private var matcher:Matcher;

    public function IsNot(matcher:Matcher) {
        this.matcher = matcher;
    }

    override public function matches(item:Object):Boolean {
        return !this.matcher.matches(item);
    }

    override public function describeTo(description:Description):void {
        description.appendText("not ").appendDescriptionOf(this.matcher);
    }
}
}
