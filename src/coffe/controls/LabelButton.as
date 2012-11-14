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
		private var _bg:DisplayObject;
		private var _textField:TextField;
		private var _lable:String="LableButton";
		public function LabelButton()
		{
			super();
		}
		
		override protected function configUI():void
		{
			var cls:Class = getDefinitionByName(_bgStyle) as Class;
			var instance:Object = new cls();
			if(_bg)
			{
				if(contains(_bg))removeChild(_bg);
			}
			if(instance is BitmapData)
			{
				_bg = new Bitmap(BitmapData(instance));
			}else
			{
				_bg = instance as DisplayObject;
			}
			addChild(_bg);
			if(!_textField)
			{
				_textField = new TextField();
				_textField.type = TextFieldType.DYNAMIC;
				_textField.text = _lable;
			}
			addChild(_textField);
			_textField.x = (_bg.width-_textField.textWidth)*.5;
		}
	}
}