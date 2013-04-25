package coffe.core
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedClassName;
	
	import coffe.events.ComponentEvent;
	import coffe.interfaces.IDisposable;
	
	public class UIComponent extends Sprite
	{
		public static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		public static const LIGHT_FILTER:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,25,0,1,0,0,25,0,0,1,0,25,0,0,0,1,0]);
		
		private var _enable:Boolean=true;
		private var inCallLaterPhase:Boolean;
		private var callLaterMethods:Dictionary;
		private var _invalidHash:Object;
		protected var _isLivePreview:Boolean;
		protected var _width:Number;
		protected var _height:Number;
		protected var _scaleX:Number=1;
		protected var _scaleY:Number=1;
		
		public function UIComponent()
		{
			super();
			callLaterMethods = new Dictionary();
			_invalidHash = {};
			initDefaultStyle();
			_isLivePreview = checkLivePreview();
			if(!_isLivePreview)removeAllChildren();
			initEvents();
			invalidate(InvalidationType.ALL);
		}
		/**
		 * 初始化样式 
		 * 
		 */		
		protected function initDefaultStyle():void
		{
			
		}
		/**
		 *	重绘组件 
		 * 
		 */		
		protected function draw():void
		{
			drawLayout();
		}
		/**
		 *	重绘组件布局 
		 * 
		 */		
		public function drawLayout():void
		{
			
		}
		
		protected function initEvents():void
		{
			addEventListener(ComponentEvent.CREATION_COMPLETE,onCreationComplete);
		}
		
		protected function removeEvents():void
		{
			removeEventListener(ComponentEvent.CREATION_COMPLETE,onCreationComplete);
		}
		/**
		 *	组件初始化完成，把Flash cs里面的资源尺寸重设
		 * @param event
		 * 
		 */		
		protected function onCreationComplete(event:Event):void
		{
			width = width*super.scaleX;
			height = height*super.scaleY;
			super.scaleX = super.scaleY = 1;
			draw();
			removeEventListener(ComponentEvent.CREATION_COMPLETE,onCreationComplete);
		}
		/**
		 *	需要的时候，在每个帧周期刷新组件 
		 * 
		 */		
		protected function update():void
		{
			draw();
			var isInit:Boolean = false;
			if(isInvalid(InvalidationType.ALL))
				isInit = true;
			validate();
			if(isInit)dispatchEvent(new ComponentEvent(ComponentEvent.CREATION_COMPLETE));
		}
		/**
		 *	标记已更新的属性，之后等待更新组件 
		 * @param property
		 * 
		 */		
		public function invalidate(property:String=InvalidationType.ALL):void {
			_invalidHash[property] = true;
			callLater(update);
		}
		/**
		 * 
		 * @param property
		 * @param properties
		 * @return 属性是否被重设过
		 * 
		 */		
		protected function isInvalid(property:String,...properties:Array):Boolean {
			if (_invalidHash[property] || _invalidHash[InvalidationType.ALL]) { return true; }
			while (properties.length > 0) {
				if (_invalidHash[properties.pop()]) { return true; }
			}
			return false
		}
		
		protected function validate():void {
			_invalidHash = {};
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
			if(!_isLivePreview)
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
		/**
		 * 设置组件样式信息
		 * @param style
		 * 
		 */		
		public function setStyle(style:Object):void
		{
			for(var s:String in style)
			{
				this[s] = style[s];
			}
		}
		/**
		 *	立即重绘组件 
		 * 
		 */		
		public function drawNow():void
		{
			draw();
			delete(callLaterMethods[draw]);
			validate();
		}
		
		public function setSize(width:Number, height:Number):void {
			this.width = width;
			this.height = height;
			invalidate(InvalidationType.SIZE);
			dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE, false));
		}
		
		public function move(x:Number,y:Number):void {
			super.x = Math.round(x);
			super.y = Math.round(y);
			dispatchEvent(new ComponentEvent(ComponentEvent.MOVE));
		}
		
		override public function set height(value:Number):void
		{
			if(_height == value)return;
			_height = value;
			invalidate(InvalidationType.SIZE);
		}
		override public function set width(value:Number):void
		{
			if(_width == value)return;
			_width = value;
			invalidate(InvalidationType.SIZE);
		}
		
		override public function get width():Number{return isNaN(_width)?super.width:_width}
		
		override public function get height():Number{return isNaN(_height)?super.height:_height}
		/**
		 *	警告:此方法已被重写，只用于预览模式。平时代码中不建议使用，而用setScaleX代替   
		 * @param value
		 * 
		 */		
		override public function set scaleX(value:Number):void {
			_scaleX = value;
			setSize(width*value,height);
		}
		/**
		 *	警告:此方法已被重写，只用于预览模式。平时代码中不建议使用，而用setScaleY代替  
		 * @param value
		 * 
		 */		
		override public function set scaleY(value:Number):void
		{
			_scaleY = value;
			setSize(width,height*value);
		}
		
		override public function get scaleX():Number
		{
			return _scaleX;
		}
		
		override public function get scaleY():Number
		{
			return _scaleY;
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
		/**
		 * 
		 * @return 是否处于Flash Cs中的编辑预览模式
		 * 
		 */		
		protected function checkLivePreview():Boolean {
			if (parent == null) { return false; }
			var className:String;
			try {
				className = getQualifiedClassName(parent);	
			} catch (e:Error) {}
			return (className == "fl.livepreview::LivePreviewParent");	
		}
		
		protected function removeAllChildren():void
		{
			while(numChildren>0)
			{
				removeChildAt(0);
			}
		}
		
		protected function combinStyle(target:Object,source:Object):void
		{
			for(var property:String in source)
			{
				target[property] = source[property];
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			callLaterMethods = null;
			_invalidHash = null;
			if(parent)
				parent.removeChild(this);
		}
		
		public static function disposeObject(obj:DisplayObject):void
		{
			if(obj==null)return;
			if(obj is IDisposable)
			{
				IDisposable(obj).dispose();
			}else if(obj is Bitmap)
			{
				Bitmap(obj).bitmapData.dispose();
			}else if(obj is MovieClip)
			{
				MovieClip(obj).stop();
			}
			obj.parent&&obj.parent.removeChild(obj);
		}
	}
}