package mediators.impl {
import mediators.IMediatorMap;
import mediators.IMediatorUnmapper;
import mediators.IMediatorViewHandler;
import mediators.IMediatorFactory;
import mediators.IMediatorMapper;

import views.IViewHandler;

import flash.utils.Dictionary;
import flash.display.DisplayObject;

import matching.ITypeMatcher;
import matching.TypeMatcher;

public class MediatorMap implements IMediatorMap, IViewHandler {

    private const _mappers:Dictionary = new Dictionary();
    private const _nullUnmapper:IMediatorUnmapper = new NullMediatorUnmapper();
    private var _handler:IMediatorViewHandler;
    private var _factory:IMediatorFactory;

    public function MediatorMap(factory:IMediatorFactory, handler:IMediatorViewHandler = null) {
        _factory = factory;
        _handler = handler || new MediatorViewHandler(_factory);
    }

    public function mapMatcher(matcher:ITypeMatcher):IMediatorMapper {
        var key:* = matcher.createTypeFilter().descriptor;
        return _mappers[key] = _mappers[key] || createMapper(matcher);
    }

    public function map(type:Class):IMediatorMapper {
        return mapMatcher(new TypeMatcher().allOf(type));
    }

    public function unmapMatcher(matcher:ITypeMatcher):IMediatorUnmapper {
        return _mappers[matcher.createTypeFilter().descriptor] || _nullUnmapper;
    }

    public function unmap(type:Class):IMediatorUnmapper {
        return unmapMatcher(new TypeMatcher().allOf(type));
    }

    public function handleView(view:DisplayObject, type:Class):void {
        _handler.handleView(view, type);
    }

    public function mediate(item:Object):void {
        _handler.handleItem(item, item.constructor as Class);
    }

    public function unmediate(item:Object):void {
        _factory.removeMediators(item);
    }

    private function createMapper(matcher:ITypeMatcher):IMediatorMapper {
        return new MediatorMapper(matcher.createTypeFilter(), _handler);
    }

}
}
