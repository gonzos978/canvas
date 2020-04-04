package ir.grantech.canvas.controls;

import ir.grantech.canvas.drawables.ICanItem;
import ir.grantech.canvas.services.Inputs;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class TransformHint extends Sprite {
	static final MODE_SCALE:Int = 0;
	static final MODE_ROTATE:Int = 1;

	public var mode(default, set):Int = -1;

	private function set_mode(value:Int):Int {
		if (this.mode == value)
			return this.mode;
		for (i in 0...8) {
			this.rects[i].visible = value == MODE_SCALE;
			this.circles[i].visible = value == MODE_ROTATE;
		}
		this.corners = value == MODE_SCALE ? this.rects : this.circles;
		if (this.targets.length > 0)
			this.set(this.targets[0]);
		return this.mode = value;
	}

	public function setVisible(visible:Bool, all:Bool):Void {
		if (this.lines[0].visible == visible)
			return;
		for (i in 0...8) {
			this.lines[i].visible = visible;
			this.corners[i].visible = visible;
		}
		if (all)
			this.register.visible = visible;
		this.register.alpha = visible ? 1 : 0.5;
	}

	private var radius:Float = 6;
	private var lineThickness:Float = 2;
	private var lineColor:UInt = 0x1692E6;

	private var main:Shape;
	private var hitCorner:Int;
	private var register:Shape;
	private var lines:Array<Shape>;
	private var rects:Array<Shape>;
	private var circles:Array<Shape>;
	private var corners:Array<Shape>;
	private var mouseTranslateBegin:Point;
	private var mouseScaleBegin:Point;
	private var mouseAngleBegin:Float;
	private var scaleBegin:Point;
	private var angleBegin:Float;
	private var registerRatio:Point;
	private var registerPoint:Point;

	public var targets:Array<ICanItem>;

	public function new() {
		super();

		this.main = new Shape();
		this.main.graphics.beginFill(0, 0);
		this.main.graphics.drawRect(0, 0, 100, 100);
		this.addChild(this.main);

		this.doubleClickEnabled = true;
		this.mouseTranslateBegin = new Point();
		this.mouseScaleBegin = new Point();
		this.scaleBegin = new Point();
		this.registerPoint = new Point();
		this.registerRatio = new Point(0.5, 0.5);
		this.targets = new Array<ICanItem>();

		this.register = this.addCircle(0, 0, this.radius + 1);
		this.lines = new Array<Shape>();
		this.rects = new Array<Shape>();
		this.circles = new Array<Shape>();
		for (i in 0...8) {
			this.rects.push(this.addRect(0, 0, this.radius));
			this.circles.push(this.addCircle(0, 0, this.radius + 1));
			this.lines.push(this.addLine(i == 2 || i == 3 || i == 6 || i == 7, 100));
		}
		this.lines[0].x = this.radius;
		this.lines[5].x = this.radius;
		this.lines[2].y = this.radius;
		this.lines[7].y = this.radius;

		this.mode = MODE_SCALE;
		this.setVisible(false, true);
		this.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClickHandler);
	}

	private function doubleClickHandler(event:MouseEvent):Void {
		if (this.register.hitTestPoint(stage.mouseX, stage.mouseY, true)) {
			this.registerRatio.setTo(0.5, 0.5);
			if (this.targets.length == 1)
				this.targets[0].layer.pivot.setTo(0.5, 0.5);
			this.resetRegister();
		}
		this.mode = this.mode == MODE_SCALE ? MODE_ROTATE : MODE_SCALE;
	}

	private function addCircle(fillColor:UInt, fillAlpha:Float, radius:Float):Shape {
		var c:Shape = new Shape();
		c.graphics.beginFill(fillColor, fillAlpha);
		c.graphics.lineStyle(lineThickness, lineColor);
		c.graphics.drawCircle(0, 0, radius);
		this.addChild(c);
		return c;
	}

	private function addRect(fillColor:UInt, fillAlpha:Float, radius:Float):Shape {
		var r:Shape = new Shape();
		r.graphics.beginFill(fillColor, fillAlpha);
		r.graphics.lineStyle(lineThickness, lineColor);
		r.graphics.drawRect(-radius, -radius, radius * 2, radius * 2);
		this.addChild(r);
		return r;
	}

	private function addLine(vertical:Bool, length:Float):Shape {
		var l:Shape = new Shape();
		this.drawLine(l, vertical, length);
		this.addChild(l);
		return l;
	}

	private function drawLine(l:Shape, vertical:Bool, length:Float):Void {
		l.graphics.clear();
		l.graphics.lineStyle(lineThickness, lineColor);
		l.graphics.moveTo(0, 0);
		l.graphics.lineTo(vertical ? 0 : length, vertical ? length : 0);
	}

	public function set(target:ICanItem):Void {
		this.setVisible(true, true);
		var r = target.rotation;
		target.rotation = 0;
		var w = target.width;
		var h = target.height;
		this.x = target.x;
		this.y = target.y;
		this.rotation = target.rotation = r;

		this.main.width = w;
		this.main.height = h;

		this.corners[1].x = w * 0.5;
		this.corners[2].x = w;
		this.corners[3].x = w;
		this.corners[3].y = h * 0.5;
		this.corners[4].x = w;
		this.corners[4].y = h;
		this.corners[5].x = w * 0.5;
		this.corners[5].y = h;
		this.corners[6].x = 0;
		this.corners[6].y = h;
		this.corners[7].x = 0;
		this.corners[7].y = h * 0.5;

		for (i in 0...8)
			drawLine(this.lines[i], i == 2 || i == 3 || i == 6 || i == 7, (i == 2 || i == 3 || i == 6 || i == 7 ? h : w) * 0.5 - this.radius * 2);

		this.lines[1].x = w * 0.5 + this.radius;
		this.lines[2].x = w;
		this.lines[3].x = w;
		this.lines[3].y = h * 0.5 + this.radius;
		this.lines[4].x = w * 0.5 + this.radius;
		this.lines[4].y = h;
		this.lines[5].y = h;
		this.lines[6].y = h * 0.5 + this.radius;

		if (this.targets[0] == target)
			return;
		this.targets = [target];
		if (this.targets.length == 1)
			this.registerRatio.setTo(this.targets[0].layer.pivot.x, this.targets[0].layer.pivot.y);
		else
			this.registerRatio.setTo(0.5, 0.5);
		this.resetRegister();
	}

	public function perform(state:Int):Void {
		if (state == Inputs.PHASE_BEGAN) {
			// set register point
			var r:Rectangle = this.register.getBounds(parent);
			this.registerPoint.setTo(r.left + r.width * 0.5, r.top + r.height * 0.5);

			// detect handles
			this.hitCorner = -1;
			if (this.register.hitTestPoint(stage.mouseX, stage.mouseY, true)) {
				this.hitCorner = 8;
			} else {
				for (i in 0...8) {
					if (this.corners[i].hitTestPoint(stage.mouseX, stage.mouseY, true)) {
						this.hitCorner = i;
						break;
					}
				}
			}
		} else {
			this.setVisible(false, this.hitCorner == -1);
		}

		// porform methods
		if (this.hitCorner > -1) {
			if (this.hitCorner == 8)
				this.performRegister(state);
			else if (this.mode == MODE_ROTATE)
				this.performRotate(state);
			else
				this.performScale(state);
		} else {
			this.performTranslate(state);
		}
	}

	private function performRegister(state:Int):Void {
		this.registerRatio.setTo(this.mouseX / this.scaleAnchores[4].x, this.mouseY / this.scaleAnchores[4].y);
		this.snapTo(this.registerRatio, -0.05, 0.05, -0.05, 0.05);
		this.snapTo(this.registerRatio, 0.45, 0.55, -0.05, 0.05);
		this.snapTo(this.registerRatio, 0.95, 1.05, -0.05, 0.05);
		this.snapTo(this.registerRatio, -0.05, 0.05, 0.45, 0.55);
		this.snapTo(this.registerRatio, 0.45, 0.55, 0.45, 0.55);
		this.snapTo(this.registerRatio, 0.95, 1.05, 0.45, 0.55);
		this.snapTo(this.registerRatio, -0.05, 0.05, 0.95, 1.05);
		this.snapTo(this.registerRatio, 0.45, 0.55, 0.95, 1.05);
		this.snapTo(this.registerRatio, 0.95, 1.05, 0.95, 1.05);
		if (this.targets.length == 1)
			this.targets[0].layer.pivot.setTo(this.registerRatio.x, this.registerRatio.y);
		this.resetRegister();
	}

	private function snapTo(c:Point, x1:Float, x2:Float, y1:Float, y2:Float):Void {
		if (c.x > x1 && c.x < x2 && c.y > y1 && c.y < y2)
			c.setTo(x1 + (x2 - x1) * 0.5, y1 + (y2 - y1) * 0.5);
	}

	private function resetRegister():Void {
		this.register.x = this.corners[4].x * this.registerRatio.x;
		this.register.y = this.corners[4].y * this.registerRatio.y;
	}

	private function performRotate(state:Int):Void {
		var rad = Math.atan2(this.mouseY - this.register.y, this.mouseX - this.register.x);
		if (state == Inputs.PHASE_BEGAN) {
			this.angleBegin = Math.atan2(this.targets[0].transform.matrix.b, this.targets[0].transform.matrix.a);
			this.mouseAngleBegin = rad;
			return;
		}

		// calculate destination angle
		var angle = this.angleBegin + rad - this.mouseAngleBegin;
		if (Inputs.instance.shiftKey || Inputs.instance.ctrlKey) {
			var step = Math.PI * (Inputs.instance.shiftKey ? 0.5 : 0.25);
			var mod = angle % step;
			angle += (mod > step * 0.5 ? step - mod : -mod); // snap to 90 or 45
		}

		this.rotate(angle);
	}

	// perform rotation with matrix
	public function rotate(angle:Float):Void {
		var mat:Matrix = this.targets[0].transform.matrix;
		mat.translate(-registerPoint.x, -registerPoint.y);
		mat.rotate(angle - Math.atan2(mat.b, mat.a));
		mat.translate(registerPoint.x, registerPoint.y);
		this.targets[0].transform.matrix = mat;
	}

	private function performScale(state:Int):Void {
		if (state == Inputs.PHASE_BEGAN) {
			this.mouseScaleBegin.setTo(this.mouseX - this.register.x, this.mouseY - this.register.y);
			var mat:Matrix = this.targets[0].transform.matrix;
			this.angleBegin = Math.atan2(mat.b, mat.a);
			mat.rotate(-this.angleBegin);
			this.scaleBegin.setTo(mat.a, mat.d);
			mat.rotate(this.angleBegin);
			return;
		}

		// calculate delta scale
		var sx = this.scaleBegin.x * (this.mouseX - this.register.x) / this.mouseScaleBegin.x;
		var sy = this.scaleBegin.y * (this.mouseY - this.register.y) / this.mouseScaleBegin.y;

		this.scale(sx, sy);
	}

	// perform scale with matrix
	public function scale(sx:Float, sy:Float):Void {
		var mat:Matrix = this.targets[0].transform.matrix;
		this.angleBegin = Math.atan2(mat.b, mat.a);
		mat.translate(-registerPoint.x, -registerPoint.y);
		mat.rotate(-this.angleBegin);
		if (Inputs.instance.shiftKey) {
			mat.scale(sx / mat.a, sy / mat.d);
		} else {
			if (this.hitCorner == 1 || this.hitCorner == 5)
				mat.scale(1, sy / mat.d);
			else if (this.hitCorner == 3 || this.hitCorner == 7)
				mat.scale(sx / mat.a, 1);
			else
				mat.scale(sx / mat.a, sy / mat.d);
		}
		mat.rotate(this.angleBegin);
		mat.translate(registerPoint.x, registerPoint.y);
		this.targets[0].transform.matrix = mat;
	}

	private function performTranslate(state:Int):Void {
		if (state == Inputs.PHASE_BEGAN) {
			this.mouseTranslateBegin.setTo(stage.mouseX / Inputs.instance.zoom, stage.mouseY / Inputs.instance.zoom);
			return;
		}

		// calculate delta translate
		var tx = stage.mouseX / Inputs.instance.zoom - this.mouseTranslateBegin.x;
		var ty = stage.mouseY / Inputs.instance.zoom - this.mouseTranslateBegin.y;
		this.mouseTranslateBegin.setTo(tx + this.mouseTranslateBegin.x, ty + this.mouseTranslateBegin.y);

		// perform translate with matrix
		var mat:Matrix = this.targets[0].transform.matrix;
		mat.translate(tx, ty);
		this.targets[0].transform.matrix = mat;
	}

	public function resetTransform():Void {
		var mat:Matrix = this.targets[0].transform.matrix;
		var r = this.targets[0].getBounds(this.targets[0].parent);
		mat.a = mat.d = 1;
		mat.b = mat.c = 0;
		this.targets[0].transform.matrix = mat;
		this.targets[0].x = r.left + r.width * 0.5 - this.targets[0].width * 0.5;
		this.targets[0].y = r.top + r.height * 0.5 - this.targets[0].height * 0.5;
		this.set(this.targets[0]);
	}
}
