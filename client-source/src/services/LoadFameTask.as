package services {

import flash.events.TimerEvent;
import flash.utils.Timer;

import com.company.assembleegameclient.appengine.AppEngineClient;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util._str954;

import client.tasks.Task;
import events.GenericDataEvent;
import events.TextErrorEvent;

/**
 * Task that loads the fame data of a character (name, level, type, creation
 * date, killer and total fame) and exposes it through its public fields.
 * Failed requests are retried every second.
 *
 * NOTE: the base class _zU_ provides startTask() and the completion method
 * _C_t(success, errorText); both keep their obfuscated names for now.
 */
public class LoadFameTask extends Task {

    private static const RETRY_DELAY_MS:int = 1000;

    // Input
    public var accountId:int;
    public var charId:int;

    // Output
    public var xml:XML;
    public var character:XML;
    public var name:String;
    public var level:int;
    public var objectType:int;
    public var createdOn:String;
    public var killedBy:String;
    public var totalFame:int;

    private var client:AppEngineClient;
    private var retryTimer:Timer;

    override protected function startTask():void {
        this.requestFame();
    }

    private function requestFame():void {
        this.client = new AppEngineClient(Parameters.serverAddress(), "/char", true);
        this.client.addEventListener(GenericDataEvent.GENERIC_DATA, this.handleDataLoaded);
        this.client.addEventListener(TextErrorEvent.TEXT_ERROR, this.handleError);
        this.client.sendRequest("fame", this.createRequestParams());
    }

    private function createRequestParams():Object {
        var params:Object = {};
        params.accountId = this.accountId;
        params.charId = (this.accountId == -1) ? -1 : this.charId;
        return params;
    }

    private function parseResponse():void {
        this.character = this.xml.Char.(@id == charId)[0];
        this.name = this.character.Account.Name;
        this.level = this.character.Level;
        this.objectType = this.character.ObjectType;
        this.createdOn = this.formatCreatedOn();
        this.killedBy = this.xml.KilledBy || "";
        this.totalFame = this.xml.TotalFame;
    }

    private function releaseClient():void {
        this.client.removeEventListener(GenericDataEvent.GENERIC_DATA, this.handleDataLoaded);
        this.client.removeEventListener(TextErrorEvent.TEXT_ERROR, this.handleError);
        this.client = null;
    }

    /** @return the character's creation date, e.g. "March 5, 2016" */
    private function formatCreatedOn():String {
        var milliseconds:Number = Number(this.xml.CreatedOn) * 1000;
        var date:Date = new Date(milliseconds);
        var formatter:_str954 = new _str954();
        formatter._str4106 = "MMMM D, YYYY";
        return formatter.format(date);
    }

    private function handleDataLoaded(event:GenericDataEvent):void {
        this.xml = new XML(event.data);
        this.parseResponse();
        this.releaseClient();
        complete(true);
    }

    private function handleError(event:TextErrorEvent):void {
        this.releaseClient();
        this.retryTimer = new Timer(RETRY_DELAY_MS, 1);
        this.retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.handleRetryTimer);
        this.retryTimer.start();
    }

    private function handleRetryTimer(event:TimerEvent):void {
        this.retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.handleRetryTimer);
        this.retryTimer = null;
        this.requestFame();
    }

}
}
