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
	import coffe.controls.List;
	import coffe.controls.RadioButton;
	import coffe.controls.ScrollBar;
	import coffe.controls.SelectButton;
	import coffe.data.DataProvider;
	import coffe.events.FrameEvent;
	
	public class CoffeUITest extends Sprite
	{
		public function CoffeUITest()
		{
			var loader:Loader = new Loader();
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
//			loader.load(new URLRequest("coffeuiout.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
//			function onComplete(event:Event):void
			{
//				testRadioBtn();
//				testSelectBtn();
//				testButton();
//				testFrame();
//				testList();
				testScrollBar();
			}
		}
		
		private function testList():void
		{
			var list:List = new List();
			var data:DataProvider = new DataProvider([0,1,2,3,4,5,6,7,8,9,10]);
			list.data = data;
			list.width=80;
			data.addItem(11);
			addChild(list);
		}
		
		private function testScrollBar():void
		{
			var scroll:ScrollBar = new ScrollBar();
			addChild(scroll);
			scroll.drawNow();
			scroll.minScrollPosition = 1;
			scroll.maxScrollPosition = 100;
			scroll.scrollPosition = 20;
		}
		
		private function testSelectBtn():void
		{
			var radio1:SelectButton = new SelectButton();
			radio1.selectedFilter = '{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":6,"quality":2,"inner":false,"knockout":false}';
			radio1.x = 100;radio1.y = 100;
			var radio2:SelectButton = new SelectButton();
			radio2.x = 200;radio2.y = 100;
			radio1.width = 200;
			addChild(radio1);
			addChild(radio2);
		}
		
		private function testRadioBtn():void
		{
			var radio1:RadioButton = new RadioButton();
			radio1.x = 100;radio1.y = 100;radio1.labelGap = -50;
			var radio2:RadioButton = new RadioButton();
			radio2.x = 200;radio2.y = 100;radio2.labelGap = -50;
			addChild(radio1);
			addChild(radio2);
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
			txt.text = "fasdfasdf\nasdfasdg\n\n\n\n\n";
			txt.width = 200;
			txt.height = txt.textHeight+10;
			frame.setContent(txt);
			frame.drawNow();
			frame.addEventListener(FrameEvent.FRAMEEVENT,onFrameEvent);
			addChild(frame);
		}
		
		protected function onFrameEvent(event:Event):void
		{
			event.stopImmediatePropagation();
		}
	}
}