package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;

	/**
	 * 普通按钮。包括一个标签文本，一个Icon图标，一个背景。背景支持单张Bitmap，也支持跳帧的Moviclip，如果是Movieclip，可以在里面设置up,over,down的帧标签来实现按钮的状态切换
	 * @author wicki
	 * 
	 */	
	public class Button extends BaseButton
	{
		public static var DEFAULT_STYLE:Object = {
			backGroundStyle:"ButtonDefaultSkin",
			labelFilter:'{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}',
			labelFormat:'{"color":"0x000000","font":"Arial","size":12}'
		};
		
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
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
		}
		
		[Inspectable(type="String",name="标签",defaultValue="Label")]
		override public function set label(value:String):void
		{
			super.label = value;
		}
		
		[Inspectable(type="String",name="标签滤镜",defaultValue='{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}')]
		public function set labelFilter(value:String):void
		{
			_labelFitler = value;
			invalidate(InvalidationType.LABEL);
		}
		
		[Inspectable(type="String",name="标签样式",defaultValue='{"color":"0x000000","font":"Arial","size":12}')]
		public function set labelFormat(value:String):void
		{
			_labelFormat = value;
			invalidate(InvalidationType.LABEL);
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
		
		override public function drawLayout():void
		{
			_background.width = width;
			_background.height = height;
			if(hasFrameLabel(_mouseState))
			{
				_background["gotoAndStop"](_mouseState);
			}else
			{
				if(enable)
				{
					if(_mouseState=="over"||_mouseState=="down")
					{
						filters = [LIGHT_FILTER];
					}else
					{
						filters = null;
					}
				}else
				{
					filters = [GRAY_FILTER];
				}
			}
			if(_labelTF)
			{
				if(_background.width < _labelTF.textWidth-_labelGap*2)
				{
					_background.width = _labelTF.textWidth + _labelGap*2;
				}
				switch(_labelAlign)
				{
					case AlignType.LEFT:
						_labelTF.x = _labelGap;
						break;
					case AlignType.CENTER:
						_labelTF.x = (_background.width-_labelTF.textWidth)*.5;
						break;
					case AlignType.RIGHT:
						_labelTF.x = _background.width - _labelTF.textWidth - _labelGap;
						break;
				}
				_labelTF.y = (_background.height - _labelTF.textHeight)*.5-2;
				_labelTF.height = _background.height-_labelTF.y;
				_labelTF.width = _background.width-_labelTF.x;
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
		
		override public function get width():Number
		{
			if(!isNaN(_width))return _width;
			if(_background)return _background.width;
			return super.width;
		}
		
		override public function get height():Number
		{
			if(!isNaN(_height))return _height;
			if(_background)return _background.height;
			return super.height;
		}
		
		protected function hasFrameLabel(frame:String):Boolean
		{
			var mcBg:MovieClip = _background as MovieClip;
			if(mcBg == null)return false;
			for each(var l:FrameLabel in mcBg.currentLabels)
			{
				if(l.name == frame)
				{
					return true;
				}
			}
			return false;
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
			if(isInvalid(InvalidationType.SIZE,InvalidationType.LABEL,InvalidationType.STYLE,InvalidationType.STATE))
			{
				drawLayout();
			}
		}
		
		private function drawLabel():void
		{
			if(_label)
			{
				if(!_labelTF)
				{
					_labelTF = new TextField();
					_labelTF.mouseEnabled = _labelTF.selectable = _labelTF.multiline = false;
					_labelTF.cacheAsBitmap = true;
					addChild(_labelTF);
				}
				_labelTF.textColor = _textColor;
				_labelTF.text = _label;
				var obj:Object;
				if(_labelFitler)
				{
					try{
						obj = JSON.parse(_labelFitler);
						_labelTF.filters = [new GlowFilter(parseInt(obj.color),obj.alpha,obj.blurX,obj.blurY,obj.strength,obj.quality,obj.inner,obj.knockout)];
					}catch(e:Error)
					{
						trace("按钮标签滤镜格式错误",_labelFitler);
					}
				}else
				{
					_labelTF.filters = null;
				}
				if(_labelFormat)
				{
					try{
						obj = JSON.parse(_labelFormat);
						var tf:TextFormat = new TextFormat(obj.font,obj.size,obj.color,obj.bold,obj.italic,obj.underline,obj.url,obj.target,obj.align,obj.leftMargin,obj.rightMargin,obj.indent,obj.leading);
						tf.letterSpacing = obj.letterSpacing;tf.kerning=obj.kerning;
						_labelTF.defaultTextFormat = tf;
						_labelTF.setTextFormat(tf);
					}catch(e:Error)
					{
						trace("按钮标签样式格式错误",_labelFormat);
					}
				}
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
			if(_icon&&numChildren>0)addChildAt(_icon,1);
		}
		[Inspectable(defaultValue="center", type="list", enumeration="left,center,right")]
		public function set iconHAlign(value:String):void
		{
			_iconHAlign = value;
			invalidate(InvalidationType.SIZE);
		}
		[Inspectable(defaultValue="middle", type="list", enumeration="top,middle,bottom")]
		public function set iconVAlign(value:String):void
		{
			_iconVAlign = value;
			invalidate(InvalidationType.SIZE);
		}
		[Inspectable(defaultValue="center", type="list", enumeration="left,center,right")]
		public function set labelAlign(value:String):void
		{
			_labelAlign = value;
			invalidate(InvalidationType.LABEL);
		}
		
		override public function dispose():void
		{
			super.dispose();
			UIComponent.disposeObject(_background);
			UIComponent.disposeObject(_icon);
			_background = null;
			_icon = null;
		}
	}
}