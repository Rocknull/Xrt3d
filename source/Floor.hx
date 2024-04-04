package;

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

class Floor extends FlxView3D
{
	// Mesh
	var meshs:Array<Mesh> = [];
	var material:TextureMaterial;

	// Lighting
	var light:DirectionalLight;
	var lightPicker:StaticLightPicker;

	// Loading
	private var _loader:Loader3D;
	private var assetLoaderContext:AssetLoaderContext = new AssetLoaderContext();

	var fallspeed:Float = 0;
	var fallnum:Int =0;

	var fall:Bool=false;

	public function new(x:Float = 0, y:Float = 0, width:Int = -1, height:Int = -1)
	{
		super(x, y, width, height);

		antialiasing = true;

		light = new DirectionalLight();
		light.ambient = 0.5;
		light.z -= 10;

		view.scene.addChild(light);

		lightPicker = new StaticLightPicker([light]);

		material = new TextureMaterial(Cast.bitmapTexture("assets/gay.png"));
		material.lightPicker = lightPicker;

		var __flixelModel = Assets.getBytes("assets/floor.obj");
		assetLoaderContext.mapUrlToData("floor.mtl", Assets.getBytes("assets/floor.mtl"));

		_loader = new Loader3D();
		_loader.loadData(__flixelModel, assetLoaderContext, null, new OBJParser());
		_loader.addEventListener(Asset3DEvent.ASSET_COMPLETE, onAssetDone);
		view.scene.addChild(_loader);
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
				if (FlxG.keys.justPressed.T)
				{
					trace(Std.string(mesh.x) + " " + Std.string(mesh.y) + " " + Std.string(mesh.z));
				}

				if (FlxG.keys.justPressed.R)
				{
					mesh.x=0;
					mesh.y=-150;
					mesh.z=0;

					fall=false;
					fallspeed=0;
					fallnum=0;
				}

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

				Reg.floory = mesh.y;
				Reg.fall = fall;

				if ((mesh.x >= 750 || mesh.x <= -750) || (mesh.z >= 750 || mesh.z <= -750) && mesh.y == -150)
				{
					fall=true;
				}

				if (fall)
				{
					fallnum+=1;
					fallspeed=fallspeed+fallnum;
					mesh.y+=fallspeed/4;
				}

				if ()

				if (up || down || left || right)
					{
						if (up)
						{
							if (left)
							{
								mesh.z-=Math.sqrt(50);
								mesh.x+=Math.sqrt(50);
							}
							else if (right)
							{
								mesh.z-=Math.sqrt(50);
								mesh.x-=Math.sqrt(50);
							}
							else
							{
								mesh.z-=10;
							}
						}
						else if (down)
						{
							if (left)
							{
								mesh.z+=Math.sqrt(50);
								mesh.x+=Math.sqrt(50);
							}
							else if (right)
							{
								mesh.z+=Math.sqrt(50);
								mesh.x-=Math.sqrt(50);
							}
							else
							{
								mesh.z+=10;
							}
						}
						else if (left)
						{
							mesh.x+=10;
						}
						else if (right)
						{
							mesh.x-=10;
						}
					}
				}
				
			}
		}
	}