package coffe.controls
{
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.interfaces.ICellRender;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class CellRender extends UIComponent implements ICellRender
	{
		protected static const DEFAULT_STYLE:Object = {
			backgroundStyle:"CellRenderBackgroundSkin",
			labelField:"label"
		};
		protected var _labelTF:TextField;
		protected var _background:MovieClip;
		protected var _backgroundStyle:String;
		private var _mouseState:String = "up";
		private var _data:Object;
		private var _selected:Boolean = false;
		private var _labelField:String;
		public function CellRender()
		{
			super();
			drawNow();
			updateBackground();
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
		}
		
		override protected function initEvents():void
		{
			super.initEvents();
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLE))
			{
				if(_background&&contains(_background))removeChild(_background);
				_background = getDisplayObjectInstance(_backgroundStyle) as MovieClip;
				addChild(_background);
				if(_labelTF == null)
				{
					_labelTF = new TextField();
					_labelTF.mouseEnabled = _labelTF.selectable = false;
				}
				addChild(_labelTF);
			}
			drawLayout();
		}
		
		override public function drawLayout():void
		{
			_labelTF.x = (_background.width-_labelTF.textWidth)*.5;
			_labelTF.x = (_background.width-_labelTF.textWidth)*.5;
			_labelTF.width = _background.width-_labelTF.x;
			_labelTF.height = _background.height-_labelTF.y;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			_mouseState = "up";
			updateBackground();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			_mouseState = "over";
			updateBackground();
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			if(_data.hasOwnProperty(_labelField))
			{
				_labelTF.text = _data[_labelField];
			}else
			{
				_labelTF.text = _data.toString();
			}
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			updateBackground();
		}
		
		public function get selected():Boolean
		{
			return false;
		}
		
		private function updateBackground():void
		{
			_background.gotoAndStop(getMouseState());
		}
		
		private function getMouseState():String
		{
			return (_selected?"selected_":"")+_mouseState;
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			if(parent)
				parent.removeChild(this);
		}

		public function get backgroundStyle():String
		{
			return _backgroundStyle;
		}

		public function set backgroundStyle(value:String):void
		{
			if(_backgroundStyle == value)return;
			_backgroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}

		public function get labelField():String
		{
			return _labelField;
		}

		public function set labelField(value:String):void
		{
			_labelField = value;
		}

	}
}