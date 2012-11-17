package coffe.containers
{
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class VGroup extends UIComponent
	{
		private var _gap:int=2;
		public function VGroup()
		{
			super();
		}
		
		override public function drawLayout():void
		{
			var h:Number = _gap;
			for(var i:int=0;i<numChildren;i++)
			{
				var ch:DisplayObject = getChildAt(i);
				ch.y = h;
				h = h+ch.height+_gap;
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var result:DisplayObject = super.addChild(child);
			invalidate(InvalidationType.SIZE);
			return result;
		}

		[Inspectable(type="Number",name="垂直间隔",defaultValue=2)]
		public function set gap(value:int):void
		{
			_gap = value;
		}
		
		public function get gap():int
		{
			return _gap;
		}
		
		override public function dispose():void
		{
			while(numChildren>0)
			{
				removeChildAt(0);
			}
			super.dispose();
		}

	}
}