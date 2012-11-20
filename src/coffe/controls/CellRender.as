package coffe.controls
{
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.interfaces.ICellRender;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
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
		private var _labelAlign:String = AlignType.LEFT;
		public function CellRender()
		{
			super();
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
		}
		
		override protected function initEvents():void
		{
			super.initEvents();
			addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
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
			if(isInvalid(InvalidationType.STATE))
			{
				updateBackground();
			}
			if(isInvalid(InvalidationType.DATA))
			{
				if(_data)
				{
					if(_data.hasOwnProperty(_labelField))
					{
						_labelTF.text = _data[_labelField];
					}else
					{
						_labelTF.text = _data.toString();
					}
				}else
				{
					_labelTF.text = "";
				}
			}
			if(isInvalid(InvalidationType.SIZE,InvalidationType.STYLE,InvalidationType.DATA))
			{
				drawLayout();
			}
		}
		
		override public function drawLayout():void
		{
			if(!isNaN(_width))_background.width = _width;
			if(!isNaN(_height))_background.height = _height;
			switch(_labelAlign)
			{
				case AlignType.LEFT:
					_labelTF.x = 10;
					break;
				case AlignType.CENTER:
					_labelTF.x = (_background.width-_labelTF.textWidth)*.5;
					
					break;
				case AlignType.RIGHT:
					_labelTF.x = _background.width - _labelTF.textWidth - 10;
					break;
			}
			_labelTF.width = _background.width - _labelTF.x;
			_labelTF.height = _background.height-_labelTF.y;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			_mouseState = "up";
			invalidate(InvalidationType.STATE);
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			_mouseState = "over";
			invalidate(InvalidationType.STATE);
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			invalidate(InvalidationType.DATA);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			invalidate(InvalidationType.STATE);
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

		public function set backgroundStyle(value:String):void
		{
			if(_backgroundStyle == value)return;
			_backgroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			invalidate(InvalidationType.SIZE);
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			invalidate(InvalidationType.SIZE);
		}

		public function get labelField():String
		{
			return _labelField;
		}

		public function set labelField(value:String):void
		{
			_labelField = value;
		}

		public function get labelAlign():String
		{
			return _labelAlign;
		}

		public function set labelAlign(value:String):void
		{
			_labelAlign = value;
			invalidate(InvalidationType.SIZE);
		}
	}
}