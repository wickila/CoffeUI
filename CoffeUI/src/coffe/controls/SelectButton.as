package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import coffe.core.InvalidationType;
	import coffe.interfaces.ISelectable;
	/**
	 *	可选择按钮.具有选中与未选中两种状态.两种状态下的背景,标签,标签样式,标签发光滤镜都可以定义.此组件是Radiobutton的扩充,同样会被添加进一个组,并且组内同时只有一个可选择按钮处于选择状态.
	 * 	<br>样式属性:
	 * 	<table width="100%">
	 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * 	<tr><td>selectedLabel</td><td>选择状态文本标签值</td><td>"Selected"</td></tr>
	 * 	<tr><td>unSelectedLabel</td><td>未选择状态文本标签值</td><td>"unSelectedLabel"</td></tr>
	 * 	<tr><td>labelGap</td><td>标签水平偏移距离</td><td>2</td></tr>
	 * 	<tr><td>labelTopGap</td><td>标签垂直偏移距离</td><td>-2</td></tr>
	 * 	<tr><td>selectedBgStyle</td><td>选中状态背景样式</td><td>CheckBoxSelectOverSkin</td></tr>
	 * 	<tr><td>unSelectedBgStyle</td><td>未选中状态背景样式</td><td>CheckBoxUnSelectOverSkin</td></tr>
	 * 	<tr><td>selectedFormat</td><td>选择装袋标签字体样式</td><td>'{"color":"0x000000","font":"Arial","size":11}'</td></tr>
	 * 	<tr><td>unSelectedFormat</td><td>未选择装袋标签字体样式</td><td>'{"color":"0x000000","font":"Arial","size":11}'</td></tr>
	 * 	<tr><td>selectedFilter</td><td>选择状态标签发光滤镜</td><td>'{"color":"0xffffff","alpha":1,"blurX":2,<br>"blurY":2,"strength":5,"quality":1,<br>"inner":false,"knockout":false}'</td></tr>
	 * 	<tr><td>unSelectedFilter</td><td>未选择状态标签发光滤镜</td><td>'{"color":"0xffffff","alpha":1,"blurX":2,<br>"blurY":2,"strength":5,"quality":1,<br>"inner":false,"knockout":false}'</td></tr>
	 * 	</table>
	 * 	@see coffe.controls.SelectGroup
	 */
	public class SelectButton extends BaseButton implements ISelectable
	{
		/**
		 *	组件的全局默认样式,每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	<br>可选择按钮默认样式属性:
		 * 	<table width="100%">
		 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
		 * 	<tr><td>selectedLabel</td><td>选择状态文本标签值</td><td>"Selected"</td></tr>
		 * 	<tr><td>unSelectedLabel</td><td>未选择状态文本标签值</td><td>"unSelectedLabel"</td></tr>
		 * 	<tr><td>labelGap</td><td>标签水平偏移距离</td><td>2</td></tr>
		 * 	<tr><td>textColor</td><td>标签文本颜色</td><td>0</td></tr>
		 * 	<tr><td>selectedBgStyle</td><td>选中状态背景样式</td><td>CheckBoxSelectOverSkin</td></tr>
		 * 	<tr><td>unSelectedBgStyle</td><td>未选中状态背景样式</td><td>CheckBoxUnSelectOverSkin</td></tr>
		 * 	<tr><td>selectedFormat</td><td>选择装袋标签字体样式</td><td>'{"color":"0x000000","font":"Arial","size":11}'</td></tr>
		 * 	<tr><td>unSelectedFormat</td><td>未选择装袋标签字体样式</td><td>'{"color":"0x000000","font":"Arial","size":11}'</td></tr>
		 * 	<tr><td>selectedFilter</td><td>选择状态标签发光滤镜</td><td>'{"color":"0xffffff","alpha":1,"blurX":2,<br>"blurY":2,"strength":5,"quality":1,<br>"inner":false,"knockout":false}'</td></tr>
		 * 	<tr><td>unSelectedFilter</td><td>未选择状态标签发光滤镜</td><td>'{"color":"0xffffff","alpha":1,"blurX":2,<br>"blurY":2,"strength":5,"quality":1,<br>"inner":false,"knockout":false}'</td></tr>
		 * 	</table>
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 * 	@example
		 * 	ObjectUtils.combineObject(ComboBox.DEFAULT_STYLE,{"listStyle":{"cellRender":"com.dragonlance.view.ComboxCellRender","backgroundStyle":"dl.asset.core.ComboxListBgAsset"},"buttonStyle":{"labelFormat":'{"color":"0xffffff","font":"宋体","size":12}',"labelFilter":""}});
		 */
		public static var DEFAULT_STYLE:Object = {
			selectedBgStyle:"SelectButtonSelectSkin",
			unSelectedBgStyle:"SelectButtonUnSelectSkin",
			selectedLabel:"Selected",
			unSelectedLabel:"unSelected",
			selectedFormat:'{"color":"0x000000","font":"Arial","size":11}',
			unSelectedFormat:'{"color":"0x000000","font":"Arial","size":11}',
			selectedFilter:'{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}',
			unSelectedFilter:'{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}',
			labelGap:0,
			textColor:0
		};
		
		protected var _group:SelectGroup;
		protected var _value:Object;
		protected var _selectedBgStyle:String;
		protected var _unSelectedBgStyle:String;
		protected var _selectedBg:DisplayObject;
		protected var _unselectedBg:DisplayObject;
		protected var _selectedLable:String;
		protected var _unSelectedLable:String;
		protected var _selectedFormat:TextFormat;
		protected var _unSelectedFormat:TextFormat;
		protected var _selectedFilter:GlowFilter;
		protected var _unSelectedFilter:GlowFilter;
		/**
		 *	创建一个新的可选择按钮,并且默认添加进"SelectButtonGroup"组内.
		 * 
		 */
		public function SelectButton()
		{
			super();
			groupName = "SelectButtonGroup";
		}
		
		override protected function initDefaultStyle():void
		{
			super.initDefaultStyle();
			_label = "SelectButton";
			setStyle(DEFAULT_STYLE);
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
			if(_group)
				_group.removeEventListener(Event.CHANGE,handleChange,false);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			selected = !_selected;
			dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 *	选中状态背景样式. 一个显示对象类的类名.
		 * @param value 选中状态背景样式.默认值:SelectButtonSelectSkin
		 * 
		 */		
		[Inspectable(type="String",name="选中样式",defaultValue="SelectButtonSelectSkin")]
		public function set selectedBgStyle(value:String):void
		{
			_selectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	未选择状态背景样式.一个显示对象类的类名. 
		 * @param value 未选择状态背景样式.默认值:SelectButtonUnSelectSkin
		 * 
		 */		
		[Inspectable(type="String",name="未选中样式",defaultValue="SelectButtonUnSelectSkin")]
		public function set unSelectedBgStyle(value:String):void
		{
			_unSelectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	选中状态标签文本. 
		 * @param value 选中状态标签文本.默认值:Selected
		 * 
		 */		
		[Inspectable(type="String",name="选中标签",defaultValue="Selected")]
		public function set selectedLabel(value:String):void
		{
			_selectedLable= value;
			invalidate(InvalidationType.LABEL);
		}
		/**
		 *	未选中状态标签文本. 
		 * @param value 未选中标签文本.默认值:UnSelected
		 * 
		 */		
		[Inspectable(type="String",name="未选中标签",defaultValue="UnSelected")]
		public function set unSelectedLabel(value:String):void
		{
			_unSelectedLable = value;
			invalidate(InvalidationType.LABEL);
		}
		/**
		 *	标签距离组件左边的间隔距离. 
		 * @param value 标签距离组件左边的间隔距离.默认值:10
		 * 
		 */		
		[Inspectable(defaultValue=10, name="标签间隔", type="Number")]
		override public function set labelGap(value:int):void
		{
			_labelGap = value;
			invalidate(InvalidationType.LABEL);
		}
		/**
		 *	选中状态标签文本样式. 为一个包含文本样式信息的json格式字符串.
		 * @param value 选中状态标签文本样式.默认值:'{"color":"0x000000","font":"Arial","size":11}'
		 * @see flash.text.TextFormat
		 */		
		[Inspectable(type="String",name="选中标签样式",defaultValue='{"color":"0x000000","font":"Arial","size":11}')]
		public function set selectedFormat(value:String):void
		{
			if(value)
			{
				try{
					var obj:Object = JSON.parse(value);
					_selectedFormat = new TextFormat(obj.font,obj.size,obj.color,obj.bold,obj.italic,obj.underline,obj.url,obj.target,obj.align,obj.leftMargin,obj.rightMargin,obj.indent,obj.leading);
					invalidate(InvalidationType.LABEL);
				}catch(e:Error)
				{
					trace("选中标签格式错误",_selectedFormat);
				}
			}
		}
		/**
		 *	未选中状态标签文本样式. 为一个包含文本样式信息的json格式字符串.
		 * @param value 未选中状态标签文本样式.默认值:'{"color":"0x000000","font":"Arial","size":11}'
		 * @see flash.text.TextFormat
		 */	
		[Inspectable(type="String",name="未选中标签样式",defaultValue='{"color":"0x000000","font":"Arial","size":11}')]
		public function set unSelectedFormat(value:String):void
		{
			if(value)
			{
				try{
					var obj:Object = JSON.parse(value);
					_unSelectedFormat = new TextFormat(obj.font,obj.size,obj.color,obj.bold,obj.italic,obj.underline,obj.url,obj.target,obj.align,obj.leftMargin,obj.rightMargin,obj.indent,obj.leading);
					invalidate(InvalidationType.LABEL);
				}catch(e:Error)
				{
					trace("未选中标签格式错误",_unSelectedFormat);
				}
			}
		}
		/**
		 *	选中状态标签发光滤镜. 为一个包含发光滤镜信息的json格式字符串.
		 * @param value 选中状态标签发光滤镜.默认值:'{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}'
		 * @see flash.filters.GlowFilter
		 */	
		[Inspectable(type="String",name="选中标签滤镜",defaultValue='{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}')]
		public function set selectedFilter(value:String):void
		{
			if(value)
			{
				try{
					var obj:Object = JSON.parse(value);
					_selectedFilter = new GlowFilter(parseInt(obj.color),obj.alpha,obj.blurX,obj.blurY,obj.strength,obj.quality,obj.inner,obj.knockout);
					invalidate(InvalidationType.LABEL);
				}catch(e:Error)
				{
					_selectedFilter = null;
					trace("选中标签滤镜格式错误",_selectedFilter);
				}
			}
		}
		/**
		 *	未选中状态标签发光滤镜. 为一个包含发光滤镜信息的json格式字符串.
		 * @param value 未选中状态标签发光滤镜.默认值:'{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}'
		 * @see flash.filters.GlowFilter
		 */
		[Inspectable(type="String",name="未选中标签滤镜",defaultValue='{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}')]
		public function set unSelectedFilter(value:String):void
		{
			if(value)
			{
				try{
					var obj:Object = JSON.parse(value);
					_unSelectedFilter = new GlowFilter(parseInt(obj.color),obj.alpha,obj.blurX,obj.blurY,obj.strength,obj.quality,obj.inner,obj.knockout);
					invalidate(InvalidationType.LABEL);
				}catch(e:Error)
				{
					_unSelectedFilter = null;
					trace("未选中标签滤镜格式错误");
				}
			}
		}
		
		[Inspectable(type="Boolean",defaultValue=false)]
		public function set selected(value:Boolean):void {
			// can only set to true in RadioButton:
			if (value == false || _selected) { return; }
			if (_group != null) { _group.selection = this; }
			else { _selected = value;invalidate(InvalidationType.SELECT);}
		}
		/**
		 *	所属组名 
		 * @return 
		 * 
		 */		
		public function get groupName():String {
			return (_group == null) ? null : _group.name;
		}
		
		[Inspectable(type="String",name="所属组",defaultValue="SelectButtonGroup")]
		public function set groupName(group:String):void {
			if (_group != null) {
				_group.removeRadioButton(this);
				_group.removeEventListener(Event.CHANGE,handleChange);
			}
			_group = (group == null) ? null : SelectGroup.getGroup(group);
			if (_group != null) {
				_group.addRadioButton(this);
				_group.addEventListener(Event.CHANGE,handleChange,false,0,true);
			}
		}
		
		protected function handleChange(event:Event):void {
			_selected = (_group.selection == this);
			invalidate(InvalidationType.SELECT);
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function get value():Object
		{
			return _value;
		}
		
		public function set value(value:Object):void
		{
			_value = value;
		}
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLE))
			{
				drawSelectBackground();
				drawUnselectBackground();
				if(!_labelTF)
				{
					_labelTF = new TextField();
					_labelTF.cacheAsBitmap = true;
					_labelTF.selectable = _labelTF.mouseEnabled = false;
					_labelTF.textColor = _textColor;
					addChild(_labelTF);
				}
			}
			if(isInvalid(InvalidationType.SELECT,InvalidationType.LABEL))
			{
				if(_selected)
				{
					if(_selectedFormat!=null)_labelTF.defaultTextFormat = _selectedFormat
					_labelTF.text = _selectedLable;
					if(_selectedFilter)_labelTF.filters = [_selectedFilter];
					if(_selectedFormat!=null)_labelTF.setTextFormat(_selectedFormat);
					if(contains(_unselectedBg))removeChild(_unselectedBg);
					addChildAt(_selectedBg,0);
				}else{
					if(_unSelectedFormat!=null)_labelTF.defaultTextFormat = _unSelectedFormat;
					_labelTF.text = _unSelectedLable;
					if(_unSelectedFilter)_labelTF.filters = [_unSelectedFilter];
					if(_unSelectedFormat!=null)_labelTF.setTextFormat(_unSelectedFormat);
					if(contains(_selectedBg))removeChild(_selectedBg);
					addChildAt(_unselectedBg,0);
				}
			}
			if(isInvalid(InvalidationType.LABEL,InvalidationType.SELECT,InvalidationType.STYLE,InvalidationType.SIZE))
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
			_selectedBg.width = _unselectedBg.width = width;
			_selectedBg.height = _unselectedBg.height = height;
			var bg:DisplayObject = _selected?_selectedBg:_unselectedBg;
			_labelTF.x = ((bg.width-_labelTF.textWidth)>>1)+_labelGap;
			_labelTF.y = ((bg.height-_labelTF.textHeight)>>1)+_labelTopGap;
			_labelTF.width = _labelTF.textWidth+10;
			_labelTF.height = _labelTF.textHeight+10;
		}
		
		override public function get width():Number
		{
			if(!isNaN(_width))return _width;
			if(_selectedBg)return _selectedBg.width;
			return super.width;
		}
		
		override public function get height():Number
		{
			if(!isNaN(_height))return _height;
			if(_selectedBg)return _selectedBg.height;
			return super.height;
		}
		
		override public function dispose():void
		{
			if (_group != null)_group.removeRadioButton(this);
			disposeObject(_selectedBg);_selectedBg=null;
			disposeObject(_unselectedBg);_unselectedBg=null;
			_value=null;
			super.dispose();
		}
	}
}