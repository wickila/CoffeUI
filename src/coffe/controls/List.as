package coffe.controls
{
	import coffe.containers.VGroup;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.data.DataProvider;
	import coffe.interfaces.ICellRender;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class List extends ScrollPane
	{
		public static const DEFAULT_STYLE:Object = {
			cellRender:"coffe.controls.CellRender",
			labelField:"label"
		};
		
		private var _cellRender:String;
		private var _cells:Vector.<ICellRender>;
		private var _data:DataProvider;
		private var _gap:int=2;
		private var _cellHeight:Number;
		private var _selected:ICellRender;
		private var _selectedData:Object;
		private var _labelField:String;
		
		public function List()
		{
			_cells = new Vector.<ICellRender>();
			_data = new DataProvider();
			super();
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
			setStyle(ScrollPane.DEFAULT_STYLE);
		}
		
		override protected function draw():void
		{
			super.draw();
			if(isInvalid(InvalidationType.DATA,InvalidationType.CELL_RENDER))
			{
				while(_cells.length>0){_cells.pop().dispose();}
				createCells();
				updateScrollBar();
				updateScrollRect();
			}
			validate();
		}
		
		override protected function updateScrollRect():void
		{
			super.updateScrollRect();
			renderCells();
		}
		/**
		 * @description 滚动时，显示出需要显示出来的数据，其他不需要显示出来的数据就不会显示出来(最后一个数据总是显示出来的，以便计算显示区域的最终高度) 
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
					addContent(cell);
					i++;
					index++;
					if((cell.y+cell.height)>contentClipWrap.scrollRect.bottom)
					{
						break;
					}
				}
			}
		}
		
		/**
		 *	@description 根据单元格高与列表的高，生成要用到的所有单元格，单元格数量最多为列表可以显示的单元格数+2 
		 * 
		 */		
		private function createCells():void
		{
			var cellNum:Number = Math.min(_data.length,Math.ceil(height/_cellHeight)+2)-_cells.length;
			for(var i:int=0;i<cellNum;i++)
			{
				var cell:ICellRender = getDisplayObjectInstance(_cellRender) as ICellRender;
				if(Object(cell).hasOwnProperty("labelField"))
				{
					Object(cell)["labelField"] = labelField;
				}
				cell.addEventListener(MouseEvent.CLICK,onCellClick);
				addContent(DisplayObject(cell));
				_cells.push(cell);
			}
			contentClip.graphics.endFill();
			contentClip.graphics.beginFill(0,0);
			contentClip.graphics.drawRect(0,0,width,_data.length*(_cellHeight+_gap));
			contentClip.graphics.endFill();
		}
		
		private function onCellClick(event:MouseEvent):void
		{
			for each(var cell:ICellRender in _cells)
			{
				cell.selected = false;
			}
			cell = event.currentTarget as ICellRender;
			cell.selected = true;
		}
		
		public function set data(value:Array):void
		{
			_data = new DataProvider(value);
			invalidate(InvalidationType.DATA);
		}
		
		public function get selectedData():Object
		{
			return _selected == null?null:_selected.data;
		}

		public function set cellRender(value:String):void
		{
			if(_cellRender == value)return;
			_cellRender = value;
			var cell:ICellRender = getDisplayObjectInstance(_cellRender) as ICellRender;
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
		}

	}
}