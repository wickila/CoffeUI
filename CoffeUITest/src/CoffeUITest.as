package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	import coffe.controls.Button;
	import coffe.controls.Frame;
	
	public class CoffeUITest extends Sprite
	{
		public function CoffeUITest()
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			loader.load(new URLRequest("coffeuiout.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
			function onComplete(event:Event):void
			{
				testButton();
				testFrame();
			}
		}
		
		private function testButton():void
		{
			var btn:Button = new Button();
			btn.label = "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww";
			addChild(btn);
		}
		
		private function testFrame():void
		{
			var frame:Frame = new Frame();
			frame.showCloseBtn = true;
			frame.showOkBtn = true;
			frame.showCancelBtn = true;
			frame.title = "提示";
			frame.move(0,100);
			var txt:TextField = new TextField();
			txt.text = "fasdfasdf";
			txt.width = 200;
			txt.height = txt.textHeight+10;
			frame.setContent(txt);
			frame.drawNow();
			trace(frame.width);
			addChild(frame);
		}
	}
}