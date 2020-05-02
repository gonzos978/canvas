package ir.grantech.canvas.drawables;

import flash.geom.Matrix;
import haxe.ds.ArraySort;
import ir.grantech.canvas.controls.groups.CanScene;
import ir.grantech.canvas.services.Commands;
import ir.grantech.canvas.services.Layers.Layer;
import lime.math.RGB;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;

class CanItems {
	public var length(get, never):Int;

	private function get_length():Int {
		return this.items.length;
	}

	public var isFill(get, never):Bool;

	public function get_isFill():Bool {
		return this.length > 0;
	}

	public var isEmpty(get, never):Bool;

	public function get_isEmpty():Bool {
		return this.length < 1;
	}

	public var isUI(get, never):Bool;

	public function get_isUI():Bool {
		return this.type == Layer.TYPE_TEXT;
	}

	/**
		get agreegated type of the items
	**/
	public var type(get, never):String;

	public function get_type():String {
		if (this.isEmpty)
			return Layer.TYPE_NONE;

		var t = this.items[0].layer.type;
		for (i in 1...this.length)
			if (t != this.items[i].layer.type)
				return Layer.TYPE_NONE;
		return t;
	}

	/**
		Accesses the visible of the items
	**/
	public var visible(default, set):Bool = true;

	private function set_visible(value:Bool):Bool {
		if (this.visible == value)
			return value;
		this.visible = value;
		for (item in this.items)
			item.visible = value;
		return value;
	}

	@:isVar
	public var alpha(get, set):Float;

	private function get_alpha():Float {
		if (this.isEmpty)
			return 1.0;
		var fa:Float = this.items[0].layer.fillAlpha;
		for (i in 1...this.length)
			if (fa != this.items[i].layer.fillAlpha)
				return 1.0;
		return fa;
	}

	private function set_alpha(value:Float):Float {
		if (this.alpha == value)
			return value;
		for (item in this.items)
			item.alpha = value;
		return value;
	}

	/**
		Accesses the blendMode of the items
	**/
	@:isVar
	public var blendMode(get, set):BlendMode;

	private function get_blendMode():BlendMode {
		if (this.isEmpty)
			return this.blendMode;

		var b:BlendMode = this.items[0].blendMode;
		for (i in 1...this.length)
			if (b != this.items[i].blendMode)
				return "";
		return b;
	}

	private function set_blendMode(value:BlendMode):BlendMode {
		if (this.isEmpty) {
			if (this.blendMode == value)
				return value;
			this.blendMode = value;
		}
		for (item in this.items)
			item.blendMode = value;
		return value;
	}

	/**
		Accesses the fillEnabled of the items
	**/
	@:isVar
	public var fillEnabled(get, set):Bool = true;

	private function get_fillEnabled():Bool {
		if (this.isEmpty)
			return this.fillEnabled;
		var fe = this.items[0].layer.fillEnabled;
		for (i in 1...this.length)
			if (fe != this.items[i].layer.fillEnabled)
				return false;
		return fe;
	}

	private function set_fillEnabled(value:Bool):Bool {
		if (this.isEmpty) {
			if (this.fillEnabled == value)
				return value;
			this.fillEnabled = value;
		}
		for (item in this.items)
			item.layer.fillEnabled = value;
		return value;
	}

	/**
		Accesses the fillColor of the items
	**/
	@:isVar
	public var fillColor(get, set):RGB = 0xFF;

	private function get_fillColor():RGB {
		if (this.isEmpty)
			return this.fillColor;
		var fc:RGB = this.items[0].layer.fillColor;
		for (i in 1...this.length)
			if (fc != this.items[i].layer.fillColor)
				return this.fillColor;
		return fc;
	}

	private function set_fillColor(value:RGB):RGB {
		if (this.isEmpty) {
			if (this.fillColor == value)
				return value;
			this.fillColor = value;
		}
		this.fillColor = value;
		for (item in this.items)
			item.layer.fillColor = value;
		return value;
	}

	/**
		Accesses the fillAlpha of the items
	**/
	@:isVar
	public var fillAlpha(get, set):Float = 1.0;

	private function get_fillAlpha():Float {
		if (this.isEmpty)
			return this.fillAlpha;
		var fa:Float = this.items[0].layer.fillAlpha;
		for (i in 1...this.length)
			if (fa != this.items[i].layer.fillAlpha)
				return 1.0;
		return fa;
	}

	private function set_fillAlpha(value:Float):Float {
		if (this.isEmpty) {
			if (this.fillAlpha == value)
				return value;
			this.fillAlpha = value;
		}
		for (item in this.items)
			item.layer.fillAlpha = value;
		return value;
	}

	/**
		Accesses the borderEnabled of the items
	**/
	@:isVar
	public var borderEnabled(get, set):Bool = true;

	private function get_borderEnabled():Bool {
		if (this.isEmpty)
			return this.borderEnabled;
		var be = this.items[0].layer.borderEnabled;
		for (i in 1...this.length)
			if (be != this.items[i].layer.borderEnabled)
				return false;
		return be;
	}

	private function set_borderEnabled(value:Bool):Bool {
		if (this.isEmpty) {
			if (this.borderEnabled == value)
				return value;
			this.borderEnabled = value;
		}
		for (item in this.items)
			item.layer.borderEnabled = value;
		return value;
	}

	/**
		Accesses the borderColor of the items
	**/
	@:isVar
	public var borderColor(get, set):RGB = 0xFF0000;

	private function get_borderColor():RGB {
		if (this.isEmpty)
			return this.borderColor;
		var lc:RGB = this.items[0].layer.borderColor;
		for (i in 1...this.length)
			if (lc != this.items[i].layer.borderColor)
				return 0xFFFFFF;
		return lc;
	}

	private function set_borderColor(value:RGB):RGB {
		if (this.isEmpty) {
			if (this.borderColor == value)
				return value;
			this.borderColor = value;
		}
		for (item in this.items)
			item.layer.borderColor = value;
		return value;
	}

	/**
		Accesses the borderAlpha of the items
	**/
	@:isVar
	public var borderAlpha(get, set):Float = 1.0;

	private function get_borderAlpha():Float {
		if (this.isEmpty)
			return this.borderAlpha;
		var la:Float = this.items[0].layer.borderAlpha;
		for (i in 1...this.length)
			if (la != this.items[i].layer.borderAlpha)
				return 1.0;
		return la;
	}

	private function set_borderAlpha(value:Float):Float {
		if (this.isEmpty) {
			if (this.borderAlpha == value)
				return value;
			this.borderAlpha = value;
		}
		for (item in this.items)
			item.layer.borderAlpha = value;
		return value;
	}

	/**
		Accesses the borderSize of the items
	**/
	@:isVar
	public var borderSize(get, set):Float = 3.0;

	private function get_borderSize():Float {
		if (this.isEmpty)
			return this.borderAlpha;
		var la:Float = this.items[0].layer.borderSize;
		for (i in 1...this.length)
			if (la != this.items[i].layer.borderSize)
				return 1.0;
		return la;
	}

	private function set_borderSize(value:Float):Float {
		if (this.isEmpty) {
			if (this.borderSize == value)
				return value;
			this.borderSize = value;
		}
		for (item in this.items)
			item.layer.borderSize = value;
		return value;
	}

	/**
		Accesses to textFormat of the items
	**/
	@:isVar
	public var textFormat(get, set):TextFormat = new TextFormat("IRANSans Light", 32, 0xFF);

	private function get_textFormat():TextFormat {
		// if (this.isEmpty)
		// 	return this.textFormat;
		if (this.length == 1)
			return this.items[0].layer.textFormat;
		return this.textFormat;
	}

	private function set_textFormat(value:TextFormat):TextFormat {
		// if (this.isEmpty) {
		// 	if (this.textFormat == value)
		// 		return value;
		// 	this.textFormat = value;
		// }
		for (item in this.items)
			item.layer.textFormat = value;
		return value;
	}

	public var bounds:Rectangle;
	public var items:Array<ICanItem>;
	public var pivot:Point;
	public var pivotV:Point;

	public function new() {
		this.items = new Array<ICanItem>();
		this.bounds = new Rectangle();
		this.pivot = new Point(0.5, 0.5);
		this.pivotV = new Point();
	}

	public function add(item:ICanItem, finalize:Bool = true):Bool {
		if (this.indexOf(item) > -1)
			return false;

		this.items.push(item);
		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [this]);
		}
		return true;
	}

	public function removeAll(finalize:Bool = true):Void {
		while (this.length > 0)
			this.items.pop();

		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [this]);
		}
	}

	public function remove(item:ICanItem, finalize:Bool = true):Bool {
		var ret = this.items.remove(item);
		if (!ret)
			return false;
		if (finalize) {
			this.calculateBounds();
			Commands.instance.commit(Commands.SELECT, [this]);
		}
		return true;
	}

	public function deleteAll():Void {
		while (this.length > 0) {
			var item = this.items.pop();
			if (item.parent != null)
				item.parent.removeChild(cast(item, DisplayObject));
		}

		this.calculateBounds();
		Commands.instance.commit(Commands.SELECT, [this]);
	}

	public function get(index:Int):ICanItem {
		if (index >= this.length)
			return null;
		return this.items[index];
	}

	public function indexOf(item:ICanItem):Int {
		return this.items.indexOf(item);
	}

	public function calculateBounds() {
		this.bounds.x = Math.POSITIVE_INFINITY;
		this.bounds.y = Math.POSITIVE_INFINITY;
		this.bounds.width = Math.NEGATIVE_INFINITY;
		this.bounds.height = Math.NEGATIVE_INFINITY;
		if (this.length == 0)
			return;

		for (t in this.items) {
			var b = t.getBounds(t.parent);
			this.bounds.x = Math.min(this.bounds.x, b.x);
			this.bounds.y = Math.min(this.bounds.y, b.y);
			this.bounds.width = Math.max(this.bounds.width, b.x + b.width);
			this.bounds.height = Math.max(this.bounds.height, b.y + b.height);
		}
		this.bounds.width -= this.bounds.x;
		this.bounds.height -= this.bounds.y;

		if (this.length == 1)
			this.pivot.setTo(this.items[0].layer.pivot.x, this.items[0].layer.pivot.y);
		else
			this.pivot.setTo(0.5, 0.5);
	}

	// perform translate with matrix
	public function translate(dx:Float, dy:Float, index:Int = -1):Void {
		if (index > -1)
			this.stranslate(this.items[index], dx, dy);
		else
			for (item in this.items)
				this.stranslate(item, dx, dy);
		this.calculateBounds();
	}

	private function stranslate(item:ICanItem, dx:Float, dy:Float):Void {
		var mat:Matrix = item.transform.matrix;
		mat.translate(dx, dy);
		item.transform.matrix = mat;
	}

	public function scale(width:Float, height:Float):Void {
		var sx = width / this.bounds.width;
		var sy = height / this.bounds.height;
		for (item in this.items) {
			var mat = item.transform.matrix;
			mat.translate(-this.pivotV.x, -this.pivotV.y);
			mat.scale(sx, sy);
			mat.translate(this.pivotV.x, this.pivotV.y);
			item.transform.matrix = mat;
		}
		this.calculateBounds();
	}

	// perform rotation with matrix
	public function rotate(angle:Float):Void {
		var a = 0.0;
		for (i in 0...this.length) {
			var mat:Matrix = this.items[i].transform.matrix;
			mat.translate(-this.pivotV.x, -this.pivotV.y);
			if (i == 0)
				a = Math.atan2(mat.b, mat.a);
			mat.rotate(angle - a);
			mat.translate(this.pivotV.x, this.pivotV.y);
			this.items[i].transform.matrix = mat;
		}
		this.calculateBounds();
	}

	public function resize(x:Float, y:Float, width:Float, height:Float):Void {
		var px = x / this.bounds.x;
		var py = y / this.bounds.y;
		var sx = width / this.bounds.width;
		var sy = height / this.bounds.height;
		for (item in this.items) {
			item.x = x + (item.x - this.bounds.x) * px;
			item.y = y + (item.y - this.bounds.y) * py;
			item.width *= sx;
			item.height *= sy;
		}
		this.calculateBounds();
	}

	public function align(mode:String):Void {
		if (mode == "distr-h" || mode == "distr-v") {
			this.distribute(mode);
			return;
		}
		if (this.length == 1) {
			var w = cast(this.items[0].parent.parent, CanScene).canWidth;
			var h = cast(this.items[0].parent.parent, CanScene).canHeight;
			switch (mode) {
				case "align-l":
					this.stranslate(this.items[0], -this.bounds.x, 0);
				case "align-c":
					this.stranslate(this.items[0], (w - this.bounds.width) * 0.5 - this.bounds.x, 0);
				case "align-r":
					this.stranslate(this.items[0], w - this.bounds.width - this.bounds.x, 0);
				case "align-t":
					this.stranslate(this.items[0], 0, -this.bounds.y);
				case "align-m":
					this.stranslate(this.items[0], 0, (h - this.bounds.height) * 0.5 - this.bounds.y);
				case "align-b":
					this.stranslate(this.items[0], 0, h - this.bounds.height - this.bounds.y);
			}
			this.calculateBounds();
			return;
		}
		var b:Rectangle;
		for (item in this.items) {
			b = item.getBounds(item.parent);
			switch (mode) {
				case "align-l":
					this.stranslate(item, -b.x + this.bounds.x, 0);
				case "align-c":
					this.stranslate(item, this.bounds.x + this.bounds.width * 0.5 - b.x - b.width * 0.5, 0);
				case "align-r":
					this.stranslate(item, this.bounds.x + this.bounds.width - b.x - b.width, 0);
				case "align-t":
					this.stranslate(item, 0, -b.y + this.bounds.y);
				case "align-m":
					this.stranslate(item, 0, this.bounds.y + this.bounds.height * 0.5 - b.y - b.height * 0.5);
				case "align-b":
					this.stranslate(item, 0, this.bounds.y + this.bounds.height - b.y - b.height);
			}
		}
		this.calculateBounds();
	}

	public function distribute(mode:String):Void {
		var srtd = this.items.copy();
		var bnds = new Array<Rectangle>();
		if (mode == "distr-h") {
			ArraySort.sort(srtd, (l, r) -> l.x > r.x ? 1 : -1);
			var gap = this.bounds.width;
			var len = srtd.length;
			for (i in 0...len) {
				bnds[i] = srtd[i].getBounds(srtd[i].parent);
				gap -= bnds[i].width;
			}
			gap /= (len - 1);
			var x = 0.0;
			for (i in 0...len) {
				this.stranslate(srtd[i], -bnds[i].x + this.bounds.x + x + (gap * i), 0);
				x += bnds[i].width;
			}
		} else {
			ArraySort.sort(srtd, (l, r) -> l.y > r.y ? 1 : -1);
			var gap = this.bounds.height;
			var len = srtd.length;
			for (i in 0...len) {
				bnds[i] = srtd[i].getBounds(srtd[i].parent);
				gap -= bnds[i].height;
			}
			gap /= (len - 1);
			var y = 0.0;
			for (i in 0...len) {
				this.stranslate(srtd[i], 0, -bnds[i].y + this.bounds.y + y + (gap * i));
				y += bnds[i].height;
			}
		}
		this.calculateBounds();
	}

	public function resetTransform():Void {
		for (item in this.items) {
			var mat:Matrix = item.transform.matrix;
			var r = item.getBounds(item.parent);
			mat.a = mat.d = 1;
			mat.b = mat.c = 0;
			item.transform.matrix = mat;
			item.x = r.left + r.width * 0.5 - item.width * 0.5;
			item.y = r.top + r.height * 0.5 - item.height * 0.5;
		}
		this.calculateBounds();
	}
}
