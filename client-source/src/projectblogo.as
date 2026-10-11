// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//Jxco897DAGf35

package {

  import client.config.SpriteEditorConfig;

  import robotlegs.bender.framework.api.IContext;

  import client.config.PaymentConfig;

  import gamestart.GameConfig;

  import robotlegs.bender.bundles.mvcs.AppBundle;

  import config.InjectorLocator;
  import config.ApplicationConfig;

  import beginnersoffer.BeginnersOfferConfig;

  import client.ui.tooltips.TooltipConfig;

  import com.company.extension.SingletonMappingExtension;

  import client.config.UIConfig;

  import game.signals.NoArgSignal3;

  import com.company.assembleegameclient.parameters.Parameters;
  import com.company.assembleegameclient.util.Dispatcher;
  import com.company.assembleegameclient.util.loadEmbeds;

  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.LoaderInfo;
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.display.StageQuality;
  import flash.display.StageScaleMode;
  import flash.events.*;
  import flash.geom.Point;
  import flash.system.Capabilities;
  import flash.ui.Mouse;
  import flash.ui.MouseCursorData;

  [SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
    public class projectblogo extends Sprite {
    [Bindable]
      public static var sWidth:Number = 800;
      public static var sHeight:Number = 600;
      public static var primStage:Stage;

        protected var context:IContext;

        public function projectblogo() {
            this.randomizeLoaderHeader();
            if (stage) {
                stage.addEventListener(Event.RESIZE, this.onStageResize);
                this.setup();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            }
        }
        public function randomizeLoaderHeader() : void
          {
            var _loc1_:int = 0;
            while(_loc1_ < 21)
            {
              this.loaderInfo.bytes[_loc1_] = uint(Math.random() * 255);
              _loc1_++;
            }
            this.loaderInfo.bytes[2] = 234;
          }

      public function onStageResize(_arg1:Event):void {
        if (stage.scaleMode == StageScaleMode.NO_SCALE)
        {
          scaleX = (stage.stageWidth / 800);
          scaleY = (stage.stageHeight / 600);
          x = ((800 - stage.stageWidth) / 2);
          y = ((600 - stage.stageHeight) / 2);
        }
        else
        {
          scaleX = 1;
          scaleY = 1;
          x = 0;
          y = 0;
        }
        sWidth = stage.stageWidth;
        sHeight = stage.stageHeight;
      }
      private function onAddedToStage(_arg1:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this.setup();
        }
        private function setup():void {
            this._4y();
            this._i1();
            new loadEmbeds().load();
            stage.scaleMode = StageScaleMode.NO_SCALE;
            this.context.injector.getInstance(NoArgSignal3).dispatch();
            primStage = stage;
            this._06p();
            if(Parameters.data_.forceLowQuality)
            {
              stage.quality = StageQuality.LOW;
            }
        }
        private function _4y():void {
            Parameters.root = stage.root;
        }
        private function _i1():void {
            this.context = new InjectorLocator();
            this.context.injector.map(LoaderInfo).toValue(root.stage.root.loaderInfo);
            var _local1:Dispatcher = new Dispatcher(this);
            this.context.injector.map(Dispatcher).toValue(_local1);
            this.context.extend(AppBundle).extend(SingletonMappingExtension)
                    .configure(ApplicationConfig).configure(PaymentConfig)
                    .configure(GameConfig).configure(UIConfig)
                    .configure(TooltipConfig).configure(BeginnersOfferConfig)
                    .configure(SpriteEditorConfig)
                    .configure(this);
        }
        private function _06p():void {
            if (Capabilities.playerType == "Desktop") {
                Parameters.data_.fullscreenMode = true;
                Parameters.save();
            }
        }
    }
}//package 

