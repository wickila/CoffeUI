package coffe.controls
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.data.DataProvider;
	import coffe.events.ListEvent;
	
	public class ComboBox extends UIComponent
	{
		public static const DEFAULT_STYLE:Object = {
			listStyle:List.DEFAULT_STYLE,
			buttonBackgroundStyle:"ComboBoxSkin"
		}
		private var _listStyle:Object={};
		private var _buttonStyle:Object = {};
		private var _listHeight:int=100;
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
				_button.setStyle(_buttonStyle);
				_button.drawNow();
				addChild(_button);
				if(_list)
				{
					_list.setStyle(_listStyle);
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
			_list.setStyle(_listStyle);
			_list.addEventListener(ListEvent.SELECTED_DATA_CHANGE,onSelctedDataChange);
			_list.width = width;
			_list.height = _listHeight;
			_listContainer = new Sprite();
			_listContainer.addChild(_list);
		}
		
		override protected function removeEvents():void
		{			
			if(_list)_list.removeEventListener(ListEvent.SELECTED_DATA_CHANGE,onSelctedDataChange);
			if(_listContainer)_listContainer.removeEventListener(MouseEvent.CLICK,onListContainerClick);
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
			combinStyle(_listStyle,value);
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
		
		[Inspectable(type="String",name="按钮背景样式",defaultValue="ComboBoxSkin")]
		public function set buttonBackgroundStyle(value:String):void
		{
			_buttonStyle.backGroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="按钮标签滤镜",defaultValue='{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}')]
		public function set labelFilter(value:String):void
		{
			_buttonStyle.labelFilter = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="按钮标签样式",defaultValue='{"color":"0x000000","font":"Arial","size":12}')]
		public function set labelFormat(value:String):void
		{
			_buttonStyle.labelFormat = value;
			invalidate(InvalidationType.STYLE);
		} 
		
		public function set buttonStyle(value:Object):void
		{
			combinStyle(_buttonStyle,value);
			invalidate(InvalidationType.STYLE);
		}

		public function get listHeight():int
		{
			return _listHeight;
		}

		[Inspectable(type="Number",name="下拉列表高度",defaultValue='100')]
		public function set listHeight(value:int):void
		{
			_listHeight = value;
			if(_list!=null)
			{
				_list.height = _listHeight;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_data)_data.removeAll();_data = null;
			if(_list)_list.dispose();_list = null;
			if(_listContainer&&contains(_listContainer))removeChild(_listContainer);_list = null;
			if(_button)_button.dispose();_button = null;
		}
	}
}