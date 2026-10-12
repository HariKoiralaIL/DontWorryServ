package com.company.net {
import com.hurlant.crypto.Crypto;
import com.hurlant.crypto.symmetric.ICipher;
import com.hurlant.crypto.symmetric.IPad;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class ServerConnection extends EventDispatcher {

    // Packet layout: [int length][byte messageId][payload]; length includes the 5 header bytes.
    private static const LENGTH_FIELD_SIZE:int = 4;
    private static const HEADER_SIZE:int = 5;
    private static const NO_PENDING_PACKET:int = -1;

    private var sendStartTag_:Boolean;
    private var socket_:Socket = null;
    private var pendingPacketLength_:int = NO_PENDING_PACKET;
    private var host_:String;
    private var port_:int;
    private var registrations_:Dictionary = new Dictionary();
    private var sendQueue_:Vector.<NetworkMessage> = new Vector.<NetworkMessage>();
    private var outgoingCipher_:ICipher = null;
    private var incomingCipher_:ICipher = null;

    public function ServerConnection(sendStartTag:Boolean = true) {
        super();
        this.sendStartTag_ = sendStartTag;
    }

    public function setOutgoingCipher(name:String, key:ByteArray, pad:IPad = null):void {
        this.outgoingCipher_ = Crypto.getCipher(name, key, pad);
    }

    public function setIncomingCipher(name:String, key:ByteArray, pad:IPad = null):void {
        this.incomingCipher_ = Crypto.getCipher(name, key, pad);
    }

    public function registerMessage(id:uint, messageClass:Class, handler:Function):void {
        this.registrations_[id] = new MessageRegistration(messageClass, handler);
    }

    public function connect(host:String, port:int):void {
        if (this.socket_ != null) {
            this.disconnect();
        }
        this.host_ = host;
        this.port_ = port;
        this.pendingPacketLength_ = NO_PENDING_PACKET;
        this.socket_ = new Socket();
        this.socket_.connect(host, port);
        this.addSocketListeners();
    }

    public function reconnect():void {
        this.connect(this.host_, this.port_);
    }

    public function disconnect():void {
        if (this.socket_ == null) {
            return;
        }
        if (this.socket_.connected) {
            this.socket_.close();
        }
        this.removeSocketListeners();
        this.socket_ = null;
        this.sendQueue_.length = 0;
    }

    public function sendMessage(message:NetworkMessage):void {
        this.sendQueue_.push(message);
        this.flushSendQueue();
    }

    /** Returns a pooled (or new) message instance for the id, or null if the id is unregistered. */
    public function acquireMessage(id:uint):NetworkMessage {
        var registration:MessageRegistration = this.registrations_[id];
        if (registration == null) {
            return null;
        }
        if (registration.pool_.length > 0) {
            return registration.pool_.pop();
        }
        return registration.messageClass_ == null
            ? new NetworkMessage(id)
            : new registration.messageClass_(id);
    }

    public function releaseMessage(message:NetworkMessage):void {
        this.registrations_[message.id_].pool_.push(message);
    }

    private function addSocketListeners():void {
        this.socket_.addEventListener(Event.CONNECT, this.onConnect);
        this.socket_.addEventListener(Event.CLOSE, this.onClose);
        this.socket_.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
        this.socket_.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
        this.socket_.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
    }

    private function removeSocketListeners():void {
        this.socket_.removeEventListener(Event.CONNECT, this.onConnect);
        this.socket_.removeEventListener(Event.CLOSE, this.onClose);
        this.socket_.removeEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
        this.socket_.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
        this.socket_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
    }

    private function isSocketOpen():Boolean {
        return this.socket_ != null && this.socket_.connected;
    }

    private function flushSendQueue():void {
        if (!this.isSocketOpen()) {
            return;
        }
        for each (var message:NetworkMessage in this.sendQueue_) {
            var payload:ByteArray = new ByteArray();
            message.writeToOutput(payload);
            payload.position = 0;
            if (this.outgoingCipher_ != null) {
                this.outgoingCipher_.encrypt(payload);
                payload.position = 0;
            }
            this.socket_.writeInt(payload.bytesAvailable + HEADER_SIZE);
            this.socket_.writeByte(message.id_);
            this.socket_.writeBytes(payload);
            this.releaseMessage(message);
        }
        this.socket_.flush();
        this.sendQueue_.length = 0;
    }

    private function closeAndNotify():void {
        this.disconnect();
        dispatchEvent(new Event(Event.CLOSE));
    }

    private function dispatchError(text:String):void {
        trace(text);
        dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, text));
        dispatchEvent(new Event(Event.CLOSE));
    }

    private function onConnect(event:Event):void {
        if (this.sendStartTag_) {
            this.socket_.writeMultiByte("<start/>", "utf-8");
            this.socket_.writeByte(0);
        }
        this.flushSendQueue();
        dispatchEvent(event);
    }

    private function onClose(event:Event):void {
        trace("Lost connection to server");
        dispatchEvent(new Event(Event.CLOSE));
    }

    private function onIOError(event:IOErrorEvent):void {
        this.dispatchError("IO Error: " + event.text);
    }

    private function onSecurityError(event:SecurityErrorEvent):void {
        this.dispatchError("Server crashed.. " + event.text);
    }

    private function onSocketData(event:ProgressEvent):void {
        while (this.isSocketOpen()) {
            if (this.pendingPacketLength_ == NO_PENDING_PACKET) {
                if (this.socket_.bytesAvailable < LENGTH_FIELD_SIZE) {
                    break;
                }
                try {
                    this.pendingPacketLength_ = this.socket_.readInt();
                } catch (error:Error) {
                    trace(error.name + ": " + error.message);
                    this.pendingPacketLength_ = NO_PENDING_PACKET;
                    return;
                }
            }
            if (this.socket_.bytesAvailable < this.pendingPacketLength_ - LENGTH_FIELD_SIZE) {
                break;
            }

            var messageId:uint = this.socket_.readUnsignedByte();
            var message:NetworkMessage = this.acquireMessage(messageId);
            var payload:ByteArray = new ByteArray();
            var payloadLength:int = this.pendingPacketLength_ - HEADER_SIZE;
            if (payloadLength > 0) {
                this.socket_.readBytes(payload, 0, payloadLength);
            }
            payload.position = 0;
            if (this.incomingCipher_ != null) {
                this.incomingCipher_.decrypt(payload);
                payload.position = 0;
            }
            this.pendingPacketLength_ = NO_PENDING_PACKET;

            if (message == null) {
                trace("Unknown message in protocol, bailing");
                this.closeAndNotify();
                return;
            }
            try {
                message.parseFromInput(payload);
            } catch (e:Error) {
                trace("Error in protocol: " + e.toString());
                this.closeAndNotify();
                return;
            }
            this.registrations_[messageId].handler_(message);
            this.releaseMessage(message);
        }
    }

}
}

/** Per-message-id registration: class to instantiate, free-list pool, and receive handler. */
class MessageRegistration {

    public var messageClass_:Class;
    public var pool_:Vector.<com.company.net.NetworkMessage> = new Vector.<com.company.net.NetworkMessage>();
    public var handler_:Function;

    public function MessageRegistration(messageClass:Class, handler:Function) {
        this.messageClass_ = messageClass;
        this.handler_ = handler;
    }
}
