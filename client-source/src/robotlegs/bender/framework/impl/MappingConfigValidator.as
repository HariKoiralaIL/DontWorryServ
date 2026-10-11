package robotlegs.bender.framework.impl {
import robotlegs.bender.framework.api.FrameworkError;

/**
 * Guards a mapping's guards and hooks against being changed after the mapping was created.
 */
public class MappingConfigValidator {

    private static const CHANGE_ERROR_MESSAGE:String =
            "You can't change the guards and hooks on an existing mapping. Unmap first.";
    private static const STACKTRACE_NOTE:String =
            " The stacktrace for this error was stored at the time when you duplicated the mapping - " +
            "you may have failed to add guards and hooks that were already present.";

    private var _guards:Array;
    private var _hooks:Array;
    private var _trigger:*;
    private var _action:*;
    private var _storedError:FrameworkError;
    private var _valid:Boolean = false;

    public function MappingConfigValidator(guards:Array, hooks:Array, trigger:*, action:*) {
        _guards = guards;
        _hooks = hooks;
        _trigger = trigger;
        _action = action;
    }

    public function get valid():Boolean {
        return _valid;
    }

    public function invalidate():void {
        _valid = false;
        _storedError = new FrameworkError(CHANGE_ERROR_MESSAGE + STACKTRACE_NOTE, _trigger, _action);
    }

    public function validate(guards:Array, hooks:Array):void {
        if (!hasSameItems(_guards, guards) || !hasSameItems(_hooks, hooks)) {
            if (_storedError) {
                throw _storedError;
            }
            throwChangeError();
        }
        _valid = true;
        _storedError = null;
    }

    public function checkGuards(guards:Array):void {
        if (hasNewItems(_guards, guards)) {
            throwChangeError();
        }
    }

    public function checkHooks(hooks:Array):void {
        if (hasNewItems(_hooks, hooks)) {
            throwChangeError();
        }
    }

    public function flatten(items:Array):Array {
        var item:*;
        var result:Array = [];
        for each (item in items) {
            if (item is Array) {
                result = result.concat(flatten(item as Array));
            } else {
                result.push(item);
            }
        }
        return result;
    }

    /** True if (after flattening) any incoming item is missing from the existing items. */
    private function hasNewItems(existing:Array, incoming:Array):Boolean {
        var item:*;
        incoming = flatten(incoming);
        for each (item in incoming) {
            if (existing.indexOf(item) == -1) {
                return true;
            }
        }
        return false;
    }

    /** True if both arrays contain the same items, regardless of order. */
    private function hasSameItems(existing:Array, incoming:Array):Boolean {
        var index:int;
        var remaining:Array = existing.slice();
        if (remaining.length != incoming.length) {
            return false;
        }
        var count:uint = incoming.length;
        var i:uint = 0;
        while (i < count) {
            index = remaining.indexOf(incoming[i]);
            if (index == -1) {
                return false;
            }
            remaining.splice(index, 1);
            i++;
        }
        return true;
    }

    private function throwChangeError():void {
        throw new FrameworkError(CHANGE_ERROR_MESSAGE, _trigger, _action);
    }

}
}
