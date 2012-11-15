package coffe.controls
{
	import coffe.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BaseButton extends UIComponent
	{
		private var _displacement:Boolean = true;
		protected var _bgStyle:String;
		protected var bg:DisplayObject;
		public var avatar:DisplayObject;
		public function BaseButton()
		{
			super();
		}
		
		override protected function configDefaultStyle():void
		{
			_bgStyle = "ImageButtonDefault";
		}
		
		override protected function initEvents():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN,onButtonDown);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			if(avatar)
			{
				removeChild(avatar);
				avatar = null;
			}
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
			configUI();
		}
		
		override protected function configUI():void
		{
			var newBg:DisplayObject = getDisplayObjectInstance(_bgStyle);
			if(newBg)
			{
				if(bg)
				{
					if(contains(bg))removeChild(bg);
				}
				bg = newBg;
				addChild(bg);
			}
		}
	}
}