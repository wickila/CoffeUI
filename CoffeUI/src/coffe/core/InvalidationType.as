package coffe.core
{
	

	/**
	 *	 InvalidationType类是在组件的属性改变时候使用的标记类型.
	 * 	@example 当按钮的label属性发生改变时,会标记按钮标记列表里面标记InvalidationType.LABLE为true,以方便在下个帧周期或者组件被添加到舞台的时候重绘按钮的label
	 * 
	 */
	public final class InvalidationType
	{
		public static const ALL:String="all";
		public static const LABEL:String = "label";
		public static const SIZE:String = "size";
		public static const SELECT:String = "select";
		public static const STYLE:String = "style";
		public static const ENABLE:String = "enable";
		public static const DATA:String = "data";
		public static const CELL_RENDER:String = "cellRender";
		public static const STATE:String="state";
		public static const CONTENT:String = "content";
		
		public function InvalidationType()
		{
		}
	}
}