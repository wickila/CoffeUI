// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package coffe.data {

	/**
	 * 数据改变类型是<code>DataChangeEvent.changeType</code>的枚举类型.用于列表类型的组件的数据改变时发出的事件.
	 */
	public class DataChangeType {

		public static const CHANGE:String = "change";
		public static const INVALIDATE:String = "invalidate";
		public static const INVALIDATE_ALL:String = "invalidateAll";
		public static const ADD:String = "add";
		public static const REMOVE:String = "remove";
		public static const REMOVE_ALL:String = "removeAll";
		public static const REPLACE:String = "replace";
		public static const SORT:String = "sort";
	}
}