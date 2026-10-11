package injection.reflection {

import avmplus.DescribeTypeJSON;

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import injectionpoints.NoParamsConstructorInjectionPoint;
import injectionpoints.PropertyInjectionPoint;
import injectionpoints.ConstructorInjectionPoint;
import injectionpoints.TypeDescription;
import injectionpoints.MethodInjectionPoint;
import injectionpoints.PostConstructInjectionPoint;
import injectionpoints.PreDestroyInjectionPoint;

import injection.InjectorError;

/**
 * Reflector built on avmplus.DescribeTypeJSON (the faster, newer API).
 * Parameters are turned into mapping ids of the form "type|name".
 *
 * Unresolved external types (defined elsewhere in the project):
 *   _Q_m = the type description being built (ctor, injection points, pre-destroy list)
 *   _00m = constructor injection point with no parameters
 *   _N_D_ = constructor injection point        _Z_T_ = method injection point
 *   _0J_f = field/property injection point
 *   _kG_ = [PostConstruct] point               _tv = [PreDestroy] point
 */
public class DescribeTypeJSONReflector extends ReflectorBase implements Reflector {

    private const describeTypeJSON:DescribeTypeJSON = new DescribeTypeJSON();

    public function typeImplements(type:Class, superType:Class):Boolean {
        if (type == superType) {
            return true;
        }
        var superTypeName:String = getQualifiedClassName(superType);
        var traits:Object = this.describeTypeJSON.getInstanceDescription(type).traits;
        return (traits.bases as Array).indexOf(superTypeName) > -1
            || (traits.interfaces as Array).indexOf(superTypeName) > -1;
    }

    public function describeInjections(type:Class):TypeDescription {
        var description:Object = this.describeTypeJSON.getInstanceDescription(type);
        var traits:Object = description.traits;
        var typeName:String = description.name;
        var result:TypeDescription = new TypeDescription(false);
        this.addCtorInjectionPoint(result, traits, typeName);
        this.addFieldInjectionPoints(result, traits.variables);
        this.addFieldInjectionPoints(result, traits.accessors);
        this.addMethodInjectionPoints(result, traits.methods, typeName);
        this.addPostConstructMethodPoints(result, traits.variables, typeName);
        this.addPostConstructMethodPoints(result, traits.accessors, typeName);
        this.addPostConstructMethodPoints(result, traits.methods, typeName);
        this.addPreDestroyMethodPoints(result, traits.methods, typeName);
        return result;
    }

    private function addCtorInjectionPoint(result:TypeDescription, traits:Object, typeName:String):void {
        var injectArgs:Dictionary;
        var parameterNames:Array;
        var constructorParameters:Array = traits.constructor;
        if (!constructorParameters) {
            result.ctor = (traits.bases.length > 0) ? new NoParamsConstructorInjectionPoint() : null;
            return;
        }
        injectArgs = this.getTagArguments("Inject", traits.metadata);
        parameterNames = ((injectArgs && injectArgs.name) || "").split(",");
        var requiredParameters:int = this.convertParametersToMappingIds(constructorParameters, parameterNames, typeName);
        result.ctor = new ConstructorInjectionPoint(constructorParameters, requiredParameters, injectArgs);
    }

    private function addMethodInjectionPoints(result:TypeDescription, methods:Array, typeName:String):void {
        var method:Object;
        var injectArgs:Dictionary;
        var optional:Boolean;
        var parameterNames:Array;
        var parameters:Array;
        var requiredParameters:uint;
        if (!methods) {
            return;
        }
        var count:uint = methods.length;
        var i:int = 0;
        while (i < count) {
            method = methods[i];
            injectArgs = this.getTagArguments("Inject", method.metadata);
            if (injectArgs) {
                optional = (injectArgs.optional == "true");
                parameterNames = (injectArgs.name || "").split(",");
                parameters = method.parameters;
                requiredParameters = this.convertParametersToMappingIds(parameters, parameterNames, typeName);
                result.addInjectionPoint(new MethodInjectionPoint(method.name, parameters, requiredParameters, optional, injectArgs));
            }
            i++;
        }
    }

    private function addPostConstructMethodPoints(result:TypeDescription, members:Array, typeName:String):void {
        var points:Array = this.gatherOrderedInjectionPoints(PostConstructInjectionPoint, "PostConstruct", members, typeName);
        var i:int = 0;
        var count:int = points.length;
        while (i < count) {
            result.addInjectionPoint(points[i]);
            i++;
        }
    }

    /** Links the [PreDestroy] points into a list (result.__case is the head, ._jO_ the current tail). */
    private function addPreDestroyMethodPoints(result:TypeDescription, methods:Array, typeName:String):void {
        var points:Array = this.gatherOrderedInjectionPoints(PreDestroyInjectionPoint, "PreDestroy", methods, typeName);
        if (!points.length) {
            return;
        }
        result.preDestroyMethods = points[0];
        result.preDestroyMethods.last = points[0];
        var i:int = 1;
        var count:int = points.length;
        while (i < count) {
            result.preDestroyMethods.last.next = points[i];
            result.preDestroyMethods.last = points[i];
            i++;
        }
    }

    private function addFieldInjectionPoints(result:TypeDescription, fields:Array):void {
        var field:Object;
        var injectArgs:Dictionary;
        var mappingName:String;
        var optional:Boolean;
        if (!fields) {
            return;
        }
        var count:uint = fields.length;
        var i:int = 0;
        while (i < count) {
            field = fields[i];
            injectArgs = this.getTagArguments("Inject", field.metadata);
            if (injectArgs) {
                mappingName = (injectArgs.name || "");
                optional = (injectArgs.optional == "true");
                result.addInjectionPoint(new PropertyInjectionPoint(field.type + "|" + mappingName, field.name, optional, injectArgs));
            }
            i++;
        }
    }

    /**
     * Rewrites each parameter in place as a mapping id ("type|name") and
     * returns how many of the parameters are required.
     */
    private function convertParametersToMappingIds(parameters:Array, parameterNames:Array, typeName:String):uint {
        var parameter:Object;
        var mappingName:String;
        var type:String;
        var required:uint;
        var count:uint = parameters.length;
        var i:int = 0;
        while (i < count) {
            parameter = parameters[i];
            mappingName = (parameterNames[i] || "");
            type = parameter.type;
            if (type == "*") {
                if (!parameter.optional) {
                    throw new InjectorError('Error in method definition of injectee "' + typeName + ". Required parameters can't have type \"*\".");
                }
                type = null;
            }
            if (!parameter.optional) {
                required++;
            }
            parameters[i] = type + "|" + mappingName;
            i++;
        }
        return required;
    }

    /** Collects the members tagged with the given metadata tag, sorted by their "order" argument. */
    private function gatherOrderedInjectionPoints(injectionPointType:Class, tag:String, members:Array, typeName:String):Array {
        var member:Object;
        var tagArgs:Object;
        var parameterNames:Array;
        var parameters:Array;
        var requiredParameters:uint;
        var order:int;
        var points:Array = [];
        if (!members) {
            return points;
        }
        var count:uint = members.length;
        var i:int = 0;
        while (i < count) {
            member = members[i];
            tagArgs = this.getTagArguments(tag, member.metadata);
            if (tagArgs) {
                parameterNames = (tagArgs.name || "").split(",");
                parameters = member.parameters;
                if (parameters) {
                    requiredParameters = this.convertParametersToMappingIds(parameters, parameterNames, typeName);
                } else {
                    parameters = [];
                    requiredParameters = 0;
                }
                order = parseInt(tagArgs.order, 10);
                if (order.toString(10) != tagArgs.order) {
                    order = int.MAX_VALUE;
                }
                points.push(new (injectionPointType)(member.name, parameters, requiredParameters, order));
            }
            i++;
        }
        if (points.length > 0) {
            points.sortOn("order", Array.NUMERIC);
        }
        return points;
    }

    /**
     * Finds the metadata tag with the given name and returns its key/value arguments
     * (repeated keys are joined with commas), or null if the tag isn't present.
     */
    private function getTagArguments(tagName:String, metadata:Array):Dictionary {
        var entry:Object;
        var values:Array;
        var args:Dictionary;
        var valueCount:int;
        var j:int;
        var arg:Object;
        var count:uint = metadata ? metadata.length : 0;
        var i:int = 0;
        while (i < count) {
            entry = metadata[i];
            if (entry.name == tagName) {
                values = entry.value;
                args = new Dictionary();
                valueCount = values.length;
                j = 0;
                while (j < valueCount) {
                    arg = values[j];
                    args[arg.key] = args[arg.key] ? (args[arg.key] + "," + arg.value) : arg.value;
                    j++;
                }
                return args;
            }
            i++;
        }
        return null;
    }

}
}//package injection.reflection
