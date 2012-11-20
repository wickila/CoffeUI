package coffe.controls
{
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.data.DataProvider;
	import coffe.events.ListEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class ComboBox extends UIComponent
	{
		public static const DEFAULT_STYLE:Object = {
			backgroundStyle:"ComboBoxSkin",
			listStyle:List.DEFAULT_STYLE
		}
		private var _backgroundStyle:String;
		private var _listStyle:Object;
		private var _button:Button;
		private var _list:List;
		private var _data:DataProvider;
		private var _selectedIndex:int=0;
		private var _labelField:String = "label";
		private var _selectedData:Object;
		private var _listContainer:Sprite;
		public function ComboBox()
		{
			super();
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLE))
			{
				if(_button == null)
				{
					_button = new Button();
					_button.displacement = false;
					_button.labelAlign = AlignType.LEFT;
					_button.addEventListener(MouseEvent.CLICK,onClick,false,int.MAX_VALUE);
				}
				_button.backGroundStyle = "ComboBoxSkin";
				_button.drawNow();
				addChild(_button);
				if(_list)
				{
					_list.setStyle(DEFAULT_STYLE.listStyle);
					_list.drawNow();
				}
			}
			if(isInvalid(InvalidationType.LABEL))
			{
				if(_selectedData&&_selectedData.hasOwnProperty(_labelField))
				{
					_button.label = _selectedData[_labelField];
				}else
				{
					_button.label = String(_selectedData);
				}
				_button.drawNow();
			}
			if(isInvalid(InvalidationType.STYLE,InvalidationType.SIZE))
			{
				drawLayout();
			}
		}
		
		override public function drawLayout():void
		{
			_button.width = width;
			_button.drawNow();
			super.drawLayout();
		}
		
		private function onClick(event:MouseEvent):void
		{
			if(_listContainer && _listContainer.parent)
			{
				_listContainer.parent.removeChild(_listContainer);
			}else
			{
				if(_list == null)
				{
					createList();
				}
				_listContainer.graphics.clear();
				_listContainer.graphics.beginFill(0,0);
				_listContainer.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
				_listContainer.graphics.endFill();
				var p:Point = localToGlobal(new Point(0,height));
				_list.move(p.x,p.y);
				_list.data = _data;
				_list.drawNow();
				stage.addChild(_listContainer);
				_listContainer.addEventListener(MouseEvent.CLICK,onListContainerClick);
			}
		}
		
		protected function createList():void
		{
			_list = new List();
			_list.setStyle(DEFAULT_STYLE.listStyle);
			_list.addEventListener(ListEvent.SELECTED_DATA_CHANGE,onSelctedDataChange);
			_list.width = width;
			_listContainer = new Sprite();
			_listContainer.addChild(_list);
		}
		
		protected function onSelctedDataChange(event:ListEvent):void
		{
			selectedData = _list.selectedData;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onListContainerClick(event:MouseEvent):void
		{
			_listContainer.removeEventListener(MouseEvent.CLICK,onListContainerClick);
			_listContainer.parent.removeChild(_listContainer);
		}
		[Collection(collectionClass="coffe.data.DataProvider", collectionItem="coffe.data.SimpleCollectionItem", identifier="item")]
		public function set data(value:DataProvider):void
		{
			if(_data == value)return;
			_data = value;
			if(_list)_list.data = value;
			selectedIndex = 0;
			invalidate(InvalidationType.DATA);
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			selectedData = _data.getItemAt(_selectedIndex);
		}

		public function set listStyle(value:Object):void
		{
			_listStyle = value;
			invalidate(InvalidationType.STYLE);
		}

		public function set backgroundStyle(value:String):void
		{
			_backgroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}

		public function get selectedData():Object
		{
			return _selectedData;
		}

		public function set selectedData(value:Object):void
		{
			if(_selectedData == value)return;
			_selectedData = value;
			invalidate(InvalidationType.LABEL);
		}
	}
}