package multipartupload {
import flash.events.EventDispatcher;
import flash.net.URLLoader;
import flash.utils.Dictionary;
import flash.utils.ByteArray;
import flash.errors.IllegalOperationError;
import flash.utils.clearInterval;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLRequestHeader;
import flash.utils.Endian;

import dataprepare.DataPrepareEvent;

import flash.events.ProgressEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.HTTPStatusEvent;
import flash.utils.setTimeout;

/**
 * Sends variables and files as a multipart/form-data POST.
 *
 * Synchronous use:  addVariable()/addFile(), then load(url).
 * Asynchronous use: addVariable()/addFile(), load(url, true) builds the request body in
 *                   chunks (PREPARE_PROGRESS / PREPARE_COMPLETE events), then startLoad() sends it.
 */
public class MultipartURLLoader extends EventDispatcher {

    /** How many bytes of a file are copied per step when preparing asynchronously. */
    public static var BLOCK_SIZE:uint = (64 * 0x0400);//65536

    /** Extra headers added to the request. */
    public var requestHeaders:Array;

    private var boundary:String;
    private var variableNames:Array;
    private var fileNames:Array;
    private var variables:Dictionary;
    private var files:Dictionary;
    private var asyncFlag:Boolean = false;
    private var path:String;
    private var _data:ByteArray;
    private var isPrepared:Boolean = false;
    private var asyncWriteTimeoutId:Number;
    /** Index of the next file to write while preparing asynchronously. */
    private var asyncFileIndex:uint = 0;
    private var totalFilesSize:uint = 0;
    /** Bytes of file content written so far while preparing asynchronously. */
    private var writtenBytes:uint = 0;

    private var _loader:URLLoader;

    public function MultipartURLLoader() {
        this.fileNames = [];
        this.files = new Dictionary();
        this.variableNames = [];
        this.variables = new Dictionary();
        this._loader = new URLLoader();
        this.requestHeaders = [];
    }

    public function get loader():URLLoader {
        return (this._loader);
    }

    /** True if the last load() call asked for asynchronous preparation. */
    public function get async():Boolean {
        return (this.asyncFlag);
    }

    /** True once the request body has been built (asynchronous mode). */
    public function get prepared():Boolean {
        return (this.isPrepared);
    }

    public function get dataFormat():String {
        return (this._loader.dataFormat);
    }

    public function set dataFormat(format:String):void {
        if (((((!((format == URLLoaderDataFormat.BINARY))) && (!((format == URLLoaderDataFormat.TEXT))))) && (!((format == URLLoaderDataFormat.VARIABLES))))) {
            throw (new IllegalOperationError("Illegal URLLoader Data Format"));
        }
        this._loader.dataFormat = format;
    }

    /**
     * Synchronous (asyncMode = false): builds the body and sends the request immediately.
     * Asynchronous: starts preparing the body (or sends if it is already prepared); call startLoad() when done.
     */
    public function load(url:String, asyncMode:Boolean = false):void {
        if ((((url == null)) || ((url == "")))) {
            throw (new IllegalOperationError("You cant load without specifing PATH"));
        }
        this.path = url;
        this.asyncFlag = asyncMode;
        if (this.asyncFlag) {
            if (!this.isPrepared) {
                this.constructPostDataAsync();
            } else {
                this.doSend();
            }
        } else {
            this._data = this.constructPostData();
            this.doSend();
        }
    }

    /** Sends the already prepared body (asynchronous mode only). */
    public function startLoad():void {
        if ((((((this.path == null)) || ((this.path == "")))) || ((this.asyncFlag == false)))) {
            throw (new IllegalOperationError("You can use this method only if loading asynchronous."));
        }
        if (((!(this.isPrepared)) && (this.asyncFlag))) {
            throw (new IllegalOperationError("You should prepare data before sending when using asynchronous."));
        }
        this.doSend();
    }

    /** Builds the request body in the background; dispatches DataPrepareEvent as it goes. */
    public function prepareData():void {
        this.constructPostDataAsync();
    }

    public function close():void {
        try {
            this._loader.close();
        } catch (e:Error) {
        }
    }

    public function addVariable(name:String, value:Object = ""):void {
        if (this.variableNames.indexOf(name) == -1) {
            this.variableNames.push(name);
        }
        this.variables[name] = value;
        this.isPrepared = false;
    }

    /** Adds a file part, or replaces the existing one with the same fileName. */
    public function addFile(fileContent:ByteArray, fileName:String, dataField:String = "Filedata", contentType:String = "application/octet-stream"):void {
        var existing:FilePart;
        if (this.fileNames.indexOf(fileName) == -1) {
            this.fileNames.push(fileName);
            this.files[fileName] = new FilePart(fileContent, fileName, dataField, contentType);
            this.totalFilesSize = (this.totalFilesSize + fileContent.length);
        } else {
            existing = (this.files[fileName] as FilePart);
            this.totalFilesSize = (this.totalFilesSize - existing.fileContent.length);
            existing.fileContent = fileContent;
            existing.fileName = fileName;
            existing.dataField = dataField;
            existing.contentType = contentType;
            this.totalFilesSize = (this.totalFilesSize + fileContent.length);
        }
        this.isPrepared = false;
    }

    public function clearVariables():void {
        this.variableNames = [];
        this.variables = new Dictionary();
        this.isPrepared = false;
    }

    public function clearFiles():void {
        var fileName:String;
        for each (fileName in this.fileNames) {
            (this.files[fileName] as FilePart).dispose();
        }
        this.fileNames = [];
        this.files = new Dictionary();
        this.totalFilesSize = 0;
        this.isPrepared = false;
    }

    public function dispose():void {
        clearInterval(this.asyncWriteTimeoutId);
        this.removeListeners();
        this.close();
        this._loader = null;
        this.boundary = null;
        this.variableNames = null;
        this.variables = null;
        this.fileNames = null;
        this.files = null;
        this.requestHeaders = null;
        this._data = null;
    }

    /** The random 32-letter boundary string, generated on first use. */
    public function getBoundary():String {
        var i:int;
        if (this.boundary == null) {
            this.boundary = "";
            i = 0;
            while (i < 32) {
                this.boundary = (this.boundary + String.fromCharCode(int((97 + (Math.random() * 25)))));
                i++;
            }
        }
        return (this.boundary);
    }

    private function doSend():void {
        var request:URLRequest = new URLRequest();
        request.url = this.path;
        request.method = URLRequestMethod.POST;
        request.data = this._data;
        request.requestHeaders.push(new URLRequestHeader("Content-type", ("multipart/form-data; boundary=" + this.getBoundary())));
        if (this.requestHeaders.length) {
            request.requestHeaders = request.requestHeaders.concat(this.requestHeaders);
        }
        this.addListeners();
        this._loader.load(request);
    }

    /** Writes the variables now, then queues the files to be copied in chunks. */
    private function constructPostDataAsync():void {
        clearInterval(this.asyncWriteTimeoutId);
        this._data = new ByteArray();
        this._data.endian = Endian.BIG_ENDIAN;
        this.writeVariables(this._data);
        this.asyncFileIndex = 0;
        this.writtenBytes = 0;
        this.isPrepared = false;
        if (this.fileNames.length) {
            this.writeNextFileAsync();
        } else {
            this.writeClosingBoundary(this._data);
            this.isPrepared = true;
            dispatchEvent(new DataPrepareEvent(DataPrepareEvent.PREPARE_COMPLETE));
        }
    }

    private function constructPostData():ByteArray {
        var data:ByteArray = new ByteArray();
        data.endian = Endian.BIG_ENDIAN;
        this.writeVariables(data);
        this.writeFiles(data);
        this.writeClosingBoundary(data);
        return (data);
    }

    /** Final boundary: "--" + boundary + "--". */
    private function writeClosingBoundary(data:ByteArray):void {
        this.writeBoundary(data);
        this.writeDoubleDash(data);
    }

    private function writeVariables(data:ByteArray):void {
        var name:String;
        for each (name in this.variableNames) {
            this.writeBoundary(data);
            this.writeLineBreak(data);
            this.writeAscii(data, (('Content-Disposition: form-data; name="' + name) + '"'));
            this.writeLineBreak(data);
            this.writeLineBreak(data);
            data.writeUTFBytes(this.variables[name]);
            this.writeLineBreak(data);
        }
    }

    private function writeFiles(data:ByteArray):void {
        var fileName:String;
        var index:uint;
        if (this.fileNames.length) {
            for each (fileName in this.fileNames) {
                this.writeFileHeader(data, (this.files[fileName] as FilePart));
                this.writeFileContent(data, (this.files[fileName] as FilePart));
                if (index != (this.fileNames.length - 1)) {
                    this.writeLineBreak(data);
                }
                index++;
            }
            this.writeUploadField(data);
        }
    }

    /** The trailing "Upload" / "Submit Query" form field that Flash's FileReference uploads also send. */
    private function writeUploadField(data:ByteArray):void {
        this.writeLineBreak(data);
        this.writeBoundary(data);
        this.writeLineBreak(data);
        this.writeAscii(data, 'Content-Disposition: form-data; name="Upload"');
        this.writeLineBreak(data);
        this.writeLineBreak(data);
        this.writeAscii(data, "Submit Query");
        this.writeLineBreak(data);
    }

    /** Writes the "Filename" field and the headers of the file part. */
    private function writeFileHeader(data:ByteArray, part:FilePart):void {
        this.writeBoundary(data);
        this.writeLineBreak(data);
        this.writeAscii(data, 'Content-Disposition: form-data; name="Filename"');
        this.writeLineBreak(data);
        this.writeLineBreak(data);
        data.writeUTFBytes(part.fileName);
        this.writeLineBreak(data);
        this.writeBoundary(data);
        this.writeLineBreak(data);
        this.writeAscii(data, (('Content-Disposition: form-data; name="' + part.dataField) + '"; filename="'));
        data.writeUTFBytes(part.fileName);
        this.writeQuote(data);
        this.writeLineBreak(data);
        this.writeAscii(data, ("Content-Type: " + part.contentType));
        this.writeLineBreak(data);
        this.writeLineBreak(data);
    }

    private function writeFileContent(data:ByteArray, part:FilePart):void {
        data.writeBytes(part.fileContent, 0, part.fileContent.length);
    }

    private function addListeners():void {
        this._loader.addEventListener(Event.COMPLETE, this.onComplete, false, 0, false);
        this._loader.addEventListener(ProgressEvent.PROGRESS, this.onProgress, false, 0, false);
        this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError, false, 0, false);
        this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus, false, 0, false);
        this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError, false, 0, false);
    }

    private function removeListeners():void {
        this._loader.removeEventListener(Event.COMPLETE, this.onComplete);
        this._loader.removeEventListener(ProgressEvent.PROGRESS, this.onProgress);
        this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
        this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus);
        this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
    }

    /** Writes "--" followed by the boundary string. */
    private function writeBoundary(data:ByteArray):void {
        var length:int = this.getBoundary().length;
        this.writeDoubleDash(data);
        var i:int;
        while (i < length) {
            data.writeByte(this.boundary.charCodeAt(i));
            i++;
        }
    }

    private function writeAscii(data:ByteArray, text:String):void {
        var i:uint;
        while (i < text.length) {
            data.writeByte(text.charCodeAt(i));
            i++;
        }
    }

    /** CR LF */
    private function writeLineBreak(data:ByteArray):void {
        data.writeShort(0x0D0A);
    }

    private function writeQuote(data:ByteArray):void {
        data.writeByte(34);
    }

    private function writeDoubleDash(data:ByteArray):void {
        data.writeShort(0x2D2D);
    }

    /** Writes the next file's header, then schedules its content to be copied in chunks. */
    private function writeNextFileAsync():void {
        var part:FilePart;
        if (this.asyncFileIndex < this.fileNames.length) {
            part = (this.files[this.fileNames[this.asyncFileIndex]] as FilePart);
            this.writeFileHeader(this._data, part);
            this.asyncWriteTimeoutId = setTimeout(this.writeChunk, 10, this._data, part.fileContent, 0);
            this.asyncFileIndex++;
        } else {
            this.writeUploadField(this._data);
            this.writeClosingBoundary(this._data);
            this.isPrepared = true;
            dispatchEvent(new DataPrepareEvent(DataPrepareEvent.PREPARE_PROGRESS, this.totalFilesSize, this.totalFilesSize));
            dispatchEvent(new DataPrepareEvent(DataPrepareEvent.PREPARE_COMPLETE));
        }
    }

    /** Copies up to BLOCK_SIZE bytes of a file into the body, then reschedules itself or moves on to the next file. */
    private function writeChunk(data:ByteArray, content:ByteArray, offset:uint = 0):void {
        var chunkSize:uint = Math.min(BLOCK_SIZE, (content.length - offset));
        data.writeBytes(content, offset, chunkSize);
        if ((((chunkSize < BLOCK_SIZE)) || (((offset + chunkSize) >= content.length)))) {
            this.writeLineBreak(data);
            this.writeNextFileAsync();
            return;
        }
        offset = (offset + chunkSize);
        this.writtenBytes = (this.writtenBytes + chunkSize);
        if (((this.writtenBytes % BLOCK_SIZE) * 2) == 0) {
            dispatchEvent(new DataPrepareEvent(DataPrepareEvent.PREPARE_PROGRESS, this.writtenBytes, this.totalFilesSize));
        }
        this.asyncWriteTimeoutId = setTimeout(this.writeChunk, 10, data, content, offset);
    }

    private function onProgress(event:ProgressEvent):void {
        dispatchEvent(event);
    }

    private function onComplete(event:Event):void {
        this.removeListeners();
        dispatchEvent(event);
    }

    private function onIOError(event:IOErrorEvent):void {
        this.removeListeners();
        dispatchEvent(event);
    }

    private function onSecurityError(event:SecurityErrorEvent):void {
        this.removeListeners();
        dispatchEvent(event);
    }

    private function onHTTPStatus(event:HTTPStatusEvent):void {
        dispatchEvent(event);
    }

}
}//package multipartupload

import flash.utils.ByteArray;

/** One file to upload: its bytes, the name sent in the request, the form field name and the MIME type. */
class FilePart {

    public var fileContent:ByteArray;
    public var fileName:String;
    public var dataField:String;
    public var contentType:String;

    public function FilePart(fileContent:ByteArray, fileName:String, dataField:String = "Filedata", contentType:String = "application/octet-stream") {
        this.fileContent = fileContent;
        this.fileName = fileName;
        this.dataField = dataField;
        this.contentType = contentType;
    }

    public function dispose():void {
        this.fileContent = null;
        this.fileName = null;
        this.dataField = null;
        this.contentType = null;
    }

}
