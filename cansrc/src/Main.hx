package;

import feathers.controls.Application;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import flash.system.Capabilities;
import haxe.Timer;
import ir.grantech.canvas.controls.groups.CanZoom;
import ir.grantech.canvas.controls.groups.RightBar;
import ir.grantech.canvas.controls.groups.ToolBar;
import ir.grantech.canvas.controls.groups.panels.AssetsPanel;
import ir.grantech.canvas.controls.groups.panels.LayersPanel;
import ir.grantech.canvas.controls.groups.panels.Panel;
import ir.grantech.canvas.events.CanEvent;
import ir.grantech.canvas.services.BaseService;
import ir.grantech.canvas.services.Libs;
import ir.grantech.canvas.themes.CanTheme;
import openfl.display.StageQuality;
import openfl.display.StageScaleMode;

class Main extends Application {
	private var zoom:CanZoom;
	private var header:Panel;
	private var right:RightBar;
	private var left:ToolBar;
	private var leftExtension:Panel;
	private var extensions:Map<Int, Panel>;
	private var zoomLayout:AnchorLayoutData;

	public function new() {
		var paddingX:Int = Math.round(Capabilities.screenResolutionX * 0.010) * 10;
		var paddingY:Int = Math.round(Capabilities.screenResolutionX * 0.012) * 10;
		stage.quality = StageQuality.BEST;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.window.x = paddingX;
		stage.window.y = paddingY;
		stage.window.width = Math.floor(Capabilities.screenResolutionX - paddingX * 2);
		stage.window.height = Math.floor(Capabilities.screenResolutionY - paddingY * 2);
		Theme.setTheme(new CanTheme());
		BaseService.get(Libs, [stage]);
		super();

		var p = CanTheme.DPI;
		this.layout = new AnchorLayout();
		this.extensions = new Map<Int, Panel>();
		this.zoom = new CanZoom();
		this.zoom.layoutData = this.zoomLayout = new AnchorLayoutData(0, 0, p);
		this.addChild(this.zoom);

		this.header = new Panel();
		this.header.height = CanTheme.DPI * 20;
		this.header.layoutData = new AnchorLayoutData(p, p, null, p);
		this.addChild(this.header);

		var h = this.header.height + p * 2;

		this.left = new ToolBar();
		this.left.width = CanTheme.DPI * 24;
		this.left.layoutData = new AnchorLayoutData(h, null, p, p);
		this.left.addEventListener("change", this.left_changeHandler);
		this.addChild(this.left);

		this.right = new RightBar();
		this.right.layoutData = new AnchorLayoutData(h, p, p, null);
		this.right.width = CanTheme.DPI * 144;
		this.addChild(this.right);

		this.zoomLayout.top = h;
		this.zoomLayout.right = this.right.width + p;
		this.zoomLayout.left = this.left.width + p * 2;
		// stage.addEventListener(Event.RESIZE, this.stage_resizeHandler);
	}
	// private static var getDesktopResolution = System.load("SomeHeaderFile.h", "GetDesktopResolution", 2);

	private function left_changeHandler(event:CanEvent):Void {
		if (this.leftExtension != null && this.leftExtension.parent == this)
			this.removeChild(this.leftExtension);
		if (event.data == -1) {
			this.zoomLayout.left = this.left.width + CanTheme.DPI * 2;
		} else {
			this.leftExtension = this.createPanel(event.data);
			this.addChild(this.leftExtension);
			this.zoomLayout.left = this.left.width + this.leftExtension.width + CanTheme.DPI * 3;
		}
		Timer.delay(this.zoom.resetZoomAndPan, 0);
	}

	private function createPanel(index:Int):Panel {
		if (!this.extensions.exists(index)) {
			var p = CanTheme.DPI * 2;
			var pnl:Panel = index == 0 ? new LayersPanel() : new AssetsPanel();
			pnl.layoutData = new AnchorLayoutData(this.header.height + p, null, CanTheme.DPI, this.left.width + p);
			pnl.width = CanTheme.DPI * 120;
			this.extensions.set(index, pnl);
		}
		return this.extensions.get(index);
	}
}
