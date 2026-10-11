package org.hamcrest.core {
import _g3.equalTo;

import _qj._pn;

/**
 * Creates a matcher that inverts the given matcher. A plain value is
 * treated as equalTo(value).
 */
public function not(value:Object):_pn {
    if (value is _pn) {
        return new IsNot(value as _pn);
    }
    return not(equalTo(value));
}
}
