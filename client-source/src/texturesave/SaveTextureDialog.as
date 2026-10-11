package texturesave
{
    import multipartupload.MultipartURLLoader;

    import pngencoder.PNGEncoder;

    import account.Account;

    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.ui._7f;
    import com.company.ui.SimpleText;
    import com.company.util.GraphicHelper;

    import flash.display.BitmapData;
    import flash.display.CapsStyle;
    import flash.display.Graphics;
    import flash.display.GraphicsPath;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsData;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.utils.ByteArray;

    public class SaveTextureDialog extends Sprite
    {
        private static const WIDTH:int = 400;
        private static const SCREEN_WIDTH:int = 800;
        private static const SCREEN_HEIGHT:int = 600;

        protected var bitmapData_:BitmapData;
        protected var backdrop_:Shape;
        protected var box_:Sprite;
        protected var background_:Shape;
        protected var titleText_:SimpleText = null;
        protected var nameInput_:NameInput = null;
        protected var typeSelector_:TypeSelector = null;
        protected var tagsInput_:TagsInput = null;
        protected var saveButton_:_7f = null;
        protected var cancelButton_:_7f = null;
        protected var errorText_:SimpleText;

        private var graphicsData_:Vector.<IGraphicsData>;
        private var outlineFill_:GraphicsSolidFill;
        private var outlineStroke_:GraphicsStroke;
        private var backgroundFill_:GraphicsSolidFill;
        private var path_:GraphicsPath;

        public function SaveTextureDialog(name:String, selectedType:int, tags:String, bitmapData:BitmapData, types:Vector.<int>)
        {
            this.box_ = new Sprite();
            this.outlineFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
            this.outlineStroke_ = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
            this.backgroundFill_ = new GraphicsSolidFill(0x2A2A2A, 1);
            this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
            this.graphicsData_ = new <IGraphicsData>[this.outlineStroke_, this.backgroundFill_, this.path_, GraphicHelper.END_FILL, GraphicHelper._H_B_];
            super();
            this.bitmapData_ = bitmapData;

            this.titleText_ = new SimpleText(22, 0x57AD62, false, WIDTH, 0, "Myriad Pro");
            this.titleText_.setBold(true);
            this.titleText_.htmlText = '<p align="center">Save</p>';
            this.titleText_.updateMetrics();
            this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
            this.titleText_.y = 4;
            this.box_.addChild(this.titleText_);

            this.nameInput_ = new NameInput(name);
            this.nameInput_.x = 20;
            this.nameInput_.y = 50;
            this.box_.addChild(this.nameInput_);

            this.tagsInput_ = new TagsInput(tags);
            this.tagsInput_.x = 20;
            this.tagsInput_.y = 180;
            this.box_.addChild(this.tagsInput_);

            this.saveButton_ = new _7f(16, "Save", 120);
            this.saveButton_.x = WIDTH - this.saveButton_.width - 20;
            this.saveButton_.y = 330;
            this.saveButton_.addEventListener(MouseEvent.CLICK, this.onSave);
            this.box_.addChild(this.saveButton_);

            this.cancelButton_ = new _7f(16, "Cancel", 120);
            this.cancelButton_.x = WIDTH - this.saveButton_.width - this.cancelButton_.width - 40;
            this.cancelButton_.y = 330;
            this.cancelButton_.addEventListener(MouseEvent.CLICK, this.onCancel);
            this.box_.addChild(this.cancelButton_);

            this.errorText_ = new SimpleText(14, 0xFC8642, false, 0, 0, "Myriad Pro");
            this.errorText_.text = "";
            this.errorText_.updateMetrics();
            this.errorText_.x = (WIDTH / 2) - (this.errorText_.width / 2);
            this.errorText_.y = 290;
            this.errorText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.box_.addChild(this.errorText_);

            this.typeSelector_ = new TypeSelector(types, selectedType);
            this.typeSelector_.x = 20;
            this.typeSelector_.y = 110;
            this.box_.addChild(this.typeSelector_);

            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        }

        private function showError(message:String):void
        {
            this.errorText_.text = message;
            this.errorText_.updateMetrics();
            this.errorText_.x = (WIDTH / 2) - (this.errorText_.width / 2);
        }

        private function uploadTexture():void
        {
            var loader:MultipartURLLoader = new MultipartURLLoader();
            loader.addVariable("guid", Account.getInstance().guid());
            loader.addVariable("password", Account.getInstance().password());
            loader.addVariable("secret", Account.getInstance().secret());
            loader.addVariable("name", this.nameInput_.text());
            loader.addVariable("dataType", this.typeSelector_.getType());
            loader.addVariable("tags", this.tagsInput_.text());
            loader.addVariable("overwrite", "on");
            var png:ByteArray = PNGEncoder.encode(this.bitmapData_);
            loader.addFile(png, "Foo.png", "data");
            loader.addEventListener(Event.COMPLETE, this.onUploadComplete);
            loader.load("http://" + Parameters._fK_() + "/picture/save");
            this.cancelButton_._A_w(false);
            this.saveButton_._A_w(false);
        }

        private function onCancel(event:MouseEvent):void
        {
            parent.removeChild(this);
        }

        private function onSave(event:MouseEvent):void
        {
            if (this.nameInput_.text() == "")
            {
                this.showError("You must set a name");
                return;
            }
            if (this.typeSelector_.getType() == 0)
            {
                this.showError("You must select a type");
                return;
            }
            this.uploadTexture();
        }

        private function onUploadComplete(event:Event):void
        {
            parent.removeChild(this);
        }

        private function onAddedToStage(event:Event):void
        {
            GraphicHelper._0L_6(this.path_);
            GraphicHelper.drawUI(0, 0, WIDTH, this.box_.height + 20, 4, [1, 1, 1, 1], this.path_);
            this.background_ = new Shape();
            var g:Graphics = this.background_.graphics;
            g.drawGraphicsData(this.graphicsData_);
            this.box_.addChildAt(this.background_, 0);
            this.box_.x = (SCREEN_WIDTH / 2) - (this.box_.width / 2);
            this.box_.y = (SCREEN_HEIGHT / 2) - (this.box_.height / 2);
            this.box_.filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16, 1)];
            addChild(this.box_);

            this.backdrop_ = new Shape();
            g = this.backdrop_.graphics;
            g.clear();
            g.beginFill(0, 0.8);
            g.drawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            g.endFill();
            addChildAt(this.backdrop_, 0);
        }
    }
}
