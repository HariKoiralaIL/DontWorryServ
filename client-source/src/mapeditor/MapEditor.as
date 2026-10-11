package mapeditor {
import _F_1._05p;

import _zm.DropdownBox;

import client.debug.Stats;

import com.company.assembleegameclient.map._pf;
import com.company.assembleegameclient.map._sn;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.util.IntPoint;
import com.company.util._O_m;
import com.hurlant.util.Base64;

import editorcommands.CommandEvent;
import editorcommands.CommandList;
import editorcommands.CommandQueue;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.Rectangle;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.utils.ByteArray;

import jsonserializer.IJsonSerializer;
import jsonserializer.JsonSerializerProvider;

/**
 * The map editor screen: toolbar, map canvas, info panel and the
 * ground / object / region palettes. Handles undo/redo, save, load and test.
 */
public class MapEditor extends _05p {

    private static const MAP_Y:int = ((600 - MapCanvas.VIEW_SIZE) - 10);
    public static const STATS:Stats = new Stats();
    private static const JSON_SERIALIZER:IJsonSerializer = JsonSerializerProvider.getSerializer();

    private static const GROUND_LABEL:String = "Ground";
    private static const OBJECTS_LABEL:String = "Objects";
    private static const REGIONS_LABEL:String = "Regions";

    public function MapEditor() {
        addChild(new _charscreen());
        super(null);
        this.toolbar_ = new EditorToolbar();
        this.toolbar_.x = 15;
        this.toolbar_.y = MAP_Y;
        this.toolbar_.addEventListener(CommandEvent.UNDO_COMMAND_EVENT, this.onUndo);
        this.toolbar_.addEventListener(CommandEvent.REDO_COMMAND_EVENT, this.onRedo);
        this.toolbar_.addEventListener(CommandEvent.CLEAR_COMMAND_EVENT, this.onClear);
        this.toolbar_.addEventListener(CommandEvent.LOAD_COMMAND_EVENT, this.onLoad);
        this.toolbar_.addEventListener(CommandEvent.SAVE_COMMAND_EVENT, this.onSave);
        this.toolbar_.addEventListener(CommandEvent.TEST_COMMAND_EVENT, this.onTest);
        addChild(this.toolbar_);
        this.commandQueue_ = new CommandQueue();
        this.map_ = new MapCanvas();
        this.map_.addEventListener(TilesEvent.TILES_EVENT, this.onTilesEvent);
        this.map_.x = ((800 / 2) - (MapCanvas.VIEW_SIZE / 2));
        this.map_.y = MAP_Y;
        addChild(this.map_);
        this.infoPanel_ = new TileInfoPanel(this.map_);
        this.infoPanel_.x = 4;
        this.infoPanel_.y = ((600 - TileInfoPanel.HEIGHT) - 10);
        addChild(this.infoPanel_);
        this.layerDropdown_ = new DropdownBox(new <String>[GROUND_LABEL, OBJECTS_LABEL, REGIONS_LABEL], Chooser.WIDTH, 26);
        this.layerDropdown_.x = ((this.map_.x + MapCanvas.VIEW_SIZE) + 4);
        this.layerDropdown_.y = MAP_Y;
        this.layerDropdown_.addEventListener(Event.CHANGE, this.onLayerChange);
        addChild(this.layerDropdown_);
        this.groundChooser_ = new GroundChooser();
        this.groundChooser_.x = this.layerDropdown_.x;
        this.groundChooser_.y = ((this.layerDropdown_.y + this.layerDropdown_.height) + 4);
        this.activeChooser_ = this.groundChooser_;
        addChild(this.groundChooser_);
        this.objectChooser_ = new ObjectChooser();
        this.objectChooser_.x = this.layerDropdown_.x;
        this.objectChooser_.y = ((this.layerDropdown_.y + this.layerDropdown_.height) + 4);
        this.regionChooser_ = new RegionChooser();
        this.regionChooser_.x = this.layerDropdown_.x;
        this.regionChooser_.y = ((this.layerDropdown_.y + this.layerDropdown_.height) + 4);

        super._0_4.x = ((800 - super._0_4.width) - 10);
        super._0_4.y = 2;
    }
    public var toolbar_:EditorToolbar;
    public var map_:MapCanvas;
    public var infoPanel_:TileInfoPanel;
    public var layerDropdown_:DropdownBox;
    public var groundChooser_:GroundChooser;
    public var objectChooser_:ObjectChooser;
    public var regionChooser_:RegionChooser;
    /** The palette of the layer currently being edited. */
    public var activeChooser_:Chooser;
    /** Name of the last loaded map file (used as the default save name). */
    public var filename_:String = null;
    private var commandQueue_:CommandQueue;
    private var loadFileRef_:FileReference = null;

    /** Sets `newType` on `layer` for all given tiles as one undoable step. */
    private function setTilesType(tiles:Vector.<IntPoint>, layer:int, newType:int):void {
        var tile:IntPoint;
        var oldType:int;
        var commands:CommandList = new CommandList();
        for each (tile in tiles) {
            oldType = this.map_.getType(tile.x_, tile.y_, layer);
            if (oldType != newType) {
                commands.addCommand(new SetTileTypeCommand(this.map_, tile.x_, tile.y_, layer, oldType, newType));
            }
        }
        if (commands.isEmpty()) {
            return;
        }
        this.commandQueue_.addCommandList(commands);
    }

    /** Sets the object name on all given tiles as one undoable step. */
    private function setTilesObjectName(tiles:Vector.<IntPoint>, newName:String):void {
        var tile:IntPoint;
        var oldName:String;
        var commands:CommandList = new CommandList();
        for each (tile in tiles) {
            oldName = this.map_.getObjectName(tile.x_, tile.y_);
            if (oldName != newName) {
                commands.addCommand(new SetObjectNameCommand(this.map_, tile.x_, tile.y_, oldName, newName));
            }
        }
        if (commands.isEmpty()) {
            return;
        }
        this.commandQueue_.addCommandList(commands);
    }

    /**
     * Serializes the map to the JSON map format: width/height, a dictionary of the
     * distinct tile definitions, and a compressed base64 array of 16-bit dictionary
     * indices (row by row). Returns null if the map is empty.
     */
    private function serializeMap():String {
        var tileX:int;
        var tile:MapTile;
        var tileJson:Object;
        var tileKey:String;
        var dictIndex:int;
        var bounds:Rectangle = this.map_.getContentBounds();
        if (bounds == null) {
            return (null);
        }
        var mapJson:Object = {};
        mapJson["width"] = int(bounds.width);
        mapJson["height"] = int(bounds.height);
        var indexByKey:Object = {};
        var dict:Array = [];
        var data:ByteArray = new ByteArray();
        var tileY:int = bounds.y;
        while (tileY < bounds.bottom) {
            tileX = bounds.x;
            while (tileX < bounds.right) {
                tile = this.map_.getTile(tileX, tileY);
                tileJson = this.tileToJson(tile);
                tileKey = JSON_SERIALIZER.stringify(tileJson);
                if (!indexByKey.hasOwnProperty(tileKey)) {
                    dictIndex = dict.length;
                    indexByKey[tileKey] = dictIndex;
                    dict.push(tileJson);
                } else {
                    dictIndex = indexByKey[tileKey];
                }
                data.writeShort(dictIndex);
                tileX++;
            }
            tileY++;
        }
        mapJson["dict"] = dict;
        data.compress();
        mapJson["data"] = Base64.encodeByteArray(data);
        return (JSON_SERIALIZER.stringify(mapJson));
    }

    private function tileToJson(tile:MapTile):Object {
        var types:Vector.<int>;
        var id:String;
        var objectJson:Object;
        var json:Object = {};
        if (tile != null) {
            types = tile.types_;
            if (types[MapLayer.GROUND] != -1) {
                id = _pf._6H_(types[MapLayer.GROUND]);
                json["ground"] = id;
            }
            if (types[MapLayer.OBJECT] != -1) {
                id = ObjectLibrary._6H_(types[MapLayer.OBJECT]);
                objectJson = {"id": id};
                if (tile.objectName_ != null) {
                    objectJson["name"] = tile.objectName_;
                }
                json["objs"] = [objectJson];
            }
            if (types[MapLayer.REGION] != -1) {
                id = _sn._6H_(types[MapLayer.REGION]);
                json["regions"] = [
                    {"id": id}
                ];
            }
        }
        return (json);
    }

    /** Applies the selected tool to the clicked tiles. */
    private function onTilesEvent(event:TilesEvent):void {
        var sampledType:int;
        var objectName:String;
        var overlay:TilePropertiesOverlay;
        var firstTile:IntPoint = event.tiles_[0];
        switch (this.toolbar_.getSelectedValue()) {
            case EditorToolbar.TOOL_DRAW:
                this.setTilesType(event.tiles_, this.activeChooser_.layer_, this.activeChooser_.getSelectedType());
                break;
            case EditorToolbar.TOOL_ERASE:
                this.setTilesType(event.tiles_, this.activeChooser_.layer_, -1);
                break;
            case EditorToolbar.TOOL_SAMPLE:
                sampledType = this.map_.getType(firstTile.x_, firstTile.y_, this.activeChooser_.layer_);
                if (sampledType == -1) {
                    return;
                }
                this.activeChooser_.selectType(sampledType);
                this.toolbar_.selectByValue(EditorToolbar.TOOL_DRAW);
                break;
            case EditorToolbar.TOOL_EDIT:
                objectName = this.map_.getObjectName(firstTile.x_, firstTile.y_);
                overlay = new TilePropertiesOverlay(event.tiles_, objectName);
                overlay.addEventListener(Event.COMPLETE, this.onTilePropertiesComplete);
                addChild(overlay);
                break;
        }
        this.map_.draw();
    }

    private function onTilePropertiesComplete(event:Event):void {
        var overlay:TilePropertiesOverlay = (event.currentTarget as TilePropertiesOverlay);
        this.setTilesObjectName(overlay.tiles_, overlay.getObjectName());
    }

    /** Shows the palette matching the dropdown selection and hides the others. */
    private function onLayerChange(event:Event):void {
        switch (this.layerDropdown_.getValue()) {
            case GROUND_LABEL:
                this.showChooser(this.groundChooser_);
                return;
            case OBJECTS_LABEL:
                this.showChooser(this.objectChooser_);
                return;
            case REGIONS_LABEL:
                this.showChooser(this.regionChooser_);
                return;
        }
    }

    private function showChooser(chooser:Chooser):void {
        this.setChooserShown(this.groundChooser_, (chooser == this.groundChooser_));
        this.setChooserShown(this.objectChooser_, (chooser == this.objectChooser_));
        this.setChooserShown(this.regionChooser_, (chooser == this.regionChooser_));
        this.activeChooser_ = chooser;
    }

    private function setChooserShown(chooser:Chooser, shown:Boolean):void {
        if (shown) {
            _O_m._041(this, chooser);
        } else {
            _O_m._03d(this, chooser);
        }
    }

    private function onUndo(event:CommandEvent):void {
        this.commandQueue_.undo();
        this.map_.draw();
    }

    private function onRedo(event:CommandEvent):void {
        this.commandQueue_.redo();
        this.map_.draw();
    }

    /** Removes every tile (undoable) and forgets the loaded file name. */
    private function onClear(event:CommandEvent):void {
        var position:IntPoint;
        var tile:MapTile;
        var positions:Vector.<IntPoint> = this.map_.getTilePositions();
        var commands:CommandList = new CommandList();
        for each (position in positions) {
            tile = this.map_.getTile(position.x_, position.y_);
            if (tile != null) {
                commands.addCommand(new RemoveTileCommand(this.map_, position.x_, position.y_, tile));
            }
        }
        if (commands.isEmpty()) {
            return;
        }
        this.commandQueue_.addCommandList(commands);
        this.map_.draw();
        this.filename_ = null;
    }

    private function onSave(event:CommandEvent):void {
        var mapJson:String = this.serializeMap();
        if (mapJson == null) {
            return;
        }
        new FileReference().save(mapJson, (((this.filename_ == null)) ? "map.jm" : this.filename_));
    }

    private function onLoad(event:CommandEvent):void {
        this.loadFileRef_ = new FileReference();
        this.loadFileRef_.addEventListener(Event.SELECT, this.onFileSelected);
        this.loadFileRef_.browse([new FileFilter("JSON Map (*.jm)", "*.jm")]);
    }

    private function onFileSelected(event:Event):void {
        var file:FileReference = (event.target as FileReference);
        file.addEventListener(Event.COMPLETE, this.onFileLoaded);
        file.addEventListener(IOErrorEvent.IO_ERROR, this.onFileLoadError);
        try {
            file.load();
        } catch (e:Error) {
        }
    }

    /** Parses a .jm map file and places its contents centered on the canvas. */
    private function onFileLoaded(event:Event):void {
        var type:int;
        var tileX:int;
        var tileJson:Object;
        var objectsJson:Array;
        var regionsJson:Array;
        var objectJson:Object;
        var regionJson:Object;
        var file:FileReference = (event.target as FileReference);
        this.filename_ = file.name;
        var mapJson:Object = JSON_SERIALIZER.parse(file.data.toString());
        var mapWidth:int = mapJson["width"];
        var mapHeight:int = mapJson["height"];
        var bounds:Rectangle = new Rectangle(int(((MapCanvas.MAP_SIZE / 2) - (mapWidth / 2))), int(((MapCanvas.MAP_SIZE / 2) - (mapHeight / 2))), mapWidth, mapHeight);
        this.map_.clear();
        this.commandQueue_.clear();
        var dict:Array = mapJson["dict"];
        var data:ByteArray = Base64.decodeToByteArray(mapJson["data"]);
        data.uncompress();
        var tileY:int = bounds.y;
        while (tileY < bounds.bottom) {
            tileX = bounds.x;
            while (tileX < bounds.right) {
                tileJson = dict[data.readShort()];
                if (tileJson.hasOwnProperty("ground")) {
                    type = _pf._pb[tileJson["ground"]];
                    this.map_.setType(tileX, tileY, MapLayer.GROUND, type);
                }
                objectsJson = tileJson["objs"];
                if (objectsJson != null) {
                    for each (objectJson in objectsJson) {
                        if (ObjectLibrary._pb.hasOwnProperty(objectJson["id"])) {
                            type = ObjectLibrary._pb[objectJson["id"]];
                            this.map_.setType(tileX, tileY, MapLayer.OBJECT, type);
                            if (objectJson.hasOwnProperty("name")) {
                                this.map_.setObjectName(tileX, tileY, objectJson["name"]);
                            }
                        }
                    }
                }
                regionsJson = tileJson["regions"];
                if (regionsJson != null) {
                    for each (regionJson in regionsJson) {
                        type = _sn._pb[regionJson["id"]];
                        this.map_.setType(tileX, tileY, MapLayer.REGION, type);
                    }
                }
                tileX++;
            }
            tileY++;
        }
        this.map_.draw();
    }

    private function onFileLoadError(event:Event):void {
        // intentionally ignored (matches original behavior)
    }

    private function onTest(event:Event):void {
        dispatchEvent(new MapTestEvent(this.serializeMap()));
    }

}
}
