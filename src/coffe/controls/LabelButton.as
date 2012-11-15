package coffe.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getDefinitionByName;

	public class LabelButton extends BaseButton
	{
		private var _labelTF:TextField;
		private var _label:String="LableButton";
		public function LabelButton()
		{
			super();
		}
		
		[Inspectable(type="String",defaultValue="Label")]
		public function set label(value:String):void
		{
			_labelTF.text = value;
			_labelTF.x = (bg.width-_labelTF.textWidth)*.5;
		}
		
		[Inspectable(type="Color",defaultValue=0)]
		public function set textColor(value:uint):void
		{
			_labelTF.textColor = value;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			if(_labelTF == null)
			{
				_labelTF = new TextField();
				_labelTF.selectable = false;
				_labelTF.text = "ok";
			}
			addChild(_labelTF);
			if(bg)_labelTF.x = (bg.width-_labelTF.textWidth)*.5;
		}
	}
}