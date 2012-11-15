package coffe.controls
{
	import coffe.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class CheckBox extends UIComponent
	{
		public var avatar:DisplayObject;
		protected var _selectedBg:DisplayObject;
		protected var _unselectedBg:DisplayObject;
		protected var _selectedBgStyle:String;
		protected var _unSelectedBgStyle:String;
		private var _selected:Boolean;
		private var _textField:TextField;
		public function CheckBox()
		{
			super();
		}
		
		override protected function initEvents():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN,onButtonDown);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			
		}
		
		protected function onButtonDown(event:MouseEvent):void
		{
			
		}
		
		protected function onAddToStage(event:Event):void
		{
			if(avatar)
			{
				removeChild(avatar);
				avatar = null;
			}
		}
		
		public function set unselectedBg(value:DisplayObject):void
		{
			_unselectedBg = value;
		}

		public function set selectedBg(value:DisplayObject):void
		{
			_selectedBg = value;
		}

		override protected function configDefaultStyle():void
		{
			_selectedBgStyle = "CheckBoxSelectOverSkin";
			_unSelectedBgStyle = "CheckBoxUnSelectOverSkin";
		}

		[Inspectable(type="String",defaultValue="CheckBoxSelectOverSkin")]
		public function set selectedBgStyle(value:String):void
		{
			_selectedBgStyle = value;
			var temp:DisplayObject = getDisplayObjectInstance(_selectedBgStyle);
			if(temp)
			{
				if(_selectedBg)
				{
					if(contains(_selectedBg))removeChild(_selectedBg);
				}
				_selectedBg = temp;
				if(_selected)addChild(_selectedBg);
			}
			updateLayout();
		}

		[Inspectable(type="String",defaultValue="CheckBoxUnSelectOverSkin")]
		public function set unSelectedBgStyle(value:String):void
		{
			_unSelectedBgStyle = value;
			var temp:DisplayObject = getDisplayObjectInstance(_unSelectedBgStyle);
			if(temp)
			{
				if(_unselectedBg)
				{
					if(contains(_unselectedBg))removeChild(_unselectedBg);
				}
				_unselectedBg = temp;
				if(!_selected)addChild(_unselectedBg);
			}
			updateLayout();
		}

		[Inspectable(type="String",defaultValue="CheckBox")]
		public function set label(value:String):void
		{
			_textField.text = value;
		}

		override protected function configUI():void
		{
			_selectedBg = getDisplayObjectInstance(_selectedBgStyle);
			_unselectedBg = getDisplayObjectInstance(_unSelectedBgStyle);
			if(_selected)
			{
				addChild(_selectedBg);
			}else
			{
				addChild(_unselectedBg);
			}
			_textField = new TextField();
			_textField.selectable = false;
			_textField.text = "CheckBox";
			addChild(_textField);
			updateLayout();
		}
		
		protected function updateLayout():void
		{
			_textField.x = _selectedBg.width+10;
			_textField.y = (_selectedBg.height-_textField.textHeight)*.5;
		}
	}
}