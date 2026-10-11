package providers {
import injection.Injector;

import flash.utils.Dictionary;

public interface DependencyProvider {

    function apply(targetType:Class, activeInjector:Injector, injectParameters:Dictionary):Object;

    function destroy():void;

}
}
