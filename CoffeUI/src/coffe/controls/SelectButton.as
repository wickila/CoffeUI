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
	 *	可选择按钮，分选中与不选中两种状态 
	 * @author zs
	 * 
	 */
	public class SelectButton extends BaseButton implements ISelectable
	{
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
		
		[Inspectable(type="String",name="选中样式",defaultValue="SelectButtonSelectSkin")]
		public function set selectedBgStyle(value:String):void
		{
			_selectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="未选中样式",defaultValue="SelectButtonUnSelectSkin")]
		public function set unSelectedBgStyle(value:String):void
		{
			_unSelectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="选中标签",defaultValue="Selected")]
		public function set selectedLabel(value:String):void
		{
			_selectedLable= value;
			invalidate(InvalidationType.LABEL);
		}
		
		[Inspectable(type="String",name="未选中标签",defaultValue="UnSelected")]
		public function set unSelectedLabel(value:String):void
		{
			_unSelectedLable = value;
			invalidate(InvalidationType.LABEL);
		}
		[Inspectable(defaultValue=0, name="标签间隔", type="Number")]
		override public function set labelGap(value:int):void
		{
			_labelGap = value;
			invalidate(InvalidationType.LABEL);
		}
		
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
					trace("未选中选中标签格式错误",_unSelectedFormat);
				}
			}
		}
		
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
			_labelTF.y = (bg.height-_labelTF.textHeight)>>1;
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