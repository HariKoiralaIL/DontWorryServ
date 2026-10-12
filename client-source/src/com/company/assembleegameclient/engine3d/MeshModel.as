package com.company.assembleegameclient.engine3d {
import com.company.util.ConversionUtil;

/** A 3D model parsed from Wavefront OBJ text and cached by name. */
public class MeshModel {

    private static var models_:Object = {};

    /** Parses OBJ text and caches the model under name. Silently ignores malformed input. */
    public static function parseObj(name:String, objText:String):void {
        var lines:Array = objText.split(/\s*\n\s*/);
        var positions:Array = [];
        var uvs:Array = [];
        var vertexKeys:Array = [];
        var vertexIndexByKey:Object = {};
        var faces:Array = [];
        var faceMaterials:Array = [];
        var material:String = null;

        for each (var line:String in lines) {
            if (line.length == 0 || line.charAt(0) == "#") {
                continue;
            }
            var args:Array = line.split(/\s+/);
            var directive:String = args.shift();
            if (directive.length == 0) {
                continue;
            }
            switch (directive) {
                case "v":
                    if (args.length != 3) {
                        return;
                    }
                    positions.push(args);
                    break;
                case "vt":
                    if (args.length != 2) {
                        return;
                    }
                    uvs.push(args);
                    break;
                case "f":
                    if (args.length < 3) {
                        return;
                    }
                    faces.push(args);
                    faceMaterials.push(material);
                    for each (var key:String in args) {
                        if (!vertexIndexByKey.hasOwnProperty(key)) {
                            vertexIndexByKey[key] = vertexKeys.length;
                            vertexKeys.push(key);
                        }
                    }
                    break;
                case "usemtl":
                    if (args.length != 1) {
                        return;
                    }
                    material = args[0];
                    break;
            }
        }

        var model:MeshModel = new MeshModel();
        for each (var vertexKey:String in vertexKeys) {
            var parts:Array = vertexKey.split("/");
            ConversionUtil._gM_(positions[int(parts[0]) - 1], model.vertices_);
            if (parts.length > 1 && parts[1].length > 0) {
                ConversionUtil._gM_(uvs[int(parts[1]) - 1], model.uvts_);
                model.uvts_.push(0);
            } else {
                model.uvts_.push(0, 0, 0);
            }
        }
        for (var i:int = 0; i < faces.length; i++) {
            var faceKeys:Array = faces[i];
            var faceMaterial:String = faceMaterials[i];
            var indices:Vector.<int> = new Vector.<int>();
            for each (var faceKey:String in faceKeys) {
                indices.push(vertexIndexByKey[faceKey]);
            }
            var textured:Boolean = faceMaterial == null || faceMaterial.substr(0, 5) != "Solid";
            model.faces_.push(new ModelFace(model, indices, textured));
        }
        model.sortFaces();
        models_[name] = model;
    }

    public static function getModel(name:String):MeshModel {
        return models_[name];
    }

    public static function createObject3D(name:String):Object3D {
        var model:MeshModel = models_[name];
        if (model == null) {
            return null;
        }
        return new Object3D(model);
    }

    /** Flat [x,y,z,...] vertex positions. */
    public var vertices_:Vector.<Number> = new Vector.<Number>();
    /** Flat [u,v,t,...] texture coordinates, one triple per vertex. */
    public var uvts_:Vector.<Number> = new Vector.<Number>();
    public var faces_:Vector.<ModelFace> = new Vector.<ModelFace>();

    public function sortFaces():void {
        this.faces_.sort(ModelFace.compareDepth);
    }

    public function toString():String {
        var result:String = "";
        result += "vertices(" + this.vertices_.length + "): " + this.vertices_.join() + "\n";
        result += "uvts(" + this.uvts_.length + "): " + this.uvts_.join() + "\n";
        result += "faces_(" + this.faces_.length + "): " + this.faces_.join() + "\n";
        return result;
    }

}
}
