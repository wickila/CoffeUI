package coffe.controls
{
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class CheckBox extends BaseButton
	{
		protected var _selectedBg:DisplayObject;
		protected var _unselectedBg:DisplayObject;
		protected var _selectedBgStyle:String="";
		protected var _unSelectedBgStyle:String="";
		public function CheckBox()
		{
			super();
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
					addChild(_selectedBg);
				}else{
					if(contains(_selectedBg))removeChild(_selectedBg);
					addChild(_unselectedBg);
				}
			}
			if(!_labelTF)
			{
				_labelTF = new TextField();
				_labelTF.selectable = _labelTF.mouseEnabled = false;
				addChild(_labelTF);
			}
			_labelTF.text = _label;
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
				if(!_selected)addChild(_unselectedBg);
			}
		}
		
		private function drawSelectBackground():void
		{
			var s:DisplayObject = getDisplayObjectInstance(_selectedBgStyle);
			if(s)
			{
				if(_selectedBg&&contains(_selectedBg))removeChild(_selectedBg);
				_selectedBg = s;
				if(_selected)addChild(_selectedBg);
			}
		}
		
		override public function drawLayout():void
		{
			_labelTF.x = _selectedBg.width+10;
			_labelTF.y = (_selectedBg.height-_labelTF.textHeight)*.5;
			_labelTF.height = _labelTF.textHeight+10;
		}
	}
}