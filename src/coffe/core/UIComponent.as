package coffe.core
{
	
	import avmplus.getQualifiedClassName;
	
	import coffe.events.ComponentEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class UIComponent extends Sprite
	{
		public static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		
		private var _enable:Boolean=true;
		private var inCallLaterPhase:Boolean;
		private var callLaterMethods:Dictionary;
		private var invalidHash:Object;
		protected var isLivePreview:Boolean;
		protected var _x:Number;
		protected var _y:Number;
		protected var startWidth:Number;
		protected var startHeight:Number;
		
		public function UIComponent()
		{
			super();
			callLaterMethods = new Dictionary();
			invalidHash = {};
			initDefaultStyle();
			isLivePreview = checkLivePreview();
			if(!isLivePreview)
			{
				while(numChildren>0)
				{
					removeChildAt(0);
				}
			}
			initEvents();
			invalidate(InvalidationType.ALL);
		}
		
		protected function initDefaultStyle():void
		{
			
		}
		
		protected function draw():void
		{
			drawLayout();
			validate();
		}
			
		public function drawLayout():void
		{
		}
		
		protected function initEvents():void
		{
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		public function invalidate(property:String=InvalidationType.ALL):void {
			invalidHash[property] = true;
			callLater(draw);
		}
		
		protected function isInvalid(property:String,...properties:Array):Boolean {
			if (invalidHash[property] || invalidHash[InvalidationType.ALL]) { return true; }
			while (properties.length > 0) {
				if (invalidHash[properties.pop()]) { return true; }
			}
			return false
		}
		
		protected function validate():void {
			invalidHash = {};
		}

		public function get enable():Boolean
		{
			return _enable;
		}
		
		[Inspectable(type="Boolean",name="是否可用",defaultValue=true)]
		public function set enable(value:Boolean):void
		{
			_enable = mouseChildren = mouseEnabled = value;
			if(_enable)
			{
				filters = [];
			}else
			{
				filters = [GRAY_FILTER];
			}
			invalidate(InvalidationType.ENABLE);
		}
		
		/**
		 * 
		 * @param fn 需要调用的函数
		 * @description 延迟调用（一般在渲染前调用，目标函数每个帧周期内只会调用一次，不会重复调用）
		 */		
		protected function callLater(fn:Function):void {
			if(inCallLaterPhase) { return; }
			if(!isLivePreview)
			{
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
			}else
			{
				fn();
			}
		}
		
		private function callLaterDispatcher(event:Event):void {
			if (event.type == Event.ADDED_TO_STAGE) {
				try {
					removeEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher);
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
		
		public function setStyle(style:Object):void
		{
			for(var s:String in style)
			{
				this[s] = style[s];
			}
		}
		
		public function drawNow():void
		{
			draw();
			delete(callLaterMethods[draw]);
		}
		
		protected function getScaleY():Number {
			return super.scaleY;
		}
		
		protected function setScaleY(value:Number):void {
			super.scaleY = value;
		}
		protected function getScaleX():Number {
			return super.scaleX;
		}
		
		protected function setScaleX(value:Number):void {
			super.scaleX = value;
		}
		
		public function setSize(width:Number, height:Number):void {
			invalidate(InvalidationType.SIZE);
			dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE, false));
		}
		
		public function move(x:Number,y:Number):void {
			_x = x;
			_y = y;
			super.x = Math.round(x);
			super.y = Math.round(y);
			dispatchEvent(new ComponentEvent(ComponentEvent.MOVE));
		}
		
		override public function get x():Number { return ( isNaN(_x) )?super.x:_x; }
		
		override public function set x(value:Number):void {
			move(value,_y);
		}
		
		override public function get y():Number {
			return ( isNaN(_y) )?super.y:_y;
		}
		
		override public function set y(value:Number):void {
			move(_x, value);	
		}
		
		override public function get scaleX():Number {
			return width / startWidth;
		}
		
		override public function set scaleX(value:Number):void {
			setSize(startWidth*value, height);
		}
		
		override public function get scaleY():Number {
			return height / startHeight;
		}
		
		override public function set scaleY(value:Number):void {
			setSize(width, startHeight*value);
		}
		
		protected function checkLivePreview():Boolean {
			if (parent == null) { return false; }
			var className:String;
			try {
				className = getQualifiedClassName(parent);	
			} catch (e:Error) {}
			return (className == "fl.livepreview::LivePreviewParent");	
		}
		
		public function dispose():void
		{
			if(parent)
				parent.removeChild(this);
		}
	}
}