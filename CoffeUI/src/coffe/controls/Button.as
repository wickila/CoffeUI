package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;

	/**
	 * 普通按钮组件.包括一个标签文本,一个Icon图标,一个背景,背景支持单张Bitmap,也支持跳帧的Moviclip.如果是Movieclip，可以在里面设置up,over,down的帧标签来实现按钮的状态切换.如果是单张bitmap,则会在鼠标划过时,默认给一个高亮的滤镜.
	 * <br>样式属性:
	 * 	<table width="100%">
	 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * 	<tr><td>label</td><td>文本标签值</td><td>label</td></tr>
	 * 	<tr><td>textColor</td><td>标签颜色</td><td>0</td></tr>
	 * 	<tr><td>labelAlign</td><td>标签对齐方式</td><td>center</td></tr>
	 * 	<tr><td>labelGap</td><td>标签水平偏移距离</td><td>10</td></tr>
	 * 	<tr><td>labelTopGap</td><td>标签垂直偏移距离</td><td>-2</td></tr>
	 * 	<tr><td>backGroundStyle</td><td>背景样式</td><td>ButtonDefaultSkin</td></tr>
	 * 	<tr><td>labelFilter</td><td>标签发光滤镜</td><td>'{"color":"0xffffff","alpha":1,<br>"blurX":2,"blurY":2,"strength":5,"quality":1,<br>"inner":false,"knockout":false}'</td></tr>
	 * 	<tr><td>labelFormat</td><td>标签字体样式</td><td>'{"color":"0x000000","font":"Arial","size":12}'</td></tr>
	 * 	<tr><td>iconStyle</td><td>图标样式</td><td>""</td></tr>
	 * 	<tr><td>iconHAlign</td><td>图标水平对齐方式</td><td>"center"</td></tr>
	 * 	<tr><td>iconVAlign</td><td>图标垂直对齐方式</td><td>"middle"</td></tr>
	 * 	</table>
	 * @see coffe.controls.BaseButton
	 */	
	public class Button extends BaseButton
	{
		/**
		 *	组件的默认样式.每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	<br>默认按钮样式:
		 * 	<table width="100%">
		 * 	<tr><td>backGroundStyle</td><td>"ButtonDefaultSkin"</td></tr>
		 * 	<tr><td>labelFilter</td><td>'{"color":"0xffffff","alpha":1,<br>"blurX":2,"blurY":2,"strength":5,"quality":1,<br>"inner":false,"knockout":false}'</td></tr>
		 * 	<tr><td>backGroundStyle</td><td>'{"color":"0x000000","font":"Arial","size":12}'</td></tr>
		 * 	<tr><td>iconHAlign</td><td>"center"</td></tr>
		 * 	<tr><td>iconVAlign</td><td>"middle"</td></tr>
		 * 	</table>
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 * 	@example
		 * 	ObjectUtils.combineObject(ComboBox.DEFAULT_STYLE,{"listStyle":{"cellRender":"com.dragonlance.view.ComboxCellRender","backgroundStyle":"dl.asset.core.ComboxListBgAsset"},"buttonStyle":{"labelFormat":'{"color":"0xffffff","font":"宋体","size":12}',"labelFilter":""}});
		 */
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
			super.initDefaultStyle();
			setStyle(DEFAULT_STYLE);
		}
		
		[Inspectable(type="String",name="标签",defaultValue="Label")]
		override public function set label(value:String):void
		{
			super.label = value;
		}
		
		/**
		 *	标签发光滤镜.为一个json格式的字符串,里面可以包含GlowFilter的各种属性值
		 * 	@param value 一段json格式的标签滤镜字符串.<br>默认值: {"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}
		 * 	@see flash.filters.GlowFilter
		 */
		[Inspectable(type="String",name="标签滤镜",defaultValue='{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}')]
		public function set labelFilter(value:String):void
		{
			_labelFitler = value;
			invalidate(InvalidationType.LABEL);
		}
		/**
		 *	标签样式.为一个json格式的字符串,里面可以包含TextFormat的各种属性值
		 * 	@param value 一段json格式的文本样式字符串.<br>默认值: {"color":"0x000000","font":"Arial","size":12}
		 * 	@see flash.text.TextFormat
		 */
		[Inspectable(type="String",name="标签样式",defaultValue='{"color":"0x000000","font":"Arial","size":12}')]
		public function set labelFormat(value:String):void
		{
			_labelFormat = value;
			invalidate(InvalidationType.LABEL);
		}
		/**
		 *	背景样式.为一个显示对象类的类名.不能为空.
		 * 	默认值: ButtonDefaultSkin
		 * @param value 背景样式类名
		 */
		[Inspectable(type="String",name="背景样式",defaultValue="ButtonDefaultSkin")]
		public function set backGroundStyle(value:String):void
		{
			_backgroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	按钮的图标样式.为一个显示对象类的类名.为空则不显示图标
		 * 	默认值: null
		 * @param value 背景样式类名
		 */
		[Inspectable(type="String",name="图标样式")]
		public function set iconStyle(value:String):void
		{
			_iconStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		
		/**
		 * 调整按钮布局.
		 * 如果按钮背景宽度小于标签文本宽度,则会自动调整背景宽度.最终宽度跟标签文本宽度与labelGap属性有关 
		 * 
		 */
		override public function drawLayout():void
		{
			_background.width = width;
			_background.height = height;
			if(_labelTF)
			{
				if(_background.width < _labelTF.textWidth+_labelGap*2)
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
				_labelTF.y = (_background.height - _labelTF.textHeight)*.5+_labelTopGap;
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
			if(isInvalid(InvalidationType.SIZE,InvalidationType.LABEL,InvalidationType.STYLE))
			{
				drawLayout();
			}
			if(isInvalid(InvalidationType.STATE))
			{
				drawMouseState();
			}
		}
		
		private function drawMouseState():void
		{
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
				var inter:InteractiveObject = _background as InteractiveObject;
				var con:DisplayObjectContainer = _background as DisplayObjectContainer;
				inter&&(inter.mouseEnabled=false);
				con&&(con.mouseChildren=false);
			}
		}
		
		private function drawIcon():void
		{
			if(_icon&&contains(_icon))removeChild(_icon);
			_icon = getDisplayObjectInstance(_iconStyle);
			if(_icon&&numChildren>0)addChildAt(_icon,1);
		}
		/**
		 *	图标水平对齐方式. 
		 * @param value 图标水平对齐方式,默认为"center"
		 * @see coffe.core.AlignType
		 */		
		[Inspectable(defaultValue="center", type="list", enumeration="left,center,right")]
		public function set iconHAlign(value:String):void
		{
			_iconHAlign = value;
			invalidate(InvalidationType.SIZE);
		}
		/**
		 *	图标垂直对齐方式 
		 * @param value 图标垂直对齐方式,默认为"center"
		 * @see coffe.core.AlignType
		 */		
		[Inspectable(defaultValue="middle", type="list", enumeration="top,middle,bottom")]
		public function set iconVAlign(value:String):void
		{
			_iconVAlign = value;
			invalidate(InvalidationType.SIZE);
		}
		/**
		 * 标签对齐方式.labelGap属性只有在此属性为left或者right的时候才有效
		 * @param value
		 * @see coffe.core.AlignType
		 */		
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