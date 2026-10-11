package org.hamcrest.core {
import matchers.equalTo;

import matchers.Matcher;

/**
 * Creates a matcher that inverts the given matcher. A plain value is
 * treated as equalTo(value).
 */
public function not(value:Object):Matcher {
    if (value is Matcher) {
        return new IsNot(value as Matcher);
    }
    return not(equalTo(value));
}
}
