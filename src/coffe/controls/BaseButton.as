package coffe.controls
{
	import coffe.core.UIComponent;
	
	import flash.events.MouseEvent;
	
	public class BaseButton extends UIComponent
	{
		private var _displacement:Boolean = true;
		protected var _bgStyle:String;
		public function BaseButton()
		{
			super();
		}
		
		override protected function initEvents():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN,onButtonDown);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			if(_displacement)
			{
				x -= 1;
				y -= 1;
			}
		}
		
		protected function onButtonDown(event:MouseEvent):void
		{
			if(_displacement)
			{
				x+=1;
				y+=1;
			}
		}
		
		public function get displacement():Boolean
		{
			return _displacement;
		}
		
		[Inspectable(type="Boolean",defaultValue=true)]
		public function set displacement(value:Boolean):void
		{
			_displacement = value;
		}
		[Inspectable(type="String")]
		public function set bgStyle(value:String):void
		{
			_bgStyle = value;
			callLater(configUI);
		}
	}
}