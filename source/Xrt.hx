package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.tweens.FlxTween;
import away3d.entities.Mesh;
import away3d.events.Asset3DEvent;
import away3d.library.assets.Asset3DType;
import away3d.lights.DirectionalLight;
import away3d.loaders.Loader3D;
import away3d.loaders.misc.AssetLoaderContext;
import away3d.loaders.parsers.OBJParser;
import away3d.materials.TextureMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.utils.Cast;
import flx3D.FlxView3D;
import openfl.utils.Assets;
import flixel.FlxG;
import flixel.FlxGame;

class Xrt extends FlxView3D
{
	// Mesh
	public var meshs:Array<Mesh> = [];
	var material:TextureMaterial;

	// Lighting
	var light:DirectionalLight;
	var lightPicker:StaticLightPicker;

	// Loading
	private var _loader:Loader3D;
	private var assetLoaderContext:AssetLoaderContext = new AssetLoaderContext();

	public var anglee:Int;

	var stepSound:FlxSound;
	
	public var dead:Bool = false;

	var jumpspeed:Float;

	public function new(x:Float = 0, y:Float = 0, width:Int = -1, height:Int = -1)
	{
		super(x, y, width, height);

		antialiasing = true;

		light = new DirectionalLight();
		light.ambient = 0.5;
		light.z -= 10;

		view.scene.addChild(light);

		lightPicker = new StaticLightPicker([light]);

		material = new TextureMaterial(Cast.bitmapTexture("assets/xrt.png"));
		material.lightPicker = lightPicker;

		var __flixelModel = Assets.getBytes("assets/xrt.obj");
		assetLoaderContext.mapUrlToData("xrt.mtl", Assets.getBytes("assets/xrt.mtl"));

		_loader = new Loader3D();
		_loader.loadData(__flixelModel, assetLoaderContext, null, new OBJParser());
		_loader.addEventListener(Asset3DEvent.ASSET_COMPLETE, onAssetDone);
		view.scene.addChild(_loader);

		stepSound = FlxG.sound.load("assets/step.wav");

		anglee = -90;
	}

	public function onAssetDone(event:Asset3DEvent)
	{
		if (event.asset.assetType == Asset3DType.MESH)
		{
			var mesh:Mesh = cast(event.asset, Mesh);
			mesh.rotationX = -90;
			//mesh.rotationY = 90;
			mesh.rotationZ = -90;
			mesh.y=-150;
			mesh.scale(350);

			mesh.material = material;

			meshs.push(mesh);
		}
	}


	override function destroy()
	{
		super.destroy();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (mesh in meshs)
		{
			if (mesh != null)
			{
				if (FlxG.keys.justPressed.R)
				{
					dead = false;
					mesh.rotationX = -90;
					mesh.rotationZ = -90;
					mesh.scaleX = 350;
				}

				if (Reg.floory >= 30000 && dead == false)
				{
					dead = true;
					//FlxTween.tween(mesh, {rotationZ: -180}, 0.3);
					mesh.scaleX = 70;
					FlxG.sound.load("assets/die.ogg").play();
				}

				if (dead == false)
				{
					var up:Bool = false;
					var down:Bool = false;
					var left:Bool = false;
					var right:Bool = false;

					#if FLX_KEYBOARD
					up = FlxG.keys.anyPressed([UP, W]);
					down = FlxG.keys.anyPressed([DOWN, S]);
					left = FlxG.keys.anyPressed([LEFT, A]);
					right = FlxG.keys.anyPressed([RIGHT, D]);
					#end

					if (up || down || left || right)
					{
						if (up)
						{
							anglee = 90;
							facing = UP;
							if (left)
							{
								anglee+=45;
							}
							if (right)
							{
								anglee-=45;
							}
						}
						else if (down)
						{
							anglee= -90;
							facing = DOWN;
							if (left)
							{
								anglee-=45;
							}
							if (right)
							{
								anglee+=45;
							}
						}
						else if (left)
						{
							anglee= 180;
							facing = LEFT;
						}
						else if (right)
						{
							anglee= 0;
							facing = RIGHT;
						}

						if (Reg.fall == false)
						{
							stepSound.play();
						}
					}
					FlxTween.tween(mesh, {rotationX: anglee}, 0.05);
				}
			}
		}
	}
}

