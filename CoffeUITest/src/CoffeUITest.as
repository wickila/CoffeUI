package
{
	import flash.display.Sprite;
	
	import coffe.controls.Button;
	import coffe.controls.Frame;
	
	public class CoffeUITest extends Sprite
	{
		public function CoffeUITest()
		{
			testButton();
			testFrame();
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
			frame.setSize(600,450);
			frame.move(0,100);
			addChild(frame);
		}
	}
}