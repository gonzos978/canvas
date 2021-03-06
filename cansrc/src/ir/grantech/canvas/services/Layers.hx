package ir.grantech.canvas.services;

import feathers.data.ArrayCollection;
import haxe.Timer;
import ir.grantech.canvas.drawables.CanShape;
import ir.grantech.canvas.drawables.CanSlicedBitmap;
import ir.grantech.canvas.drawables.CanText;
import ir.grantech.canvas.drawables.ICanItem;
import ir.grantech.canvas.services.Commands.*;
import ir.grantech.canvas.services.Libs.LibItem;
import ir.grantech.canvas.services.Tools.Tool.*;
import ir.grantech.canvas.themes.CanTheme;
import lime.math.RGB;
import openfl.display.BlendMode;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.text.TextFieldType;
import openfl.text.TextFormatAlign;

class Layers extends ArrayCollection<Layer> {
	/**
	 * Constructor.
	 */
	public function new() {
		super();
		this.sortCompareFunction = this.orderFunction;
	}

	/**
	 * Method to add layer with it's object.
	 */
	override public function add(item:Layer):Void {
		this.addAt(item, 0);
		for (i in 0...this.length)
			this.get(i).setProperty(ORDER, i);
	}

	/**
	 * Method to remove layer with it's index.
	 */
	override public function removeAt(index:Int):Layer {
		var item = this.removeAt(index);
		for (i in 0...this.length)
			this.get(i).setProperty(ORDER, i);
		return item;
	}

	private function getItemIndex(item:Layer):Int {
		return -1;
	}

	public function changeOrder(index:Int, direction:Int):Void {
		if (index + direction < 0 || index + direction > length - 1)
			return;
		var oldLayer = this.get(index);
		var newLayer = this.get(index + direction);

		var tmp:Int = oldLayer.getInt(ORDER);
		oldLayer.setProperty(ORDER, newLayer.getInt(ORDER));
		newLayer.setProperty(ORDER, tmp);

		this.refresh();
	}

	private function orderFunction(left:Layer, right:Layer):Int {
		return left.getInt(ORDER) - right.getInt(ORDER);
	}
}

class Layer {
	public var item(default, default):ICanItem;
	public var pivot(default, default):Point = new Point(0.5, 0.5);

	private var _props:Map<String, Dynamic>;
	private var _invalidationFlags:Map<String, Bool> = new Map();

	public function new(type:String, fillColor:RGB, fillAlpha:Float, borderSize:Float, borderColor:RGB, borderAlpha:RGB, bounds:Array<Float>,
			cornerRadius:Float, ?source:Dynamic) {
		this._invalidationFlags = new Map<String, Bool>();
		this._props = new Map<String, Dynamic>();
		this.setProperty(ID, Math.floor(Timer.stamp() * 100));
		this.setProperty(TYPE, type);
		this.setProperty(NAME, this.getString(TYPE) + " " + this.getInt(ID));
		this.setProperty(BOUNDS, bounds);

		this.setProperty(ENABLE, true);
		this.setProperty(VISIBLE, true);
		this.setProperty(ALPHA, 1.0);
		this.setProperty(BLEND_MODE, BlendMode.NORMAL);

		this.setProperty(FILL_COLOR, fillColor);
		this.setProperty(FILL_ALPHA, fillAlpha);
		this.setProperty(BORDER_ENABLE, true);
		this.setProperty(BORDER_SIZE, borderSize);
		this.setProperty(BORDER_COLOR, borderColor);
		this.setProperty(BORDER_ALPHA, borderAlpha);
		this.setProperty(CORNER_RADIUS, cornerRadius);

		this.item = this.instantiateItem(bounds, source);
		this.item.layer = this;
	}

	private function instantiateItem(bounds:Array<Float>, source:Dynamic):ICanItem {
		var ret:ICanItem = null;
		if (this.getString(TYPE) == TYPE_RECT || this.getString(TYPE) == TYPE_ELLIPSE) {
			this.setProperty(FILL_ENABLE, true);
			this.setProperty(CORNER_RADIUS, 0);
			var sh = new CanShape(this);
			sh.x = bounds[0];
			sh.y = bounds[1];
			ret = sh;
		} else if (this.getString(TYPE) == TYPE_TEXT) {
			this.setProperty(FILL_ENABLE, false);
			this.setProperty(TEXT_ALIGN, TextFormatAlign.JUSTIFY);
			this.setProperty(TEXT_AUTOSIZE, 1);
			this.setProperty(TEXT_COLOR, 0xFF);
			this.setProperty(TEXT_FONT, "IRANSans Light");
			this.setProperty(TEXT_LETTERPACE, 0);
			this.setProperty(TEXT_LINESPACE, 0);
			this.setProperty(TEXT_SIZE, 10 * CanTheme.DPI);
			var txt = new CanText(this);
			txt.x = bounds[0];
			txt.y = bounds[1];
			txt.width = bounds[2];
			txt.height = bounds[3];
			txt.text = "Lorem Ipsum ...";
			txt.embedFonts = true;
			txt.wordWrap = txt.multiline = true;
			txt.type = TextFieldType.INPUT;
			ret = txt;
		} else if (this.getString(TYPE) == TYPE_BITMAP) {
			this.setProperty(FILL_ENABLE, true);
			this.setProperty(BORDER_ENABLE, false);
			this.setProperty(SOURCE, source);

			var bmp = new CanSlicedBitmap(this);
			bmp.x = bounds[0];
			bmp.y = bounds[1];
			// bmp.width = bounds[2];
			// bmp.height = bounds[3];
			var libsReference = Libs.instance.find(source);
			if (libsReference.source == null)
				libsReference.addEventListener(Event.CHANGE, this.libsReference_changeHandler);
			else
				this.setProperty(DATA, libsReference.source);
			ret = bmp;
		}
		return ret;
	}

	private function libsReference_changeHandler(event:Event):Void {
		var libsReference = cast(event.currentTarget, LibItem);
		libsReference.removeEventListener(Event.CHANGE, this.libsReference_changeHandler);
		this.setProperty(DATA, libsReference.source);
	}

	public function getString(key:String):String {
		return cast(this.getProperty(key), String);
	}

	public function getInt(key:String):Int {
		return this._props.exists(key) ? cast(this.getProperty(key), Int) : 0;
	}

	public function getFloat(key:String):Float {
		return cast(this.getProperty(key), Float);
	}

	public function getBool(key:String):Bool {
		return cast(this.getProperty(key), Bool);
	}

	public function getUInt(key:String):UInt {
		return cast(this.getProperty(key), UInt);
	}

	public function getProperty(key:String):Dynamic {
		return this._props[key];
	}

	public function getProperties():Map<String, Dynamic> {
		var m = this.item.transform.matrix;
		this.setProperty("mat", [m.a, m.b, m.c, m.d, m.tx, m.ty]);
		return this._props;
	}

	public function setProperty(key:String, value:Dynamic):Void {
		if (this._props.exists(key) && this._props[key] == value)
			return;
		this._props[key] = value;
		this.setInvalid(key);
	}

	/**
		Sets an invalidation flag. This will not add the component to the
		validation queue. It only sets the flag. A subclass might use
		this function during `draw()` to manipulate the flags that
		its superclass sees.

		@see `Layer.setInvalid()`
	**/
	public function setInvalid(flag:String):Void {
		if (this._invalidationFlags.exists(flag))
			return;
		this._invalidationFlags.set(flag, true);
	}

	/**
		Indicates whether the control is pending validation or not. By default,
		returns `true` if any invalidation flag has been set. If you pass in a
		specific flag, returns `true` only if that flag has been set (others may
		be set too, but it checks the specific flag only. If all flags have been
		marked as invalid, always returns `true`.

		The following example invalidates a component:

		```hx
		component.setInvalid();
		trace(component.isInvalid()); // true
		```
	**/
	public function isInvalid(flag:String) {
		return this._invalidationFlags.exists(flag);
	}

	/**
		Immediately validates the display object, if it is invalid. The
		validation system exists to postpone updating a display object after
		properties are changed until until the last possible moment the display
		object is rendered. This allows multiple properties to be changed at a
		time without requiring a full update every time.
	**/
	@:access(ir.grantech.canvas.drawables.ICanItem)
	public function valiadateAll() {
		var needsDraw = false;
		var needsFormat = false;
		var flags = this._invalidationFlags.keys();
		for (flag in flags) {
			if (flag == ALPHA)
				this.item.alpha = this.getFloat(flag);
			if (flag == VISIBLE)
				this.item.visible = this.getBool(flag);
			if (flag == BLEND_MODE)
				this.item.blendMode = cast(this.getProperty(flag), BlendMode);
			if (flag == FILL_ENABLE || flag == FILL_COLOR || flag == FILL_ALPHA || flag == BORDER_ENABLE || flag == BORDER_COLOR || flag == BORDER_ALPHA
				|| flag == BORDER_SIZE || flag == CORNER_RADIUS || flag == DATA)
				needsDraw = true;
			if (flag == TEXT_ALIGN || flag == TEXT_COLOR || flag == TEXT_FONT || flag == TEXT_LETTERPACE || flag == TEXT_LINESPACE || flag == TEXT_SIZE)
				needsFormat = true;
		}

		if (needsDraw)
			this.item.draw();
		if (needsFormat)
			this.item.format();

		this.item.update();
		this._invalidationFlags.clear();
	}
}
