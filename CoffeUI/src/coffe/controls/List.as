package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.data.DataChangeEvent;
	import coffe.data.DataProvider;
	import coffe.data.SimpleCollectionItem;
	import coffe.events.ListEvent;
	import coffe.events.ScrollEvent;
	import coffe.interfaces.ICellRender;
	/**
	 *	列表 
	 * @author wicki
	 * 
	 */	
	public class List extends ScrollPane
	{
		public static var DEFAULT_STYLE:Object = {
			cellRender:"coffe.controls.CellRender",
			labelField:"label"
		};
		
		private var _cellRender:String;
		private var _cells:Vector.<ICellRender>;
		private var _data:DataProvider;
		private var _gap:Number=2;
		private var _cellHeight:Number;
		private var _selectedData:Object;
		private var _labelField:String;
		private var _simpleCollectionImport:SimpleCollectionItem;
		private var _cellRenderImport:CellRender;
		private var _cellAutoSize:Boolean=true;
		
		public function List()
		{
			_cells = new Vector.<ICellRender>();
			_data = new DataProvider();
			super();
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
			super.initDefaultStyle();
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			if(_data)_data.removeEventListener(DataChangeEvent.DATA_CHANGE,onDataChange);
			for each(var cell:ICellRender in _cells)
			{
				cell.removeEventListener(MouseEvent.CLICK,onCellClick);
			}
		}
		
		override protected function draw():void
		{
			super.drawComponents();
			if(isInvalid(InvalidationType.STYLE,InvalidationType.SIZE))
			{
				drawLayout();
				updateScrollRect();
			}
			if(isInvalid(InvalidationType.DATA,InvalidationType.CELL_RENDER))
			{
				if(isInvalid(InvalidationType.CELL_RENDER))
				{
					while(_cells.length>0){var cell:ICellRender=_cells.pop();cell.removeEventListener(MouseEvent.CLICK,onCellClick);cell.dispose();}
				}
				createCells();
				updateScrollBar();
				updateScrollRect();
			}
			if(isInvalid(InvalidationType.DATA,InvalidationType.CELL_RENDER,InvalidationType.SIZE,InvalidationType.STYLE))
			{
				renderCells();
			}
		}
		
		override protected function updateScrollBar():void
		{
			contentClip.graphics.clear();
			contentClip.graphics.beginFill(0,0);
			contentClip.graphics.drawRect(0,0,width,_data.length*(_cellHeight+_gap));
			contentClip.graphics.endFill();
			super.updateScrollBar();
		}
		
		override protected function onScrollEvent(event:ScrollEvent):void
		{
			super.onScrollEvent(event);
			renderCells();
		}
		/**
		 * 滚动时，渲染出需要显示出来的数据，其他不需要显示出来的数据就不会被渲染出来
		 * 
		 */		
		private function renderCells():void
		{
			while(contentClip.numChildren>0)
			{
				contentClip.removeChildAt(0);
			}
			if(_cells.length>0&&_data.length>0)
			{
				var index:int = Math.floor(contentClipWrap.scrollRect.y/(_cellHeight+_gap));
				var i:int=0;
				var cell:DisplayObject;
				while(index<_data.length)
				{
					cell = _cells[i] as DisplayObject;
					_cells[i].data = _data.getItemAt(index);
					cell.y = index*(_cellHeight+_gap);
					_cells[i].selected = _selectedData == _cells[i].data;
					contentClip.addChild(cell);
					if(_cellAutoSize)cell.width = width-vScrollWidth;
					if(cell is UIComponent)UIComponent(cell).drawNow();
					i++;index++;
					if((cell.y+cell.height)>contentClipWrap.scrollRect.bottom)break;
				}
			}
		}
		
		/**
		 *	@description 根据单元格高与列表的高，生成要用到的所有单元格，单元格数量最多为列表可以显示的单元格数+2 
		 * 
		 */		
		private function createCells():void
		{
			var cellNum:Number = Math.min(_data.length,Math.ceil(height/(_cellHeight+_gap))+2)-_cells.length;
			for(var i:int=0;i<cellNum;i++)
			{
				var cell:DisplayObject = getDisplayObjectInstance(_cellRender);
				if(cell.hasOwnProperty("labelField"))
				{
					cell["labelField"] = labelField;
				}
				if(cell is UIComponent)UIComponent(cell).drawNow();
				cell.addEventListener(MouseEvent.CLICK,onCellClick);
				_cells.push(cell as ICellRender);
			}
		}
		
		private function onCellClick(event:MouseEvent):void
		{
			for each(var cell:ICellRender in _cells)
			{
				cell.selected = false;
			}
			cell = event.currentTarget as ICellRender;
			cell.selected = true;
			if(_selectedData != cell.data)
			{
				_selectedData = cell.data;
				dispatchEvent(new ListEvent(ListEvent.SELECTED_DATA_CHANGE));
			}
		}
		[Collection(collectionClass="coffe.data.DataProvider", collectionItem="coffe.data.SimpleCollectionItem", identifier="item")]
		public function set data(value:DataProvider):void
		{
			if(_data == value)return;
			if(_data)
			{
				_data.removeAll();
				_data.removeEventListener(DataChangeEvent.DATA_CHANGE,onDataChange);
			}
			_data = value;
			if(_data == null)_data = new DataProvider();
			_data.addEventListener(DataChangeEvent.DATA_CHANGE,onDataChange);
			invalidate(InvalidationType.DATA);
		}
		
		private function onDataChange(event:DataChangeEvent):void
		{
			invalidate(InvalidationType.DATA);
		}
		
		public function get selectedData():Object
		{
			return _selectedData;
		}
		
		public function set selectedData(value:Object):void
		{
			if(_selectedData == value)return;
			_selectedData = value;
			for each(var cell:ICellRender in _cells)
			{
				cell.selected = cell.data == _selectedData;
			}
			dispatchEvent(new ListEvent(ListEvent.SELECTED_DATA_CHANGE));
		}

		public function set cellRender(value:String):void
		{
			if(_cellRender == value)return;
			_cellRender = value;
			var cell:ICellRender = getDisplayObjectInstance(_cellRender) as ICellRender;
			if(cell is UIComponent)
			{
				UIComponent(cell).drawNow();
			}
			_cellHeight = DisplayObject(cell).height;
			_cellRender = value;
			invalidate(InvalidationType.CELL_RENDER);
		}

		public function get labelField():String
		{
			return _labelField;
		}

		public function set labelField(value:String):void
		{
			_labelField = value;
			invalidate(InvalidationType.CELL_RENDER)
		}
		
		override public function dispose():void
		{
			super.dispose();
			while(_cells.length>0)
			{
				_cells.pop().dispose();
			}
			_cells = null;
			_selectedData = null;
			if(_data)
			{
				_data.removeAll();
				_data.removeEventListener(DataChangeEvent.DATA_CHANGE,onDataChange);
			}
			_data = null;
		}

		/**
		 *	cell的宽度是否根据list的宽度自动调整 
		 */
		public function get cellAutoSize():Boolean
		{
			return _cellAutoSize;
		}

		public function set cellAutoSize(value:Boolean):void
		{
			_cellAutoSize = value;
		}
		/**
		 *	单元格之间的间隔 
		 * @return 
		 * 
		 */		
		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			_gap = value;
			invalidate(InvalidationType.SIZE);
		}

	}
}