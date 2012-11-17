package coffe.controls
{
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getDefinitionByName;

	public class Button extends BaseButton
	{
		protected var _backgroundStyle:String="ButtonDefaultSkin";
		protected var _background:DisplayObject;
		protected var _icon:DisplayObject;
		protected var _iconStyle:String;
		protected var _iconHAlign:String = AlignType.CENTER;
		protected var _iconVAlign:String = AlignType.MIDDLE;
		
		public function Button()
		{
			super();
		}
		
		[Inspectable(type="String",name="标签",defaultValue="Label")]
		override public function set label(value:String):void
		{
			super.label = value;
		}
		
		[Inspectable(type="String",name="背景样式",defaultValue="ButtonDefaultSkin")]
		public function set backGroundStyle(value:String):void
		{
			_backgroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="图标样式")]
		public function set iconStyle(value:String):void
		{
			_iconStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		
		override public function set width(value:Number):void
		{
			_background.width = value;
			invalidate(InvalidationType.SIZE);
		}
		
		override public function set height(value:Number):void
		{
			_background.height = value;
			invalidate(InvalidationType.SIZE);
		}
		
		override public function drawLayout():void
		{
			if(_labelTF)
			{
				_labelTF.x = (_background.width-_labelTF.textWidth)*.5;
				_labelTF.x = (_background.width-_labelTF.textWidth)*.5;
				_labelTF.width = _background.width-_labelTF.x;
				_labelTF.height = _background.height-_labelTF.y;
			}
			if(_icon)
			{
				switch(_iconHAlign)
				{
					case AlignType.LEFT:
						_icon.x = 0;
						break;
					case AlignType.CENTER:
						_icon.x = (_background.width-_icon.width)*.5;
						break;
					case AlignType.RIGHT:
						_icon.x = _background.width-_icon.width;
						break;
				}
				switch(_iconVAlign)
				{
					case AlignType.TOP:
						_icon.y = 0;
						break;
					case AlignType.MIDDLE:
						_icon.y = (_background.height-_icon.height)*.5;
						break;
					case AlignType.RIGHT:
						_icon.y = _background.height-_icon.height;
						break;
				}
			}
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLE))
			{
				drawBackground();
				drawIcon();
			}
			if(isInvalid(InvalidationType.LABEL))
			{
				drawLabel();
			}
			if(isInvalid(InvalidationType.SIZE,InvalidationType.LABEL,InvalidationType.STYLE))
			{
				drawLayout();
			}
			validate();
		}
		
		private function drawLabel():void
		{
			if(_label)
			{
				if(!_labelTF)
				{
					_labelTF = new TextField();
					_labelTF.mouseEnabled = _labelTF.selectable = false;
					_labelTF.textColor = _textColor;
					addChild(_labelTF);
				}
				_labelTF.text = _label;
			}else
			{
				if(_labelTF&&contains(_labelTF))removeChild(_labelTF);
				_labelTF = null;
			}
		}
		
		private function drawBackground():void
		{
			var newBg:DisplayObject = getDisplayObjectInstance(_backgroundStyle);
			if(newBg)
			{
				if(_background&&contains(_background))removeChild(_background);
				_background = newBg;
				addChildAt(_background,0);
			}
		}
		
		private function drawIcon():void
		{
			if(_icon&&contains(_icon))removeChild(_icon);
			_icon = getDisplayObjectInstance(_iconStyle);
			if(_icon)addChildAt(_icon,1);
		}
		[Inspectable(defaultValue="center", name="水平对齐", type="list", enumeration="left,center,middle")]
		public function set iconHAlign(value:String):void
		{
			_iconHAlign = value;
		}
		[Inspectable(defaultValue="middle", name="垂直对齐", type="list", enumeration="left,center,middle")]
		public function set iconVAlign(value:String):void
		{
			_iconVAlign = value;
		}


	}
}