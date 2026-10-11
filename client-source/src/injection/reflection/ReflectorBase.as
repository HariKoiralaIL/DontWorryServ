package injection.reflection {

import flash.utils.Proxy;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

/** Behaviour shared by both reflector implementations. */
public class ReflectorBase {

    public function getClass(value:Object):Class {
        if (value is Proxy || value is Number || value is XML || value is XMLList) {
            // .constructor isn't reliable for these, so look the class up by name.
            return Class(getDefinitionByName(getQualifiedClassName(value)));
        }
        return value.constructor;
    }

    public function getFQCN(value:*, replaceColons:Boolean = false):String {
        var fqcn:String;
        var lastDot:int;
        if (value is String) {
            fqcn = value;
            if (!replaceColons && fqcn.indexOf("::") == -1) {
                lastDot = fqcn.lastIndexOf(".");
                if (lastDot == -1) {
                    return fqcn;
                }
                return fqcn.substring(0, lastDot) + "::" + fqcn.substring(lastDot + 1);
            }
        } else {
            fqcn = getQualifiedClassName(value);
        }
        return replaceColons ? fqcn.replace("::", ".") : fqcn;
    }

}
}//package injection.reflection
