package coffe.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;

	public class ImageButton extends BaseButton
	{
		private var _bg:Bitmap;
		public function ImageButton()
		{
			super();
		}
		
		override protected function configUI():void
		{
			var cls:Class = getDefinitionByName(_bgStyle) as Class;
			var bmd:BitmapData = new cls() as BitmapData;
			if(_bg)
			{
				if(contains(_bg))removeChild(_bg);
				_bg.bitmapData.dispose();
			}
			_bg = new Bitmap(bmd);
			addChild(_bg);
		}
	}
}