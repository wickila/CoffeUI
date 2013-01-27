package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import coffe.core.InvalidationType;
	
	public class CheckBox extends BaseButton
	{
		protected var _selectedBg:DisplayObject;
		protected var _unselectedBg:DisplayObject;
		protected var _selectedBgStyle:String="";
		protected var _unSelectedBgStyle:String="";
		public function CheckBox()
		{
			super();
			_labelGap = 10;
		}
		
		override protected function initDefaultStyle():void
		{
			_selectedBgStyle="CheckBoxSelectOverSkin";
			_unSelectedBgStyle="CheckBoxUnSelectOverSkin";
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
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set unselectedBg(value:DisplayObject):void
		{
			if(contains(_unselectedBg))removeChild(_unselectedBg);
			_unselectedBg = value;
			if(!_selected)addChild(_unselectedBg);
		}

		public function set selectedBg(value:DisplayObject):void
		{
			if(contains(_selectedBg))removeChild(_selectedBg);
			_selectedBg = value;
			if(_selected)addChild(_selectedBg);
		}

		[Inspectable(type="String",name="选中样式",defaultValue="CheckBoxSelectOverSkin")]
		public function set selectedBgStyle(value:String):void
		{
			_selectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}

		[Inspectable(type="String",name="未选中样式",defaultValue="CheckBoxUnSelectOverSkin")]
		public function set unSelectedBgStyle(value:String):void
		{
			_unSelectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}

		[Inspectable(type="String",name="标签",defaultValue="CheckBox")]
		override public function set label(value:String):void
		{
			super.label = value;
		}
		
		[Inspectable(type="Boolean",defaultValue=false)]
		public function set selected(value:Boolean):void
		{
			_selected = value;
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
				addChild(_labelTF);
			}
			_labelTF.text = _label;
			_labelTF.textColor = _textColor;
			if(isInvalid(InvalidationType.LABEL,InvalidationType.STYLE))
			{
				drawLayout();
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
			_labelTF.y = (_selectedBg.height-_labelTF.textHeight)*.5;
			_labelTF.width = _labelTF.textWidth+10;
			_labelTF.height = _labelTF.textHeight+10;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_selectedBg&&contains(_selectedBg))removeChild(_selectedBg);
			_selectedBg = null;
			if(_unselectedBg&&contains(_unselectedBg))removeChild(_unselectedBg);
			_unselectedBg = null;
		}
	}
}