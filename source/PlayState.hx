package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var shade:FlxSprite;
	var floor:Floor;
	var xrt:Xrt;
	var xrtd:Xrtdead;
	var timetext:FlxText;
	var timer:Float;
	var overlap:FlxSprite;
	var dietext:FlxText;

	override public function create()
	{
		super.create();

		FlxG.cameras.bgColor = 0xffffffff;

		floor = new Floor();
		add(floor);

		xrt = new Xrt();
		add(xrt);

		xrtd = new Xrtdead();
		xrtd.visible=false;
		add(xrtd);

		overlap = new FlxSprite();
		overlap.makeGraphic(640, 480, FlxColor.RED);
		add(overlap);
		overlap.alpha = 0.3;
		overlap.visible = false;

		dietext = new FlxText(0,100, 0, "You Died", 48);
		dietext.screenCenter(X);
		dietext.color = 0xff000000;
		add(dietext);
		dietext.visible = false;
	}

	override function destroy()
	{
		super.destroy();
		xrt.destroy();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (xrt.dead == true)
		{
			overlap.visible = true;
			dietext.visible = true;
		}

		if (FlxG.keys.justPressed.R)
		{
			overlap.visible = false;
			dietext.visible = false;
		}

		if (FlxG.keys.justPressed.G)
		{
			xrtd.visible = false;
			xrt.visible = true;
		}

		if (FlxG.keys.justPressed.F)
		{
			xrtd.visible = true;
			xrt.visible = false;
		}
	}
}
