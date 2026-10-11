package matching {
import flash.utils.getQualifiedClassName;

public class TypeFilter implements ITypeFilter {

    protected var _allOfTypes:Vector.<Class>;
    protected var _anyOfTypes:Vector.<Class>;
    protected var _descriptor:String;
    protected var _noneOfTypes:Vector.<Class>;

    public function TypeFilter(allOf:Vector.<Class>, anyOf:Vector.<Class>, noneOf:Vector.<Class>) {
        if (!allOf || !anyOf || !noneOf) {
            throw ArgumentError("TypeFilter parameters can not be null");
        }
        _allOfTypes = allOf;
        _anyOfTypes = anyOf;
        _noneOfTypes = noneOf;
    }

    public function get allOfTypes():Vector.<Class> {
        return _allOfTypes;
    }

    public function get anyOfTypes():Vector.<Class> {
        return _anyOfTypes;
    }

    public function get descriptor():String {
        return _descriptor = _descriptor || createDescriptor();
    }

    public function get noneOfTypes():Vector.<Class> {
        return _noneOfTypes;
    }

    public function matches(item:*):Boolean {
        var i:uint = _allOfTypes.length;
        while (i--) {
            if (!(item is _allOfTypes[i])) {
                return false;
            }
        }
        i = _noneOfTypes.length;
        while (i--) {
            if (item is _noneOfTypes[i]) {
                return false;
            }
        }
        if (_anyOfTypes.length == 0 && (_allOfTypes.length > 0 || _noneOfTypes.length > 0)) {
            return true;
        }
        i = _anyOfTypes.length;
        while (i--) {
            if (item is _anyOfTypes[i]) {
                return true;
            }
        }
        return false;
    }

    protected function getSortedQualifiedNames(types:Vector.<Class>):Vector.<String> {
        var names:Vector.<String> = new <String>[];
        var len:uint = types.length;
        var i:uint = 0;
        while (i < len) {
            names[names.length] = getQualifiedClassName(types[i]);
            i++;
        }
        names.sort(stringSort);
        return names;
    }

    protected function createDescriptor():String {
        var allOf:Vector.<String> = getSortedQualifiedNames(allOfTypes);
        var anyOf:Vector.<String> = getSortedQualifiedNames(anyOfTypes);
        var noneOf:Vector.<String> = getSortedQualifiedNames(noneOfTypes);
        return "all of: " + allOf.toString() + ", any of: " + anyOf.toString() + ", none of: " + noneOf.toString();
    }

    protected function stringSort(a:String, b:String):int {
        if (a < b) {
            return 1;
        }
        return -1;
    }

}
}
