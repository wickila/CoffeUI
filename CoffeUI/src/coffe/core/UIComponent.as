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
	
	/**
	 * 
	 * 所有UI组件的基类,继承自Sprite.实现IDisposable的接口
	 * @see coffe.interfaces.IDisposable
	 */
	public class UIComponent extends Sprite implements IDisposable
	{
		/**
		 *	组件的默认样式,每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 */
		public static var DEFAULT_STYLE:Object = {
		};
		
		/**
		 *	高光滤镜.一般用于鼠标划过组件的时候 
		 */
		public static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		/**
		 *	灰度滤镜.一般用于组件不可用的时候 
		 */
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
		
		/**
		 *	创建一个组件,组件创建后,将初始化默认皮肤,初始化事件,最后将所有组件属性标记为已改变.
		 * 	但是组件不会立即绘制,除非组件被添加到舞台,或者显示调用drawNow方法 
		 */
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
		 * 初始化样式,将样式信息设置为组件对应的默认样式信息
		 * @see coffe.core.UIComponent.setStyle()
		 * @see coffe.core.UIComponent.DEFAULT_STYLE
		 */		
		protected function initDefaultStyle():void
		{
			
		}
		/**
		 *	绘制组件.由子类实现
		 * 	绘制完成后,将调用drawLayout方法调整组件布局
		 */		
		protected function draw():void
		{
			drawLayout();
		}
		/**
		 *	调整组件布局 
		 * 	由子类实现
		 */		
		public function drawLayout():void
		{
			
		}
		
		/**
		 *	注册组件事件 
		 * 
		 */
		protected function initEvents():void
		{
			addEventListener(ComponentEvent.CREATION_COMPLETE,onCreationComplete);
		}
		
		/**
		 *	移除组件事件 
		 * 
		 */
		protected function removeEvents():void
		{
			removeEventListener(ComponentEvent.CREATION_COMPLETE,onCreationComplete);
		}
		/**
		 *	组件初始化完成，把Flash cs里面的资源尺寸重设
		 * 此方法只有在Flash cs的预览模式下有用,平时使用的时候不用
		 * @param event 组件初始化完成后发出的事件
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
		 *	当组件属性改变时,此方法会在进入帧周期(EnterFrame)或者组件被添加到舞台的时候调用
		 * 	此方法将调用draw方法 
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
		 * @param property 改变的属性名称
		 * @see coffe.core.InvalidationType
		 * 
		 */		
		public function invalidate(property:String=InvalidationType.ALL):void {
			_invalidHash[property] = true;
			callLater(update);
		}
		/**
		 * 
		 * @param property 属性名称
		 * @param properties 更多的属性名称
		 * @return 属性是否改变过.
		 * 
		 */		
		protected function isInvalid(property:String,...properties:Array):Boolean {
			if (_invalidHash[property] || _invalidHash[InvalidationType.ALL]) { return true; }
			while (properties.length > 0) {
				if (_invalidHash[properties.pop()]) { return true; }
			}
			return false
		}
		
		/**
		 *	重置改变的属性集合(将所有属性标记为未改变),在所有属性改变都已经被提交处理后调用. 
		 * 
		 */
		protected function validate():void {
			_invalidHash = {};
		}

		public function get enable():Boolean
		{
			return _enable;
		}
		
		/**
		 *	 
		 * @param value 组件是否可用.
		 * 如果设置为false,则组件的所有鼠标事件全部被禁用,一般情况下会组件将应用灰度滤镜
		 * 如果设置为true,则组件响应所有鼠标事件,并且会取消组件的所有滤镜
		 * 
		 */		
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
		 * 延迟调用函数（一般在渲染前调用，目标函数每个帧周期内只会调用一次，不会重复调用）
		 * @param fn 需要调用的函数
		 * 
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
		
		/**
		 * 利用反射机制,根据className返回对应的实例.
		 * @param style 想要获得的资源的类名
		 * @return style相对应的显示对象实例.如果在程序域里面没找到对应的类,则返回null
		 * 
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
				if(style)
				{
					trace("can't find style! StyleName:",style);
				}
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
		 * 设置组件样式信息.此方法会循环style里面的每个属性,然后赋值给组件对应的样式属性.
		 * @param style 样式信息
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
		 * 	并且将所有改变的属性标记为为改变
		 */		
		public function drawNow():void
		{
			draw();
			delete(callLaterMethods[draw]);
			validate();
		}
		/**
		 *	设置组件的尺寸信息(常用)
		 * @param width 组件宽
		 * @param height 组件高
		 */		
		public function setSize(width:Number, height:Number):void {
			this.width = width;
			this.height = height;
			invalidate(InvalidationType.SIZE);
		}
		
		/**
		 *	设置组件位置信息
		 * @param x 组件的x坐标
		 * @param y	组件的y坐标
		 */
		public function move(x:Number,y:Number):void {
			super.x = Math.round(x);
			super.y = Math.round(y);
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
		 *	警告:此方法已被重写，只用于预览模式。平时代码中不建议使用，而用setScaleX,getScaleX代替   
		 * @param value
		 * 
		 */		
		override public function set scaleX(value:Number):void {
			_scaleX = value;
			setSize(width*value,height);
		}
		/**
		 *	警告:此方法已被重写，只用于预览模式。平时代码中不建议使用，而用setScaleY,getScaleY代替  
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
		
		/**
		 *	移除组件内的所有显示对象.此方法不能代替dispose 
		 * 
		 */
		protected function removeAllChildren():void
		{
			while(numChildren>0)
			{
				removeChildAt(0);
			}
		}
		
		/**
		 *	合并两个样式信息.如果有重复的样式信息属性,目标样式信息的属性将被源样式信息的属性覆盖
		 * @param target 目标样式信息:将要被合并的目标样式信息
		 * @param source 源样式信息:用来合并的样式信息
		 * 
		 */
		protected function combinStyle(target:Object,source:Object):void
		{
			for(var property:String in source)
			{
				target[property] = source[property];
			}
		}
		
		/**
		 *	销毁组件 
		 * 
		 */
		public function dispose():void
		{
			removeEvents();
			callLaterMethods = null;
			_invalidHash = null;
			if(parent)
				parent.removeChild(this);
		}
		
		/**
		 *	快捷销毁一个显示对象 
		 * @param obj 需要销毁的显示对象
		 * @see coffe.interfaces.IDisposable
		 */
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