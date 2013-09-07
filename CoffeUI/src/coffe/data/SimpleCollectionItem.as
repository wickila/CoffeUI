// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package coffe.data {
	
	/**
	 * 用于Flash CS编辑时候的简单数据对象
	 *  @productversion Flash CS3
	 */
	dynamic public class SimpleCollectionItem {
		
		[Inspectable()]
		public var label:String;
		[Inspectable()]
		public var data:String;
		public function SimpleCollectionItem() {}	
		public function toString():String {
			return "[SimpleCollectionItem: "+label+","+data+"]";	
		}
	}	
}