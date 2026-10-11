package matching {
import flash.errors.IllegalOperationError;

public class TypeMatcher implements ITypeMatcher, ITypeMatcherFactory {

    protected const _allOfTypes:Vector.<Class> = new Vector.<Class>();
    protected const _anyOfTypes:Vector.<Class> = new Vector.<Class>();
    protected const _noneOfTypes:Vector.<Class> = new Vector.<Class>();

    protected var _typeFilter:ITypeFilter;

    public function allOf(...types):TypeMatcher {
        pushAddedTypes(types, _allOfTypes);
        return this;
    }

    public function anyOf(...types):TypeMatcher {
        pushAddedTypes(types, _anyOfTypes);
        return this;
    }

    public function noneOf(...types):TypeMatcher {
        pushAddedTypes(types, _noneOfTypes);
        return this;
    }

    public function createTypeFilter():ITypeFilter {
        return _typeFilter = _typeFilter || buildTypeFilter();
    }

    public function lock():ITypeMatcherFactory {
        createTypeFilter();
        return this;
    }

    public function clone():TypeMatcher {
        return new TypeMatcher().allOf(_allOfTypes).anyOf(_anyOfTypes).noneOf(_noneOfTypes);
    }

    protected function buildTypeFilter():ITypeFilter {
        if (_allOfTypes.length == 0 && _anyOfTypes.length == 0 && _noneOfTypes.length == 0) {
            throw new TypeMatcherError(TypeMatcherError.EMPTY_MATCHER);
        }
        return new TypeFilter(_allOfTypes, _anyOfTypes, _noneOfTypes);
    }

    protected function pushAddedTypes(types:Array, target:Vector.<Class>):void {
        if (_typeFilter) {
            throwSealedError();
        }
        pushValues(types, target);
    }

    protected function throwSealedError():void {
        throw new IllegalOperationError("This TypeMatcher has been sealed and can no longer be configured");
    }

    protected function pushValues(types:Array, target:Vector.<Class>):void {
        var type:Class;
        if (types.length == 1 && (types[0] is Array || types[0] is Vector.<Class>)) {
            for each (type in types[0]) {
                target.push(type);
            }
        } else {
            for each (type in types) {
                target.push(type);
            }
        }
    }

}
}
