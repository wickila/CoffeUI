package coffe.controls
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.interfaces.ICellRender;
	/**
	 * 列表用默认的单元格.拥有一个标签文本,以及一个单元格背景.
	 * 其中labelField字段可以制定要显示的数据的属性名称.例如:labelField="name"将会把数据对象_data.name呈现出来.
	 * 如果不想使用此默认的单元格渲染器,也可以自定义列表单元格渲染器,只需要实现ICellRender的接口即可.
	 * <br>此组件一般内部用于List.平时不会主动去创建此组件的实例.
	 * <br>默认样式
	 * <table width="100%">
	 * <tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * <tr><td>backgroundStyle</td><td>背景样式</td><td>CellRenderBackgroundSkin</td></tr>
	 * <tr><td>labelAlign</td><td>标签水平对齐方式</td><td>"left"</td></tr>
	 * </table>
	 * @see coffe.controls.List
	 * @see coffe.interfaces.ICellRender
	 */	
	public class CellRender extends UIComponent implements ICellRender
	{
		public static var DEFAULT_STYLE:Object = {
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
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
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
			disposeObject(_labelTF);
			_labelTF = null;
			disposeObject(_background);
			_background = null;
			super.dispose();
		}

		/**
		 *	背景样式.一个MovieClip的类名.如果背景MovieClip内包含"up""over"的标签,则此渲染器在鼠标划过时背景将会跳帧到"up",划出时背景将会跳帧到"over" 
		 * @param value 背景样式.一个MovieClip的类名
		 * 
		 */
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

		/**
		 *	需要呈现的数据属性名 
		 * 例如:labelField="name"将会呈现数据的name值--data.name
		 * @param value 需要呈现的数据属性名
		 * 
		 */
		public function set labelField(value:String):void
		{
			_labelField = value;
		}

		public function get labelAlign():String
		{
			return _labelAlign;
		}
		
		/**
		 *	标签的水平对齐方式 
		 * @param value 标签的水平对齐方式
		 * @see coffe.core.AlignType
		 */
		public function set labelAlign(value:String):void
		{
			_labelAlign = value;
			invalidate(InvalidationType.SIZE);
		}
	}
}