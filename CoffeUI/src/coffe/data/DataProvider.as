package coffe.data {
	import flash.events.EventDispatcher;

	[Event(name="dataChange", type="coffe.events.DataChangeEvent")]

	/**
	 *	列表类组件用的数据集合类.当数据集合发生改变,如添加数据,删除数据,整理数据的时候,列表类组件会自动刷新数据呈现.
	 * 	@see coffe.controls.List
	 * 	@see coffe.controls.ComboBox
	 */
	public class DataProvider extends EventDispatcher {
		protected var data:Array;

		public function DataProvider(value:Array=null) {			
			if (value == null) {
				data = [];
			} else {
				data = value				
			}
		}
		
		/**
		 *	数据集合内数据的数量 
		 * @return 数据几个内数据的数量.
		 * 
		 */
		public function get length():uint {
			return data.length;
		}

		/**
		 *	向数据集合内添加一条数据.并且发出DataChangeType.ADD事件
		 * @param item 需要添加的数据对象.
		 * @param index 将要添加到集合中的位置索引.
		 * @throws RangeError 参数index超出数据集合的索引位置的时候抛出此错误.
		 */
		public function addItemAt(item:Object,index:uint):void {
			checkIndex(index,data.length);
			data.splice(index,0,item);
			dispatchChangeEvent(DataChangeType.ADD,[item],index,index);
		}

		/**
		 *	添加一条数据到数据集合末尾. 并且发出DataChangeType.ADD事件
		 * @param item 需要添加的数据.
		 * 
		 */
		public function addItem(item:Object):void {
			data.push(item);
			dispatchChangeEvent(DataChangeType.ADD,[item],data.length-1,data.length-1);
		}
		/**
		 *	向数据集合内添加多条数据. 并且发出DataChangeType.ADD事件
		 * @param items 需要添加到集合中的数据.
		 * @param index 将要添加到集合中的位置索引.
		 * @throws RangeError 参数index超出数据集合的索引位置的时候抛出此错误.
		 */
		public function addItemsAt(items:Array,index:uint):void {
			checkIndex(index,data.length);
			data.splice.apply(data, [index,0].concat(items));
			dispatchChangeEvent(DataChangeType.ADD,items,index,index+items.length-1);
		}
		/**
		 *	追加多条数据到数据集合内. 并且发出DataChangeType.ADD事件
		 * @param items 需要添加到集合中的数据.
		 * 
		 */
		public function addItems(items:Array):void {
			addItemsAt(items,data.length);
		}
		/**
		 *	通过索引获取数据集合内的数据对象. 
		 * @param index 需要查询的数据的索引.
		 * @return 数据集合内索引相对应的数据对象.
		 * @throws RangeError 参数index超出数据集合的索引位置的时候抛出此错误.
		 */		
		public function getItemAt(index:uint):Object {
			checkIndex(index,data.length-1);
			return data[index];
		}
		/**
		 *	获取数据在数据集合中的索引位置. 
		 * @param item 需要查询索引的数据对象.
		 * @return 数据在数据集合中的索引位置.如果未找到,返回-1
		 * 
		 */
		public function getItemIndex(item:Object):int {
			return data.indexOf(item);;
		}
		/**
		 *	通过索引位置移除相对应的数据对象. 并且发出DataChangeType.REMOVE事件
		 * @param index 需要移除的数据对应的索引位置.
		 * @return 从数据集合中移除掉的数据对象.
		 * @throws RangeError 参数index超出数据集合的索引位置的时候抛出此错误.
		 */
		public function removeItemAt(index:uint):Object {
			checkIndex(index,data.length-1);
			var arr:Array = data.splice(index,1);
			dispatchChangeEvent(DataChangeType.REMOVE,arr,index,index);
			return arr[0];
		}
		/**
		 *	从数据集合中移除数据对象. 并且发出DataChangeType.REMOVE事件
		 * @param item 需要从集合中移除的数据对象.
		 * @return 从数据集合中移除掉的数据对象.如果参数item不存在与数据集合中.则返回null
		 * 
		 */		
		public function removeItem(item:Object):Object {
			var index:int = getItemIndex(item);
			if (index != -1) {
				return removeItemAt(index);
			}
			return null;
		}

		/**
		 *	删除所有数据.并且发出DataChangeType.REMOVE_ALL事件
		 * 
		 */
		public function removeAll():void {
			var arr:Array = data.concat();
			data = [];
			dispatchChangeEvent(DataChangeType.REMOVE_ALL,arr,0,arr.length);
		}
		/**
		 *	用新的数据对象替换数据集合内的旧数据对象. 如果替换成功.并且发出DataChangeType.REPLACE事件
		 * @param newItem 要替换的数据对象.
		 * @param oldItem 将被替换的数据对象
		 * @return 如果替换成功,返回newItem.
		 * 
		 */		
		public function replaceItem(newItem:Object,oldItem:Object):Object {
			var index:int = getItemIndex(oldItem);
			if (index != -1) {
				return replaceItemAt(newItem,index);
			}
			return null;
		}
		/**
		 *	用新的数据对象替换数据对象中索引位置index指向的旧数据对象. 
		 * @param newItem 用来替换的新数据对象.
		 * @param index 将被替换的数据对象的索引位置.
		 * @return 如果替换成功,返回newItem
		 * @throws RangeError 参数index超出数据集合的索引位置的时候抛出此错误.
		 */		
		public function replaceItemAt(newItem:Object,index:uint):Object {
			checkIndex(index,data.length-1);
			var arr:Array = [data[index]];
			data[index] = newItem;
			dispatchChangeEvent(DataChangeType.REPLACE,arr,index,index);
			return arr[0];
		}
		/**
		 *	对数据集合中的数据进行排序。
		 * @param sortArgs 指定一个比较函数和确定排序行为的一个或多个值的参数。
		 * @return 
		 * @see Array.sort()
		 */
		public function sort(...sortArgs:Array):* {
			var returnValue:Array = data.sort.apply(data,sortArgs);
			dispatchChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			return returnValue;
		}
		/**
		 *	根据数据集合中的一个或多个字段对集合中的元素进行排序
		 * @param fieldName 一个字符串，它标识要用作排序值的字段，或一个数组，其中的第一个元素表示主排序字段，第二个元素表示第二排序字段，依此类推。
		 * @param options 所定义常数的一个或多个数字或名称，相互之间由 bitwise OR (|) 运算符隔开，它们可以更改排序行为。
		 * @return 
		 * @see Array.sortOn()
		 */
		public function sortOn(fieldName:Object,options:Object=null):* {
			var returnValue:Array = data.sortOn(fieldName,options);
			dispatchChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			return returnValue;
		}
		/**
		 *	返回数据集合的拷贝. 
		 * @return 数据集合的拷贝.
		 * 
		 */
		public function clone():DataProvider {
			return new DataProvider(data);
		}
		/**
		 *	数据集合的新的数组表示. 
		 * @return 数据集合的新的数组表示.
		 * 
		 */
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