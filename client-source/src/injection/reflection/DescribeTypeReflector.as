package injection.reflection {

import flash.utils.Dictionary;
import flash.utils.describeType;
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
 * Reflector built on flash.utils.describeType (XML). Used when the faster
 * DescribeTypeJSON API isn't available. See DescribeTypeJSONReflector for what
 * the external types (_Q_m, _00m, _N_D_, ...) are.
 */
public class DescribeTypeReflector extends ReflectorBase implements Reflector {

    /** The <factory> node of the type currently being described (null between calls). */
    private var currentFactoryXML:XML;

    public function typeImplements(type:Class, superType:Class):Boolean {
        if (type == superType) {
            return true;
        }
        var factoryDescription:XML = describeType(type).factory[0];
        return factoryDescription.children().(name() == "implementsInterface" || name() == "extendsClass").(attribute("type") == getQualifiedClassName(superType)).length() > 0;
    }

    public function describeInjections(type:Class):TypeDescription {
        this.currentFactoryXML = describeType(type).factory[0];
        var result:TypeDescription = new TypeDescription(false);
        this.addCtorInjectionPoint(result, type);
        this.addFieldInjectionPoints(result);
        this.addMethodInjectionPoints(result);
        this.addPostConstructMethodPoints(result);
        this.addPreDestroyMethodPoints(result);
        this.currentFactoryXML = null;
        return result;
    }

    private function addCtorInjectionPoint(description:TypeDescription, cls:Class):void {
        var injectParameters:Dictionary;
        var parameters:Array;
        var node:XML = this.currentFactoryXML.constructor[0];
        if (!node) {
            if (this.currentFactoryXML.parent().@name == "Object" || this.currentFactoryXML.extendsClass.length() > 0) {
                description.ctor = new NoParamsConstructorInjectionPoint();
            }
            return;
        }
        injectParameters = this.extractNodeArguments(node.parent().metadata.arg);
        var parameterNames:Array = (injectParameters.name || "").split(",");
        var parameterNodes:XMLList = node.parameter;
        // If every parameter type is reported as "*", the type info isn't populated yet.
        if (parameterNodes.(@type == "*").length() == parameterNodes.@type.length()) {
            this.createDummyInstance(node, cls);
        }
        parameters = this.gatherMethodParameters(parameterNodes, parameterNames);
        var requiredParameters:uint = parameters.required;
        delete parameters.required;
        description.ctor = new ConstructorInjectionPoint(parameters, requiredParameters, injectParameters);
    }

    /** Collects the <arg key=... value=.../> nodes of a metadata tag; repeated keys are joined with commas. */
    private function extractNodeArguments(args:XMLList):Dictionary {
        var arg:XML;
        var key:String;
        var result:Dictionary = new Dictionary();
        var count:uint = args.length();
        var i:int = 0;
        while (i < count) {
            arg = args[i];
            key = arg.@key;
            result[key] = result[key] ? (result[key] + "," + arg.attribute("value")) : arg.attribute("value");
            i++;
        }
        return result;
    }

    private function addFieldInjectionPoints(description:TypeDescription):void {
        var node:XML;
        var mappingId:String;
        var propertyName:String;
        var injectParameters:Dictionary;
        var injectionPoint:PropertyInjectionPoint;
        for each (node in this.currentFactoryXML.*.(name() == "variable" || name() == "accessor").metadata.(@name == "Inject")) {
            mappingId = node.parent().@type + "|" + node.arg.(@key == "name").attribute("value");
            propertyName = node.parent().@name;
            injectParameters = this.extractNodeArguments(node.arg);
            injectionPoint = new PropertyInjectionPoint(mappingId, propertyName, (injectParameters.optional == "true"), injectParameters);
            description.addInjectionPoint(injectionPoint);
        }
    }

    private function addMethodInjectionPoints(description:TypeDescription):void {
        var node:XML;
        var injectParameters:Dictionary;
        var parameterNames:Array;
        var parameters:Array;
        var requiredParameters:uint;
        var injectionPoint:MethodInjectionPoint;
        for each (node in this.currentFactoryXML.method.metadata.(@name == "Inject")) {
            injectParameters = this.extractNodeArguments(node.arg);
            parameterNames = (injectParameters.name || "").split(",");
            parameters = this.gatherMethodParameters(node.parent().parameter, parameterNames);
            requiredParameters = parameters.required;
            delete parameters.required;
            injectionPoint = new MethodInjectionPoint(node.parent().@name, parameters, requiredParameters, (injectParameters.optional == "true"), injectParameters);
            description.addInjectionPoint(injectionPoint);
        }
    }

    private function addPostConstructMethodPoints(description:TypeDescription):void {
        var points:Array = this.gatherOrderedInjectionPointsForTag(PostConstructInjectionPoint, "PostConstruct");
        var i:int = 0;
        var count:int = points.length;
        while (i < count) {
            description.addInjectionPoint(points[i]);
            i++;
        }
    }

    /** Links the [PreDestroy] points into a list (description.__case is the head, ._jO_ the current tail). */
    private function addPreDestroyMethodPoints(description:TypeDescription):void {
        var points:Array = this.gatherOrderedInjectionPointsForTag(PreDestroyInjectionPoint, "PreDestroy");
        if (!points.length) {
            return;
        }
        description.preDestroyMethods = points[0];
        description.preDestroyMethods.last = points[0];
        var i:int = 1;
        var count:int = points.length;
        while (i < count) {
            description.preDestroyMethods.last.next = points[i];
            description.preDestroyMethods.last = points[i];
            i++;
        }
    }

    /**
     * Turns parameter nodes into mapping ids ("type|name"). The returned array also
     * carries a "required" property: the number of non-optional parameters.
     */
    private function gatherMethodParameters(parameterNodes:XMLList, parameterNames:Array):Array {
        var node:XML;
        var mappingName:String;
        var type:String;
        var optional:Boolean;
        var required:uint;
        var count:uint = parameterNodes.length();
        var parameters:Array = new Array(count);
        var i:int = 0;
        while (i < count) {
            node = parameterNodes[i];
            mappingName = (parameterNames[i] || "");
            type = node.@type;
            optional = (node.@optional == "true");
            if (type == "*") {
                if (!optional) {
                    throw new InjectorError('Error in method definition of injectee "' + this.currentFactoryXML.@type + "Required parameters can't have type \"*\".");
                }
                type = null;
            }
            if (!optional) {
                required++;
            }
            parameters[i] = type + "|" + mappingName;
            i++;
        }
        parameters.required = required;
        return parameters;
    }

    /** Collects the members tagged with the given metadata tag, sorted by their "order" argument. */
    private function gatherOrderedInjectionPointsForTag(injectionPointType:Class, tag:String):Array {
        var node:XML;
        var injectParameters:Dictionary;
        var parameterNames:Array;
        var parameters:Array;
        var requiredParameters:uint;
        var order:Number;
        var injectionPoints:Array = [];
        for each (node in this.currentFactoryXML..metadata.(@name == tag)) {
            injectParameters = this.extractNodeArguments(node.arg);
            parameterNames = (injectParameters.name || "").split(",");
            parameters = this.gatherMethodParameters(node.parent().parameter, parameterNames);
            requiredParameters = parameters.required;
            delete parameters.required;
            order = parseInt(node.arg.(@key == "order").@value);
            injectionPoints.push(new (injectionPointType)(node.parent().@name, parameters, requiredParameters, isNaN(order) ? int.MAX_VALUE : order));
        }
        if (injectionPoints.length > 0) {
            injectionPoints.sortOn("order", Array.NUMERIC);
        }
        return injectionPoints;
    }

    /**
     * describeType only reports a constructor's parameter types once an instance has been
     * created, so make one with null arguments and then re-read the description.
     */
    private function createDummyInstance(constructorNode:XML, clazz:Class):void {
        try {
            switch (constructorNode.children().length()) {
                case 0:
                    new (clazz)();
                    break;
                case 1:
                    new (clazz)(null);
                    break;
                case 2:
                    new (clazz)(null, null);
                    break;
                case 3:
                    new (clazz)(null, null, null);
                    break;
                case 4:
                    new (clazz)(null, null, null, null);
                    break;
                case 5:
                    new (clazz)(null, null, null, null, null);
                    break;
                case 6:
                    new (clazz)(null, null, null, null, null, null);
                    break;
                case 7:
                    new (clazz)(null, null, null, null, null, null, null);
                    break;
                case 8:
                    new (clazz)(null, null, null, null, null, null, null, null);
                    break;
                case 9:
                    new (clazz)(null, null, null, null, null, null, null, null, null);
                    break;
                case 10:
                    new (clazz)(null, null, null, null, null, null, null, null, null, null);
                    break;
            }
        } catch (error:Error) {
            trace("Exception caught while trying to create dummy instance for constructor "
                + "injection. It's almost certainly ok to ignore this exception, but you "
                + "might want to restructure your constructor to prevent errors from "
                + "happening. See the Swiftsuspenders documentation for more details.\n"
                + "The caught exception was:\n" + error);
        }
        constructorNode.setChildren(describeType(clazz).factory.constructor[0].children());
    }

}
}//package injection.reflection
