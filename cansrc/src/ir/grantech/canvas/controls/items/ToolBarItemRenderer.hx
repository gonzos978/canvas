package ir.grantech.canvas.controls.items;

import feathers.themes.steel.BaseSteelTheme;
import feathers.style.Theme;
import feathers.skins.RectangleSkin;
import feathers.controls.dataRenderers.ItemRenderer;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.system.Capabilities;

class ToolBarItemRenderer extends ItemRenderer implements IDataRenderer  {
	static public var SIZE:Float = 52; 
	public function new() {
		super();
		this.height = this.width = SIZE;
	}
	
	@:access(feathers.themes.steel.BaseSteelTheme)
	override function initialize():Void {
		super.initialize();

		var theme = Std.downcast(Theme.fallbackTheme, BaseSteelTheme);
		var skin = new RectangleSkin();
		skin.fill = theme.getContainerFill();
		this.backgroundSkin = skin;

		this.iconPosition = MANUAL;
 	}
	
	override private function initializeItemRendererTheme():Void {
	}

	override private function set_text(value:String):String {
		if (this.text == value)
			return this.text;
		var icon = new Bitmap(Assets.getBitmapData(value));
		icon.smoothing = true;
		icon.width = icon.height = SIZE * 0.5;
		icon.x = (this.width - icon.width) * 0.5;
		icon.y = (this.height - icon.height) * 0.5;
		this.icon = icon;

		var selectedIcon = new Bitmap(Assets.getBitmapData(value + "_selected"));
		selectedIcon.smoothing = true;
		selectedIcon.width = selectedIcon.height = icon.width;
		selectedIcon.x = icon.x;
		selectedIcon.y = icon.y;
		this.selectedIcon = selectedIcon;

		return this.text = value;
	}

	override private function refreshText():Void {
	}
}
