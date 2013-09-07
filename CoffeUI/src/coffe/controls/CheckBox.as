package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import coffe.core.InvalidationType;
	/**
	 * 当选择状态发生改变时,发出此事件
	 *
	 * @eventType flash.events.Event.CHANGE
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	[Event(name="change", type="flash.events.Event")]
	/**
	 * 复选框组件.具有选中与未选中两种状态.两种状态下的背景,标签都可以定义.但是两种状态下的标签样式跟标签滤镜是统一的.
	 * 注意:标签对齐方式在此组件中无效.水平默认靠左对齐,垂直默认居中对齐.
	 * <br>样式属性:
	 * 	<table width="100%">
	 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * 	<tr><td>label</td><td>文本标签值</td><td>label</td></tr>
	 * 	<tr><td>textColor</td><td>标签颜色</td><td>0</td></tr>
	 * 	<tr><td>labelGap</td><td>标签水平偏移距离</td><td>2</td></tr>
	 * 	<tr><td>labelTopGap</td><td>标签垂直偏移距离</td><td>-2</td></tr>
	 * 	<tr><td>selectedBgStyle</td><td>选中状态背景样式</td><td>CheckBoxSelectOverSkin</td></tr>
	 * 	<tr><td>unSelectedBgStyle</td><td>未选中状态背景样式</td><td>CheckBoxUnSelectOverSkin</td></tr>
	 * 	<tr><td>labelFormat</td><td>标签字体样式</td><td>{"color":"0x000000","font":"Arial","size":12}</td></tr>
	 * 	<tr><td>labelFilter</td><td>标签发光滤镜</td><td>{"color":"0xffffff","alpha":1,<br>"blurX":2,"blurY":2,"strength":5,<br>"quality":1,"inner":false,"knockout":false}</td></tr>
	 * 	</table>
	 * @see coffe.controls.BaseButton
	 */
	public class CheckBox extends BaseButton
	{
		/**
		 *	组件的全局默认样式,每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	<br>复选框默认样式属性:
		 * 	<table width="100%">
		 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
		 * 	<tr><td>label</td><td>文本标签值</td><td>label</td></tr>
		 * 	<tr><td>textColor</td><td>标签颜色</td><td>0</td></tr>
		 * 	<tr><td>labelGap</td><td>标签水平偏移距离</td><td>2</td></tr>
		 * 	<tr><td>labelTopGap</td><td>标签垂直偏移距离</td><td>-2</td></tr>
		 * 	<tr><td>selectedBgStyle</td><td>选中状态背景样式</td><td>CheckBoxSelectOverSkin</td></tr>
		 * 	<tr><td>unSelectedBgStyle</td><td>未选中状态背景样式</td><td>CheckBoxUnSelectOverSkin</td></tr>
		 * 	<tr><td>labelFormat</td><td>标签字体样式</td><td>{"color":"0x000000","font":"Arial","size":12}</td></tr>
		 * 	<tr><td>labelFormat</td><td>标签发光滤镜</td><td>{"color":"0xffffff","alpha":1,<br>"blurX":2,"blurY":2,"strength":5,<br>"quality":1,"inner":false,"knockout":false}</td></tr>
		 * 	</table>
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 * 	@example
		 * 	ObjectUtils.combineObject(ComboBox.DEFAULT_STYLE,{"listStyle":{"cellRender":"com.dragonlance.view.ComboxCellRender","backgroundStyle":"dl.asset.core.ComboxListBgAsset"},"buttonStyle":{"labelFormat":'{"color":"0xffffff","font":"宋体","size":12}',"labelFilter":""}});
		 */
		public static var DEFAULT_STYLE:Object={
			selectedBgStyle:"CheckBoxSelectOverSkin",
			unSelectedBgStyle:"CheckBoxUnSelectOverSkin",
			labelFormat:'{"color":"0x000000","font":"Arial","size":11}',
			labelFilter:'{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}'
		};
		protected var _selectedBg:DisplayObject;
		protected var _unselectedBg:DisplayObject;
		protected var _selectedBgStyle:String="";
		protected var _unSelectedBgStyle:String="";
		/**
		 *	创建一个复选组件 
		 * 
		 */
		public function CheckBox()
		{
			super();
			_labelGap = 2;
			_labelTopGap = -2;
		}
		
		override protected function initDefaultStyle():void
		{
			super.initDefaultStyle();
			setStyle(DEFAULT_STYLE);
		}
		/**
		 *	标签发光滤镜.为一个json格式的字符串,里面可以包含GlowFilter的各种属性值
		 * 	默认值: {"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}
		 * 	@param value 一段json格式的标签滤镜字符串
		 * 	@see flash.filters.GlowFilter
		 */
		[Inspectable(type="String",name="标签滤镜",defaultValue='{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}')]
		public function set labelFilter(value:String):void
		{
			_labelFitler = value;
			invalidate(InvalidationType.LABEL);
		}
		
		override protected function initEvents():void
		{
			super.initEvents();
			addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			selected = !_selected;
		}
		
		/**
		 *	未选择状态下的背景.为一个显示对象.
		 * @param value 未选择状态下的背景
		 * 
		 */
		public function set unselectedBg(value:DisplayObject):void
		{
			disposeObject(_unselectedBg);
			_unselectedBg = value;
			if(!_selected)addChild(_unselectedBg);
		}
		/**
		 *	选择状态下的背景.为一个显示对象
		 * @param value 选择状态下的背景
		 * 
		 */
		public function set selectedBg(value:DisplayObject):void
		{
			if(contains(_selectedBg))removeChild(_selectedBg);
			_selectedBg = value;
			if(_selected)addChild(_selectedBg);
		}
		/**
		 *	标签样式.为一个json格式的字符串,里面可以包含TextFormat的各种属性值
		 * 	默认值: {"color":"0x000000","font":"Arial","size":12}
		 * 	@param value 一段json格式的文本样式字符串
		 * 	@see flash.text.TextFormat
		 */
		[Inspectable(type="String",name="标签样式",defaultValue='{"color":"0x000000","font":"Arial","size":11}')]
		public function set labelFormat(value:String):void
		{
			_labelFormat = value;
			invalidate(InvalidationType.LABEL);
		}
		/**
		 *	选择状态下的背景样式.为一个显示对象的类名.
		 * 默认值:CheckBoxSelectOverSkin 
		 * @param value 选择状态下的背景样式
		 * 
		 */
		[Inspectable(type="String",name="选中样式",defaultValue="CheckBoxSelectOverSkin")]
		public function set selectedBgStyle(value:String):void
		{
			_selectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	未选择状态下的背景样式.为一个显示对象类名. 
		 * 默认值:CheckBoxUnSelectOverSkin
		 * @param value 未选择状态下的背景样式
		 * 
		 */
		[Inspectable(type="String",name="未选中样式",defaultValue="CheckBoxUnSelectOverSkin")]
		public function set unSelectedBgStyle(value:String):void
		{
			_unSelectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	组件标签值.
		 * 默认值为"CheckBox"
		 * @param value 组件标签值 
		 */
		[Inspectable(type="String",name="标签",defaultValue="CheckBox")]
		override public function set label(value:String):void
		{
			super.label = value;
		}
		/**
		 *	是否为选中状态.默认值false 
		 * @param value 是否为选中状态
		 * 
		 */		
		[Inspectable(type="Boolean",defaultValue=false)]
		public function set selected(value:Boolean):void
		{
			_selected = value;
			dispatchEvent(new Event(Event.CHANGE));
			invalidate(InvalidationType.SELECT);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLE))
			{
				drawSelectBackground();
				drawUnselectBackground();
			}
			if(isInvalid(InvalidationType.SELECT))
			{
				if(_selected)
				{
					if(contains(_unselectedBg))removeChild(_unselectedBg);
					addChildAt(_selectedBg,0);
				}else{
					if(contains(_selectedBg))removeChild(_selectedBg);
					addChildAt(_unselectedBg,0);
				}
			}
			if(!_labelTF)
			{
				_labelTF = new TextField();
				_labelTF.selectable = _labelTF.mouseEnabled = false;
				_labelTF.cacheAsBitmap = true;
			}
			_labelTF.text = _label;
			_labelTF.textColor = _textColor;
			if(_label)
			{
				addChild(_labelTF);
			}else
			{
				_labelTF.parent&&_labelTF.parent.removeChild(_labelTF);
			}
			if(isInvalid(InvalidationType.LABEL,InvalidationType.STYLE))
			{
				drawLayout();
			}
			if(isInvalid(InvalidationType.STATE))
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
		
		private function drawUnselectBackground():void
		{
			var us:DisplayObject = getDisplayObjectInstance(_unSelectedBgStyle);
			if(us)
			{
				if(_unselectedBg&&contains(_unselectedBg))removeChild(_unselectedBg);
				_unselectedBg = us;
				if(!_selected)addChildAt(_unselectedBg,0);
			}
		}
		
		private function drawSelectBackground():void
		{
			var s:DisplayObject = getDisplayObjectInstance(_selectedBgStyle);
			if(s)
			{
				if(_selectedBg&&contains(_selectedBg))removeChild(_selectedBg);
				_selectedBg = s;
				if(_selected)addChildAt(_selectedBg,0);
			}
		}
		
		override public function drawLayout():void
		{
			_labelTF.x = _selectedBg.width+_labelGap;
			_labelTF.y = (_selectedBg.height-_labelTF.textHeight)*0.5 + _labelTopGap;
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
			}
			if(_labelFormat)
			{
				try{
					obj = JSON.parse(_labelFormat);
					var tf:TextFormat = new TextFormat(obj.font,obj.size,obj.color,obj.bold,obj.italic,obj.underline,obj.url,obj.target,obj.align,obj.leftMargin,obj.rightMargin,obj.indent,obj.leading);
					_labelTF.defaultTextFormat = tf;
					_labelTF.setTextFormat(tf);
				}catch(e:Error)
				{
					trace("按钮标签样式格式错误",_labelFormat);
				}
			}
			_labelTF.width = _labelTF.textWidth+16;
			_labelTF.height = _labelTF.textHeight+10;
		}
		
		override public function dispose():void
		{
			super.dispose();
			disposeObject(_selectedBg);
			_selectedBg = null;
			disposeObject(_unselectedBg);
			_unselectedBg = null;
		}
	}
}