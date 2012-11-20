package coffe.data {
	import flash.events.EventDispatcher;
	[Event(name="dataChange", type="fl.events.DataChangeEvent")]

	public class DataProvider extends EventDispatcher {
		protected var data:Array;

		public function DataProvider(value:Array=null) {			
			if (value == null) {
				data = [];
			} else {
				data = value				
			}
		}
		
		public function get length():uint {
			return data.length;
		}

		public function addItemAt(item:Object,index:uint):void {
			checkIndex(index,data.length);
			data.splice(index,0,item);
			dispatchChangeEvent(DataChangeType.ADD,[item],index,index);
		}

		public function addItem(item:Object):void {
			data.push(item);
			dispatchChangeEvent(DataChangeType.ADD,[item],data.length-1,data.length-1);
		}

		public function addItemsAt(items:Array,index:uint):void {
			checkIndex(index,data.length);
			data.splice.apply(data, [index,0].concat(items));
			dispatchChangeEvent(DataChangeType.ADD,items,index,index+items.length-1);
		}

		public function addItems(items:Array):void {
			addItemsAt(items,data.length);
		}

		public function concat(items:Array):void {
			addItems(items);
		}
		
		public function getItemAt(index:uint):Object {
			checkIndex(index,data.length-1);
			return data[index];
		}

		public function getItemIndex(item:Object):int {
			return data.indexOf(item);;
		}

		public function removeItemAt(index:uint):Object {
			checkIndex(index,data.length-1);
			var arr:Array = data.splice(index,1);
			dispatchChangeEvent(DataChangeType.REMOVE,arr,index,index);
			return arr[0];
		}
		
		public function removeItem(item:Object):Object {
			var index:int = getItemIndex(item);
			if (index != -1) {
				return removeItemAt(index);
			}
			return null;
		}

		public function removeAll():void {
			var arr:Array = data.concat();
			data = [];
			dispatchChangeEvent(DataChangeType.REMOVE_ALL,arr,0,arr.length);
		}
		
		public function replaceItem(newItem:Object,oldItem:Object):Object {
			var index:int = getItemIndex(oldItem);
			if (index != -1) {
				return replaceItemAt(newItem,index);
			}
			return null;
		}
		
		public function replaceItemAt(newItem:Object,index:uint):Object {
			checkIndex(index,data.length-1);
			var arr:Array = [data[index]];
			data[index] = newItem;
			dispatchChangeEvent(DataChangeType.REPLACE,arr,index,index);
			return arr[0];
		}

		public function sort(...sortArgs:Array):* {
			var returnValue:Array = data.sort.apply(data,sortArgs);
			dispatchChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			return returnValue;
		}

		public function sortOn(fieldName:Object,options:Object=null):* {
			var returnValue:Array = data.sortOn(fieldName,options);
			dispatchChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			return returnValue;
		}

		public function clone():DataProvider {
			return new DataProvider(data);
		}

		public function toArray():Array {
			return data.concat();
		}

		override public function toString():String {
			return "DataProvider ["+data.join(" , ")+"]";
		}
		
		protected function checkIndex(index:int,maximum:int):void {
			if (index > maximum || index < 0) {
				throw new RangeError("DataProvider index ("+index+") is not in acceptable range (0 - "+maximum+")");
			}
		}

		protected function dispatchChangeEvent(evtType:String,items:Array,startIndex:int,endIndex:int):void {
			dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,evtType,items,startIndex,endIndex));
		}
	}

}