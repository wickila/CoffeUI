package coffe.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class UIComponent extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		private var _enable:Boolean=true;
		private var inCallLaterPhase:Boolean;
		private var callLaterMethods:Dictionary;
		
		public function UIComponent()
		{
			super();
			configDefaultStyle();
			configUI();
			initEvents();
		}
		
		protected function configDefaultStyle():void
		{
			
		}
		
		protected function configUI():void
		{
		}
		
		protected function initEvents():void
		{
			
		}
		
		override public function get width():Number
		{
			return _width;
		}
		[Inspectable(type="Number")]
		override public function set width(value:Number):void
		{
			_width = value;
		}

		override public function get height():Number
		{
			return _height;
		}
		[Inspectable(type="Number")]
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}
		[Inspectable(type="Boolean",defaultValue=true)]
		public function set enable(value:Boolean):void
		{
			_enable = value;
			if(_enable)
			{
				filters = [];
			}else
			{
				filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1])];
			}
		}
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function callLater(fn:Function):void {
			if (inCallLaterPhase) { return; }
			
			callLaterMethods[fn] = true;
			if (stage != null) {
				try {
					stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
					stage.invalidate();
				} catch (se:SecurityError) {
					addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
				}
			} else {
				addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
			}
		}
		
		private function callLaterDispatcher(event:Event):void {
			if (event.type == Event.ADDED_TO_STAGE) {
				try {
					removeEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher);
					// now we can listen for render event:
					stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
					stage.invalidate();
					return;
				} catch (se1:SecurityError) {
					addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
				}
			} else {
				event.target.removeEventListener(Event.RENDER,callLaterDispatcher);
				event.target.removeEventListener(Event.ENTER_FRAME,callLaterDispatcher);
				try {
					if (stage == null) {
						// received render, but the stage is not available, so we will listen for addedToStage again:
						addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
						return;
					}
				} catch (se2:SecurityError) {
				}
			}
			
			inCallLaterPhase = true;
			
			var methods:Dictionary = callLaterMethods;
			for (var method:Object in methods) {
				method();
				delete(methods[method]);
			}
			inCallLaterPhase = false;
		}
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function getDisplayObjectInstance(style:String):DisplayObject {
			var classDef:Object = null;
			try {
				classDef = getDefinitionByName(style);
			}catch(e:Error) {
				try {
					classDef = loaderInfo.applicationDomain.getDefinition(style) as Object;
				} catch (e:Error) {
					// Nothing
				}
			}
			
			if(classDef == null) {
				return null;
			}
			var instance:Object = new classDef();
			if(instance is BitmapData)
			{
				return new Bitmap(instance as BitmapData);
			}
			return instance as DisplayObject;
		}
		
		public function dispose():void
		{
			
		}
	}
}