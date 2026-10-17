package com.company.assembleegameclient.util {
import com.company.assembleegameclient.map.GameMap;
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.GroundProperties;
import com.company.assembleegameclient.map.Square;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.AssetLibrary;
import com.company.util.BitmapUtil;
import com.company.util.PointUtil;
import com.company.util._kp;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

/**
 * Builds the bitmap for a ground tile by blending it with its neighbours (masked quadrants),
 * drawing edge / inner-corner textures, or composing four corner tiles.
 *
 * Neighbour layout used throughout (3x3 around the tile, row-major):
 *   0 1 2
 *   3 4 5      4 = the tile itself
 *   6 7 8
 */
public class TileRedrawer {

    private static const COMPOSITE_TILE_TYPE:int = 253;
    private static const NO_TILE:int = 0xFF;

    // Quadrants of an 8x8 tile: 0 = top-left, 1 = top-right, 2 = bottom-left, 3 = bottom-right.
    private static const RECT0:Rectangle = new Rectangle(0, 0, 4, 4);
    private static const RECT1:Rectangle = new Rectangle(4, 0, 4, 4);
    private static const RECT2:Rectangle = new Rectangle(0, 4, 4, 4);
    private static const RECT3:Rectangle = new Rectangle(4, 4, 4, 4);
    private static const POINT0:Point = new Point(0, 0);
    private static const POINT1:Point = new Point(4, 0);
    private static const POINT2:Point = new Point(0, 4);
    private static const POINT3:Point = new Point(4, 4);
    private static const QUADRANT_RECTS:Vector.<Rectangle> = new <Rectangle>[RECT0, RECT1, RECT2, RECT3];
    private static const QUADRANT_POINTS:Vector.<Point> = new <Point>[POINT0, POINT1, POINT2, POINT3];

    // Indices into each quadrant's mask set.
    private static const MASK_INNER:int = 0;
    private static const MASK_SIDE0:int = 1;
    private static const MASK_SIDE1:int = 2;
    private static const MASK_OUTER:int = 3;
    private static const MASK_INNER_P1:int = 4;
    private static const MASK_INNER_P2:int = 5;

    /** One mask set per quadrant (top-left, top-right, bottom-left, bottom-right). */
    private static const rotatedMasks_:Vector.<Vector.<_kp>> = buildRotatedMasks();

    private static var cacheByQuality_:Vector.<Object> = new <Object>[null, {}];

    public static function redraw(square:Square, cloneBase:Boolean):BitmapData {
        var neighbors:ByteArray;
        var result:BitmapData;
        if (Parameters._R_P_ == 0) {
            return null;
        }
        if (square.tileType_ == COMPOSITE_TILE_TYPE) {
            neighbors = getCompositeNeighbors(square);
        } else {
            if (square.props_.hasEdge_) {
                neighbors = getEdgeNeighbors(square);
            } else {
                neighbors = getBlendNeighbors(square);
            }
        }
        if (neighbors == null) {
            return null;
        }
        var cache:Object = cacheByQuality_[Parameters._R_P_];
        var key:String = String(neighbors);
        if (cache.hasOwnProperty(key)) {
            return cache[key];
        }
        if (square.tileType_ == COMPOSITE_TILE_TYPE) {
            result = drawCompositeTile(neighbors);
            cache[key] = result;
            return result;
        }
        if (square.props_.hasEdge_) {
            result = drawEdgedTile(neighbors);
            cache[key] = result;
            return result;
        }
        var blendTopLeft:Boolean;
        var blendTopRight:Boolean;
        var blendBottomLeft:Boolean;
        var blendBottomRight:Boolean;
        if (neighbors[1] != neighbors[4]) {
            blendTopLeft = true;
            blendTopRight = true;
        }
        if (neighbors[3] != neighbors[4]) {
            blendTopLeft = true;
            blendBottomLeft = true;
        }
        if (neighbors[5] != neighbors[4]) {
            blendTopRight = true;
            blendBottomRight = true;
        }
        if (neighbors[7] != neighbors[4]) {
            blendBottomLeft = true;
            blendBottomRight = true;
        }
        if (!blendTopLeft && neighbors[0] != neighbors[4]) {
            blendTopLeft = true;
        }
        if (!blendTopRight && neighbors[2] != neighbors[4]) {
            blendTopRight = true;
        }
        if (!blendBottomLeft && neighbors[6] != neighbors[4]) {
            blendBottomLeft = true;
        }
        if (!blendBottomRight && neighbors[8] != neighbors[4]) {
            blendBottomRight = true;
        }
        if (!blendTopLeft && !blendTopRight && !blendBottomLeft && !blendBottomRight) {
            cache[key] = null;
            return null;
        }
        var baseTexture:BitmapData = GroundLibrary.getBitmapData(square.tileType_);
        if (cloneBase) {
            result = baseTexture.clone();
        } else {
            result = new BitmapData(baseTexture.width, baseTexture.height, true, 0);
        }
        if (blendTopLeft) {
            blendQuadrant(result, RECT0, POINT0, rotatedMasks_[0], neighbors[4], neighbors[3], neighbors[0], neighbors[1]);
        }
        if (blendTopRight) {
            blendQuadrant(result, RECT1, POINT1, rotatedMasks_[1], neighbors[4], neighbors[1], neighbors[2], neighbors[5]);
        }
        if (blendBottomLeft) {
            blendQuadrant(result, RECT2, POINT2, rotatedMasks_[2], neighbors[4], neighbors[7], neighbors[6], neighbors[3]);
        }
        if (blendBottomRight) {
            blendQuadrant(result, RECT3, POINT3, rotatedMasks_[3], neighbors[4], neighbors[5], neighbors[8], neighbors[7]);
        }
        cache[key] = result;
        return result;
    }

    /**
     * Blends one quadrant of the tile with the neighbouring tiles' textures.
     *
     * @param center tile type of this tile
     * @param sideA  tile type of the first adjacent side neighbour
     * @param corner tile type of the diagonal neighbour
     * @param sideB  tile type of the second adjacent side neighbour
     */
    private static function blendQuadrant(target:BitmapData, rect:Rectangle, destPoint:Point, masks:Vector.<_kp>, center:uint, sideA:uint, corner:uint, sideB:uint):void {
        var texture:BitmapData;
        var mask:BitmapData;
        if (center == sideA && center == sideB) {
            mask = masks[MASK_OUTER].random();
            texture = GroundLibrary.getBitmapData(corner);
        } else {
            if (center != sideA && center != sideB) {
                if (sideA != sideB) {
                    target.copyPixels(GroundLibrary.getBitmapData(sideA), rect, destPoint, masks[MASK_INNER_P1].random(), POINT0, true);
                    target.copyPixels(GroundLibrary.getBitmapData(sideB), rect, destPoint, masks[MASK_INNER_P2].random(), POINT0, true);
                    return;
                }
                mask = masks[MASK_INNER].random();
                texture = GroundLibrary.getBitmapData(sideA);
            } else {
                if (center != sideA) {
                    mask = masks[MASK_SIDE0].random();
                    texture = GroundLibrary.getBitmapData(sideA);
                } else {
                    mask = masks[MASK_SIDE1].random();
                    texture = GroundLibrary.getBitmapData(sideB);
                }
            }
        }
        target.copyPixels(texture, rect, destPoint, mask, POINT0, true);
    }

    /** Tile types of the 3x3 neighbourhood; neighbours that are off-map or lower priority count as this tile's type. */
    private static function getBlendNeighbors(square:Square):ByteArray {
        var x:int;
        var neighbor:Square;
        var neighbors:ByteArray = new ByteArray();
        var map:GameMap = square.map_;
        var tileType:uint = square.tileType_;
        var y:int = (square.y_ - 1);
        while (y <= (square.y_ + 1)) {
            x = (square.x_ - 1);
            while (x <= (square.x_ + 1)) {
                if ((x < 0 || x >= map.width_ || y < 0 || y >= map.height_ || (x == square.x_ && y == square.y_))) {
                    neighbors.writeByte(tileType);
                } else {
                    neighbor = map.squares_[(x + (y * map.width_))];
                    if (neighbor == null || neighbor.props_.blendPriority_ <= square.props_.blendPriority_) {
                        neighbors.writeByte(tileType);
                    } else {
                        neighbors.writeByte(neighbor.tileType_);
                    }
                }
                x++;
            }
            y++;
        }
        return neighbors;
    }

    private static function buildRotatedMasks():Vector.<Vector.<_kp>> {
        var masks:Vector.<Vector.<_kp>> = new Vector.<Vector.<_kp>>();
        addRotatedMasks(masks, AssetLibrary._18("inner_mask"), AssetLibrary._18("sides_mask"), AssetLibrary._18("outer_mask"), AssetLibrary._18("innerP1_mask"), AssetLibrary._18("innerP2_mask"));
        return masks;
    }

    /** Pushes one mask set per quadrant, each rotated to match that quadrant. */
    private static function addRotatedMasks(target:Vector.<Vector.<_kp>>, inner:_kp, sides:_kp, outer:_kp, innerP1:_kp, innerP2:_kp):void {
        var rotation:int;
        for each (rotation in [-1, 0, 2, 1]) {
            target.push(new <_kp>[rotateMasks(inner, rotation), rotateMasks(sides, (rotation - 1)), rotateMasks(sides, rotation), rotateMasks(outer, rotation), rotateMasks(innerP1, rotation), rotateMasks(innerP2, rotation)]);
        }
    }

    private static function rotateMasks(masks:_kp, rotation:int):_kp {
        var mask:BitmapData;
        var rotated:_kp = new _kp();
        for each (mask in masks._W_u) {
            rotated.add(BitmapUtil._c(mask, rotation));
        }
        return rotated;
    }

    /** Priority of a composite-tile neighbour, or -1 if there is none. */
    private static function compositePriority(square:Square):int {
        return (square != null) ? square.props_.compositePriority_ : -1;
    }

    /** Picks the tile type for one corner of a composite tile from its two adjacent side neighbours. */
    private static function resolveCompositeCorner(map:GameMap, cornerX:int, cornerY:int, sideA:Square, sideB:Square):uint {
        var corner:Square;
        var priorityA:int = compositePriority(sideA);
        var priorityB:int = compositePriority(sideB);
        if (priorityA < 0 && priorityB < 0) {
            corner = map.lookupSquare(cornerX, cornerY);
            return (corner == null || corner.props_.compositePriority_ < 0) ? NO_TILE : corner.tileType_;
        }
        return (priorityA < priorityB) ? sideB.tileType_ : sideA.tileType_;
    }

    /** Four tile types, one per corner (top-left, top-right, bottom-left, bottom-right); NO_TILE (0xFF) = empty. */
    private static function getCompositeNeighbors(square:Square):ByteArray {
        var corners:ByteArray = new ByteArray();
        corners.length = 4;
        var map:GameMap = square.map_;
        var x:int = square.x_;
        var y:int = square.y_;
        var top:Square = map.lookupSquare(x, (y - 1));
        var left:Square = map.lookupSquare((x - 1), y);
        var right:Square = map.lookupSquare((x + 1), y);
        var bottom:Square = map.lookupSquare(x, (y + 1));
        corners[0] = resolveCompositeCorner(map, (x - 1), (y - 1), top, left);
        corners[1] = resolveCompositeCorner(map, (x + 1), (y - 1), top, right);
        corners[2] = resolveCompositeCorner(map, (x - 1), (y + 1), left, bottom);
        corners[3] = resolveCompositeCorner(map, (x + 1), (y + 1), right, bottom);
        return corners;
    }

    private static function drawCompositeTile(corners:ByteArray):BitmapData {
        var texture:BitmapData;
        var result:BitmapData = new BitmapData(8, 8, false, 0);
        var i:int = 0;
        while (i < 4) {
            if (corners[i] != NO_TILE) {
                texture = GroundLibrary.getBitmapData(corners[i]);
                result.copyPixels(texture, QUADRANT_RECTS[i], QUADRANT_POINTS[i]);
            }
            i++;
        }
        return result;
    }

    /**
     * For edged tiles: the 3x3 neighbourhood as booleans ("neighbour is the same / present"),
     * except index 4 which holds the tile's own type. Returns null if no edge needs drawing.
     */
    private static function getEdgeNeighbors(square:Square):ByteArray {
        var x:int;
        var neighbor:Square;
        var matches:Boolean;
        var neighbors:ByteArray = new ByteArray();
        var map:GameMap = square.map_;
        var needsEdge:Boolean;
        var sameTypeMode:Boolean = square.props_.sameTypeEdgeMode_;
        var y:int = (square.y_ - 1);
        while (y <= (square.y_ + 1)) {
            x = (square.x_ - 1);
            while (x <= (square.x_ + 1)) {
                neighbor = map.lookupSquare(x, y);
                if (x == square.x_ && y == square.y_) {
                    neighbors.writeByte(neighbor.tileType_);
                } else {
                    if (sameTypeMode) {
                        matches = (neighbor == null || neighbor.tileType_ == square.tileType_);
                    } else {
                        matches = (neighbor == null || neighbor.tileType_ != NO_TILE);
                    }
                    neighbors.writeBoolean(matches);
                    needsEdge = (needsEdge || !matches);
                }
                x++;
            }
            y++;
        }
        return (needsEdge) ? neighbors : null;
    }

    private static function drawEdgedTile(neighbors:ByteArray):BitmapData {
        var baseTexture:BitmapData = GroundLibrary.getBitmapData(neighbors[4]);
        var result:BitmapData = baseTexture.clone();
        var props:GroundProperties = GroundLibrary.propsLibrary_[neighbors[4]];
        var edges:Vector.<BitmapData> = props.getEdgeTextures();
        var innerCorners:Vector.<BitmapData> = props.getInnerCornerTextures();
        var i:int = 1;
        while (i < 8) {
            if (!neighbors[i]) {
                stamp(result, edges[i]);
            }
            i = (i + 2);
        }
        if (edges[0] != null) {
            if (neighbors[3] && neighbors[1] && !neighbors[0]) {
                stamp(result, edges[0]);
            }
            if (neighbors[1] && neighbors[5] && !neighbors[2]) {
                stamp(result, edges[2]);
            }
            if (neighbors[5] && neighbors[7] && !neighbors[8]) {
                stamp(result, edges[8]);
            }
            if (neighbors[3] && neighbors[7] && !neighbors[6]) {
                stamp(result, edges[6]);
            }
        }
        if (innerCorners != null) {
            if (!neighbors[3] && !neighbors[1]) {
                stamp(result, innerCorners[0]);
            }
            if (!neighbors[1] && !neighbors[5]) {
                stamp(result, innerCorners[2]);
            }
            if (!neighbors[5] && !neighbors[7]) {
                stamp(result, innerCorners[8]);
            }
            if (!neighbors[3] && !neighbors[7]) {
                stamp(result, innerCorners[6]);
            }
        }
        return result;
    }

    /** Alpha-composites a full-size overlay texture onto the target. */
    private static function stamp(target:BitmapData, overlay:BitmapData):void {
        target.copyPixels(overlay, overlay.rect, PointUtil._P_5, null, null, true);
    }

}
}
