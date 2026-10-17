package com.company.assembleegameclient.util {
import flash.utils.Dictionary;

/** Simple per-class object pool. */
public class ObjectPool {

    private static var pools_:Dictionary = new Dictionary();

    /** Returns a pooled instance of the class, or creates a new one if the pool is empty. */
    public static function getOrCreate(type:Class):Object {
        var pool:Vector.<Object> = pools_[type];
        if (pool == null) {
            pool = new Vector.<Object>();
            pools_[type] = pool;
        } else {
            if (pool.length > 0) {
                return pool.pop();
            }
        }
        return new type();
    }

    /** Returns an instance to the pool of the given class. */
    public static function release(type:*, instance:Object):void {
        var pool:Vector.<Object> = pools_[type];
        if (pool == null) {
            pool = new Vector.<Object>();
            pools_[type] = pool;
        }
        pool.push(instance);
    }

    /** Returns an instance to the pool of its own class (taken from its constructor). */
    public static function releaseInstance(instance:Object):void {
        var type:Class = Object(instance).constructor;
        var pool:Vector.<Object> = pools_[type];
        if (pool == null) {
            pool = new Vector.<Object>();
            pools_[type] = pool;
        }
        pool.push(instance);
    }

    /** Returns a pooled instance, or null if the pool is empty. */
    public static function getObject(type:*):Object {
        var pool:Vector.<Object> = pools_[type];
        if (pool != null && pool.length > 0) {
            return pool.pop();
        }
        return null;
    }

    /** Discards the whole pool for the given class. */
    public static function dump(type:*):void {
        delete pools_[type];
    }

}
}
