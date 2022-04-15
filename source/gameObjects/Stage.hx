package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	public var curStep:Int = 0;
	
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;
	
	var jump1Array:Array<Int> = CoolUtil.numberArray(-2982, -3018);
	var jump2Array:Array<Int> = CoolUtil.numberArray( -1260, -1344);
	
	var bfJumpBrick:Array<Int> = CoolUtil.numberArray(-5604, -5736);
	var bfJumpGap1:Array<Int> = CoolUtil.numberArray(-3210, -3804);
	var bfJumpGap2:Array<Int> = CoolUtil.numberArray(-1234, -1908);
	var bfJumpPipe:Array<Int> = CoolUtil.numberArray(-700, -942);

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var enemy:FNFSprite;
	var enemies:FNFSprite;
	var enemies_shadow:FNFSprite;

	public var mParticles:FNFSprite;
	public var bfParticles:FNFSprite;

	var bgPlatform1:FNFSprite;
	var bgPlatform2:FNFSprite;

	var stars:FNFSprite;
	var stars2:FNFSprite;
	var coinsBack:FNFSprite;
	var coinsBack2:FNFSprite;
	var coinsFront:FNFSprite;
	var coinsFront2:FNFSprite;

	var starsPos:FlxPoint;
	var coinsBackPos:FlxPoint;
	var coinsFrontPos:FlxPoint;

	var waterBG:FNFSprite;
	var waterBG2:FNFSprite;
	var waterBGPos:FlxPoint;

	var cloudsBack:FNFSprite;
	var cloudsBack2:FNFSprite;
	var cloudsBackPos:FlxPoint;
	
	var cloudsFront:FNFSprite;
	var cloudsFront2:FNFSprite;
	var cloudsFrontPos:FlxPoint;
	
	var chaseBG:FNFSprite;
	public var luigi:FNFSprite;
	var chaseBGPos:FlxPoint;
	public var legs:FNFSprite;
	public var legsBF:FNFSprite;
	public var legsPrefix:String = '';
	public var madPrefix:String = '';
	var breakableObjects:FlxTypedGroup<FNFSprite>;
	
	public var mxDefPos:FlxPoint;
	public var mxPos:FlxPoint;
	public var mxTarget:FlxPoint;
	
	public var bfDefPos:FlxPoint;
	public var bfPos:FlxPoint;
	public var bfTarget:FlxPoint;
	
	var legsDefPos:FlxPoint;
	var legsPos:FlxPoint;
	var legsTarget:FlxPoint;
	
	var BFlegsDefPos:FlxPoint;
	var BFlegsPos:FlxPoint;
	var BFlegsTarget:FlxPoint;
	
	public var backgroundsArray:Map<String, Dynamic> = [];
	
	var pipeEnd:Bool = false;

	var minusBG:FNFSprite;
	public var bomb:FNFSprite;
	public var bomb2:FNFSprite;

	var stormClouds:FNFSprite;
	var stormClouds2:FNFSprite;
	var stormCloudsPos:FlxPoint;
	public var gf:FNFSprite;
	public var blasterBro:FNFSprite;
	public var hands:FNFSprite;
	
	var terrain:FNFSprite;
	var terrain2:FNFSprite;
	var terrainPos:FlxPoint;
	var bfY:Float = (12 * 6) + (11*6);
	var billY:Float = (12 * 6) + (11*6);

	var billDelay:Float = 0;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	var moveMult:Float = 1;
	public var platformPos1:Float;
	public var platformPos2:Float;

	public var enemyX:Float;
	public var enemyY:Float;
	
	var ogX:Float;
	var ogY:Float;

	public var enemyVelocity:Float;
	var enemyType:Int;
	var beatsUntilRespawn:Int = 12;
	var spawned:Bool = false;

	var fireballs:Array<FNFSprite> = [];
	var fireballCenterX:Float;
	var fireballCenterY:Float;
	var fireballAngle:Float;

	var mVelocityX:Float = 0;
	var mVelocityY:Float = 0;
	var mSwimX:Float = 128 * 6;
	var mSwimY:Float = 16 * 6;
	var mSwimPower:Float = 1.85;
	var mSwimGravity:Float = 0.5;
	var swimThres:Float = 12 * 6;

	var bopLeft:Bool;
	var bopCooldown:Float;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;
		
		breakableObjects = new FlxTypedGroup<FNFSprite>();
		
		starsPos = new FlxPoint();
		coinsBackPos = new FlxPoint();
		coinsFrontPos = new FlxPoint();
		waterBGPos = new FlxPoint();
		cloudsBackPos = new FlxPoint();
		cloudsFrontPos = new FlxPoint();
		stormCloudsPos = new FlxPoint();
		legsPos = new FlxPoint();
		legsDefPos = new FlxPoint();
		legsTarget = new FlxPoint();
		chaseBGPos = new FlxPoint(-956.95 * 6, 0);
		terrainPos = new FlxPoint(-160 * 2 * 6, 0);

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				default:
					curStage = 'overworld';
				case 'bricks-and-lifts':
					curStage = 'underground';
				case 'lethal-lava-lair':
					curStage = 'castle';
				case '2-player-game' | 'balls':
					curStage = 'sky';
				case 'deep-deep-voyage':
					curStage = 'water';
				case 'hop-hop-heights':
					curStage = 'athletic';
				case 'bullet-time':
					curStage = 'ice';
				case 'wrong-warp':
					curStage = 'minus';
				case 'green-screen':
					curStage = 'camera';
				case 'portal-power':
					curStage = 'test-chamber';
				case 'destruction-dance':
					curStage = 'wrecking-crew';
				case 'cross-console-clash':
					curStage = 'sonic';
				case 'first-level-:)':
					curStage = 'smm';
				case 'boo-blitz':
					curStage = 'ghost';
				case 'koopa-armada':
					curStage = 'airship';
				case 'game-over':
					curStage = 'pcport';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'pcport':
				PlayState.isChase = false;
				curStage = 'pcport';
				
				var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 4), Std.int(FlxG.height * 4), FlxColor.BLACK);
				blackScreen.visible = false;
				blackScreen.screenCenter();
				backgroundsArray['black'] = blackScreen;
				foreground.add(blackScreen);
				blackScreen.scrollFactor.set();
				
				var bg:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/goal'), false, 256, 240);
				bg.scrollFactor.set(1, 1);
				bg.antialiasing = false;
				bg.setGraphicSize(Std.int(bg.width * 6));
				bg.updateHitbox();
				backgroundsArray['bg'] = bg;
				add(bg);
				
				luigi = new FNFSprite(0, -1 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/luigi'), false, 160, 81);
				luigi.scrollFactor.set(1, 1);
				luigi.antialiasing = false;
				luigi.setGraphicSize(Std.int(luigi.width * 6));
				luigi.updateHitbox();
				luigi.visible = false;
				foreground.add(luigi);
				
				var popup:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/popup'), true, 160, 81);
				popup.animation.add('innocence', [0], 60);
				popup.animation.add('doesnt', [1], 60);
				popup.animation.add('get', [2], 60);
				popup.animation.add('you', [3], 60);
				popup.animation.add('far', [4], 60);
				popup.animation.play('innocence', true);
				popup.scrollFactor.set(1, 1);
				popup.antialiasing = false;
				popup.setGraphicSize(Std.int(popup.width * 6));
				popup.updateHitbox();
				popup.visible = false;
				backgroundsArray['popup'] = popup;
				foreground.add(popup);
				
				chaseBG = new FNFSprite(-956.95 * 6, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/loop'), false, 160, 81);
				chaseBG.scrollFactor.set(1, 1);
				chaseBG.antialiasing = false;
				chaseBG.setGraphicSize(Std.int(chaseBG.width * 6));
				chaseBG.updateHitbox();
				chaseBG.visible = false;
				add(chaseBG);
				
				var wall:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/hiddenwall'), false, 160, 81);
				wall.scrollFactor.set(1, 1);
				wall.antialiasing = false;
				wall.setGraphicSize(Std.int(wall.width * 6));
				wall.updateHitbox();
				wall.visible = false;
				backgroundsArray['wall'] = wall;
				
				//////////////////////////////////
				//////////OBJECTS MAKING//////////
				//////////////////////////////////
				
					var pipe2:FNFSprite = new FNFSprite(0, -16 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/pipe'), true, 117, 81);
					pipe2.animation.add('idle', [0], 15);
					pipe2.animation.add('break', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 20, false);
					pipe2.scrollFactor.set(1, 1);
					pipe2.antialiasing = false;
					pipe2.setGraphicSize(Std.int(pipe2.width * 6));
					pipe2.updateHitbox();
					pipe2.visible = false;
					pipe2.ID = 2;
					breakableObjects.add(pipe2);
					
					var solidbrick1:FNFSprite = new FNFSprite(0, 33 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/bricksolid'), true, 50, 81);
					solidbrick1.animation.add('idle', [0], 15);
					solidbrick1.animation.add('break', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, false);
					solidbrick1.scrollFactor.set(1, 1);
					solidbrick1.antialiasing = false;
					solidbrick1.setGraphicSize(Std.int(solidbrick1.width * 6));
					solidbrick1.updateHitbox();
					solidbrick1.visible = false;
					solidbrick1.ID = 3;
					breakableObjects.add(solidbrick1);
					
					var solidbrick2:FNFSprite = new FNFSprite(0, 33 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/bricksolid'), true, 50, 81);
					solidbrick2.animation.add('idle', [0], 15);
					solidbrick2.animation.add('break', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, false);
					solidbrick2.scrollFactor.set(1, 1);
					solidbrick2.antialiasing = false;
					solidbrick2.setGraphicSize(Std.int(solidbrick2.width * 6));
					solidbrick2.updateHitbox();
					solidbrick2.visible = false;
					solidbrick2.ID = 4;
					breakableObjects.add(solidbrick2);
					
					var solidbrick3:FNFSprite = new FNFSprite(0, 17 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/bricksolid'), true, 50, 81);
					solidbrick3.animation.add('idle', [0], 15);
					solidbrick3.animation.add('break', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, false);
					solidbrick3.scrollFactor.set(1, 1);
					solidbrick3.antialiasing = false;
					solidbrick3.setGraphicSize(Std.int(solidbrick3.width * 6));
					solidbrick3.updateHitbox();
					solidbrick3.visible = false;
					solidbrick3.ID = 5;
					breakableObjects.add(solidbrick3);
					
					var solidbrick4:FNFSprite = new FNFSprite(0, 33 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/bricksolid'), true, 50, 81);
					solidbrick4.animation.add('idle', [0], 15);
					solidbrick4.animation.add('break', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, false);
					solidbrick4.scrollFactor.set(1, 1);
					solidbrick4.antialiasing = false;
					solidbrick4.setGraphicSize(Std.int(solidbrick4.width * 6));
					solidbrick4.updateHitbox();
					solidbrick4.visible = false;
					solidbrick4.ID = 6;
					breakableObjects.add(solidbrick4);
					
					var solidbrick5:FNFSprite = new FNFSprite(0, 33 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/bricksolid'), true, 50, 81);
					solidbrick5.animation.add('idle', [0], 15);
					solidbrick5.animation.add('break', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, false);
					solidbrick5.scrollFactor.set(1, 1);
					solidbrick5.antialiasing = false;
					solidbrick5.setGraphicSize(Std.int(solidbrick5.width * 6));
					solidbrick5.updateHitbox();
					solidbrick5.visible = false;
					solidbrick5.ID = 7;
					breakableObjects.add(solidbrick5);
					
					var solidbrick6:FNFSprite = new FNFSprite(0, 17 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/bricksolid'), true, 50, 81);
					solidbrick6.animation.add('idle', [0], 15);
					solidbrick6.animation.add('break', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, false);
					solidbrick6.scrollFactor.set(1, 1);
					solidbrick6.antialiasing = false;
					solidbrick6.setGraphicSize(Std.int(solidbrick6.width * 6));
					solidbrick6.updateHitbox();
					solidbrick6.visible = false;
					solidbrick6.ID = 8;
					breakableObjects.add(solidbrick6);
					
					var emptyblock1:FNFSprite = new FNFSprite(0, -16 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/emptybrick'), true, 50, 81);
					emptyblock1.animation.add('idle', [0], 15);
					emptyblock1.animation.add('break', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, false);
					emptyblock1.scrollFactor.set(1, 1);
					emptyblock1.antialiasing = false;
					emptyblock1.setGraphicSize(Std.int(emptyblock1.width * 6));
					emptyblock1.updateHitbox();
					emptyblock1.visible = false;
					emptyblock1.ID = 9;
					breakableObjects.add(emptyblock1);
					
					var emptyblock2:FNFSprite = new FNFSprite(0, -16 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/emptybrick'), true, 50, 81);
					emptyblock2.animation.add('idle', [0], 15);
					emptyblock2.animation.add('break', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, false);
					emptyblock2.scrollFactor.set(1, 1);
					emptyblock2.antialiasing = false;
					emptyblock2.setGraphicSize(Std.int(emptyblock2.width * 6));
					emptyblock2.updateHitbox();
					emptyblock2.visible = false;
					emptyblock2.ID = 10;
					breakableObjects.add(emptyblock2);
					
					var emptyblock3:FNFSprite = new FNFSprite(0, -16 * 6).loadGraphic(Paths.image('backgrounds/' + curStage + '/emptybrick'), true, 50, 81);
					emptyblock3.animation.add('idle', [0], 15);
					emptyblock3.animation.add('break', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, false);
					emptyblock3.scrollFactor.set(1, 1);
					emptyblock3.antialiasing = false;
					emptyblock3.setGraphicSize(Std.int(emptyblock3.width * 6));
					emptyblock3.updateHitbox();
					emptyblock3.visible = false;
					emptyblock3.ID = 11;
					breakableObjects.add(emptyblock3);
				
				//////////////////////////////////
				//////////OBJECTS END/////////////
				//////////////////////////////////
				
				
				for (object in breakableObjects)
				{
					object.animation.play('idle', true);
				}
				
				add(breakableObjects);
				
				legs = new FNFSprite();
				legs.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/legs');
				legs.animation.addByPrefix('idle', 'legs', 60, true);
				legs.animation.addByPrefix('idle-mad', 'runmad', 35, true);
				legs.animation.addByPrefix('jump', 'legjump', 55, true);
				legs.animation.play('idle'+madPrefix);
				legs.setGraphicSize(Std.int(legs.width * 6));
				legs.updateHitbox();
				legs.scrollFactor.set(1, 1);
				legs.visible = false;
				add(legs);
				
				legsBF = new FNFSprite();
				legsBF.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bflegs');
				legsBF.animation.addByPrefix('runfire', 'runfire', 30, true);
				legsBF.animation.addByPrefix('jumpfire', 'jumpfire', 55, true);
				legsBF.animation.addByPrefix('runsmall', 'runsmall', 30, true);
				legsBF.animation.addByPrefix('jumpsmall', 'jumpsmall', 55, true);
				legsBF.animation.addByPrefix('run', 'run0', 30, true);
				legsBF.animation.addByPrefix('jump', 'jump0', 55, true);
				legsBF.animation.play('run'+legsPrefix);
				legsBF.setGraphicSize(Std.int(legsBF.width * 6));
				legsBF.updateHitbox();
				legsBF.scrollFactor.set(1, 1);
				legsBF.visible = false;
				add(legsBF);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf-pixel';

		switch (curStage)
		{
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, dad:Character, gf:Character, camPos:FlxPoint, songPlayer2):Void
	{
		switch (songPlayer2)
		{
			case 'mariofake':
				dad.x -= 1;
				dad.y -= 10;
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{

		gf.visible = false;
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			default:
				boyfriend.x += 91 * 6;
				boyfriend.y += 41 * 6;

				dad.x += 27 * 6;
				dad.y += 34 * 6;
			case 'pcport':
				boyfriend.x += 282;
				boyfriend.y += 270;
				
				dad.x += 726;
				dad.y += 258;
				
				boyfriend.y -= 24;
				boyfriend.x += 1;
		}

		if (boyfriend.curCharacter == 'luigi-player')
		{
			boyfriend.y -= 8 * 6;

			// pixel alignment
			boyfriend.x -= 3;
			boyfriend.y += 2;
		}

		if (boyfriend.curCharacter == 'bf-lakitu')
		{

			// pixel alignment
			boyfriend.x -= 3;
			boyfriend.y -= 2;
		}

		if (boyfriend.curCharacter == 'bf-captured')
		{
			boyfriend.y -= 2 * 6;

			// pixel alignment
			boyfriend.x += 2.995;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gfVar:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'overworld':
				if (beatsUntilRespawn > 0)
				{
					beatsUntilRespawn -= 1;
					if (beatsUntilRespawn <= 0)
					{
						beatsUntilRespawn = 0;
						spawned = true;
						enemy.visible = true;
					}
				}
			case 'minus':
				if (curBeat % 8 == 0 && !Init.trueSettings.get("Photosensitivity"))
				{
					minusBG.animation.play("glitch");
				}
		}
	}

	public function dance()
	{
		if (PlayState.curStage == 'airship')
		{
			if (bopCooldown <= 0)
			{
				var animName = (bopLeft) ? 'danceLeft' : 'danceRight';
				gf.animation.play(animName, true);
				hands.animation.play(animName, true);
				bopLeft = !bopLeft;
				bopCooldown = 0.05;

				blasterBro.animation.play('idle', true);
			}
		}
	}

	public function missAnim()
	{
		if (PlayState.curStage == 'airship')
		{
			gf.animation.play('miss', true);
			bopCooldown = 0.25;
		}
	}
	
	var jumped1:Bool = false;
	var jumped2:Bool = false;
	
	var jumpedBrick:Bool = false;
	var jumpedGap1:Bool = false;
	var jumpedGap2:Bool = false;
	var jumpedPipe:Bool = false;

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'pcport':
				PlayState.legFrame = legs.animation.curAnim.curFrame;
				PlayState.bfLegFrame = legsBF.animation.curAnim.curFrame;
				if (PlayState.isChase)
				{
					if (chaseBG.visible == false)
					{
						var flagPole:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/flagpole'), false, 160, 81);
						flagPole.scrollFactor.set(1, 1);
						flagPole.antialiasing = false;
						flagPole.setGraphicSize(Std.int(flagPole.width * 6));
						flagPole.updateHitbox();
						backgroundsArray['flagPole'] = flagPole;
						add(flagPole);
						
						var brickScroll:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/brickscroll'), false, 160, 81);
						brickScroll.scrollFactor.set(1, 1);
						brickScroll.antialiasing = false;
						brickScroll.setGraphicSize(Std.int(brickScroll.width * 6));
						brickScroll.updateHitbox();
						brickScroll.visible = false;
						backgroundsArray['brickScroll'] = brickScroll;
						add(brickScroll);
						
						legs.setPosition(dadOpponent.x - 126 - 58, dadOpponent.y - 88 + 2 - 48 - 13);
						legsBF.setPosition(boyfriend.x - 2.9 - (19 * 6), boyfriend.y - (20 * 6) + 2.9 - 6);
						
						legsPos = new FlxPoint(legs.x, legs.y);
						legsDefPos = new FlxPoint(legsPos.x, legsPos.y);
						legsTarget = new FlxPoint(legs.x - 126 - 58, legs.y - (40 * 6) + 3.4);
						
						BFlegsPos = new FlxPoint(legsBF.x, legsBF.y);
						BFlegsDefPos = new FlxPoint(BFlegsPos.x, BFlegsPos.y);
						BFlegsTarget = new FlxPoint(legsBF.x - 126 - 58, legsBF.y - (50 * 6) + 3.4);
						chaseBG.visible = true;
						
						for (object in breakableObjects.members)
						{
							object.visible = true;
						}
					}
					
					
					if (dadOpponent.curCharacter == 'mx' && dadOpponent.animation.curAnim.name == 'idle')
					{
						legs.visible = false;
					}else if (dadOpponent.curCharacter == 'mx' && dadOpponent.animation.curAnim.name != 'idle')
					{
						legs.visible = true;
					}
					
					if (boyfriend.curCharacter.startsWith('bf-chase') && boyfriend.animation.curAnim.name == 'idle')
					{
						legsBF.visible = false;
						boyfriend.offset.y = 0;
					}else if (boyfriend.curCharacter.startsWith('bf-chase') && boyfriend.animation.curAnim.name != 'idle')
					{
						legsBF.visible = true;
					}
					
					chaseBGPos.x += 1420 * elapsed * moveMult;
					if (chaseBGPos.x >= 0)
					{
						chaseBGPos.x = -956.95 * 6;
						
						if (backgroundsArray['brickScroll'].visible == false)
							backgroundsArray['brickScroll'].visible = true;
						
						if (backgroundsArray['flagPole'] != null)
							backgroundsArray['flagPole'].kill();
						if (curStep > 2317)
						{
							var endingPipe:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/endpipe'), false, 160, 81);
							endingPipe.scrollFactor.set(1, 1);
							endingPipe.antialiasing = false;
							endingPipe.setGraphicSize(Std.int(endingPipe.width * 6));
							endingPipe.updateHitbox();
							backgroundsArray['pipe'] = endingPipe;
							foreground.add(endingPipe);
							pipeEnd = true;
						}
						jumpedBrick = false;
						jumpedGap1 = false;
						jumpedGap2 = false;
						jumpedPipe = false;
						
						for (object in breakableObjects.members)
						{
							if (!pipeEnd)
								object.animation.play('idle', true);
						}
					}
					chaseBG.x = Std.int(chaseBGPos.x / 6) * 6;
					if (pipeEnd)
						backgroundsArray['pipe'].x = chaseBG.x;
					if (backgroundsArray['flagPole'] != null)
						backgroundsArray['flagPole'].x = chaseBG.x;
					backgroundsArray['brickScroll'].x = chaseBG.x;
					trace(chaseBG.x);
					
					if (!pipeEnd)
					{
						for (i in 0...bfJumpBrick.length)
						{
							if (chaseBG.x == bfJumpBrick[i] && !jumpedBrick)
							{
								jumpedBrick = true;
								legsBF.animation.play('jump'+legsPrefix, true);
								FlxTween.tween(bfPos, { y: bfTarget.y }, 0.5, {ease: FlxEase.sineOut, onComplete: jumpFallBF});
								FlxTween.tween(BFlegsPos, { y: BFlegsTarget.y }, 0.5, {ease: FlxEase.sineOut, onComplete: jumpFalllegsBF});
								if (boyfriend.animation.curAnim.name == 'idle')
									boyfriend.playAnim('jump', true);
								boyfriend.isJumping = true;
							}
						}
						
						for (i in 0...bfJumpGap1.length)
						{
							if (chaseBG.x == bfJumpGap1[i] && !jumpedGap1)
							{
								jumpedGap1 = true;
								legsBF.animation.play('jump'+legsPrefix, true);
								FlxTween.tween(bfPos, { y: (bfTarget.y + 15 * 6) }, 0.5, {ease: FlxEase.sineOut, onComplete: jumpFallBF});
								FlxTween.tween(BFlegsPos, { y: (BFlegsTarget.y + 15 * 6)}, 0.5, {ease: FlxEase.sineOut, onComplete: jumpFalllegsBF});
								if (boyfriend.animation.curAnim.name == 'idle')
									boyfriend.playAnim('jump', true);
								boyfriend.isJumping = true;
							}
						}
						
						for (i in 0...bfJumpGap2.length)
						{
							if (chaseBG.x == bfJumpGap2[i] && !jumpedGap2)
							{
								jumpedGap2 = true;
								legsBF.animation.play('jump'+legsPrefix, true);
								FlxTween.tween(bfPos, { y: (bfTarget.y + 25 * 6) }, 0.3, {ease: FlxEase.sineOut, onComplete: bfFallFast});
								FlxTween.tween(BFlegsPos, { y: (BFlegsTarget.y + 25 * 6)}, 0.3, {ease: FlxEase.sineOut, onComplete: legsFallFast});
								if (boyfriend.animation.curAnim.name == 'idle')
									boyfriend.playAnim('jump', true);
								boyfriend.isJumping = true;
							}
						}
						
						for (i in 0...bfJumpPipe.length)
						{
							if (chaseBG.x == bfJumpPipe[i] && !jumpedPipe)
							{
								jumpedPipe = true;
								legsBF.animation.play('jump'+legsPrefix, true);
								FlxTween.tween(bfPos, { y: (bfTarget.y + 15 * 6) }, 0.3, {ease: FlxEase.sineOut, onComplete: bfFallFast});
								FlxTween.tween(BFlegsPos, { y: (BFlegsTarget.y + 15 * 6) }, 0.3, {ease: FlxEase.sineOut, onComplete: legsFallFast});
								if (boyfriend.animation.curAnim.name == 'idle')
									boyfriend.playAnim('jump', true);
								boyfriend.isJumping = true;
							}
						}
						
						for (i in 0...jump1Array.length)
						{
							if (chaseBG.x == jump1Array[i] && !jumped1)
							{
								jumped2 = false;
								jumped1 = true;
								legs.animation.play('jump', true);
								FlxTween.tween(mxPos, { y: mxTarget.y }, 0.4, {ease: FlxEase.sineOut, onComplete: jumpFall});
								FlxTween.tween(legsPos , { y: legsTarget.y }, 0.4, {ease: FlxEase.sineOut, onComplete: jumpFalllegs});
								if (dadOpponent.animation.curAnim.name == 'idle')
									dadOpponent.playAnim('jump', true);
								dadOpponent.isJumping = true;
							}
						}
						
						for (i in 0...jump2Array.length)
						{
							if (chaseBG.x == jump2Array[i] && !jumped2)
							{
								jumped1 = false;
								jumped2 = true;
								legs.animation.play('jump', true);
								FlxTween.tween(mxPos, { y: mxTarget.y }, 0.4, {ease: FlxEase.sineOut, onComplete: jumpFall});
								FlxTween.tween(legsPos , { y: legsTarget.y }, 0.4, {ease: FlxEase.sineOut, onComplete: jumpFalllegs});
								if (dadOpponent.animation.curAnim.name == 'idle')
									dadOpponent.playAnim('jump', true);
								dadOpponent.isJumping = true;
							}
						}
					}
					
					legsBF.alpha = boyfriend.alpha;
					
					for (object in breakableObjects.members)
					{
						var offset:Float = 0;
						
						switch (object.ID)
						{
							case 1:
								offset = 683.05;
							case 2:
								offset = 99;
							case 3:
								offset = 926;
							case 4 | 5:
								offset = 910;
							case 6:
								offset = 830;
							case 8 | 7:
								offset = 846;
							case 9:
								offset = 239;
							case 10:
								offset = 207;
							case 11:
								offset = 174;
						}
						
						var hitboxOfs:Float = 0;
						
						switch (object.ID)
						{
							case 1 | 2:
								hitboxOfs = 72;
							case 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11:
								hitboxOfs = 40;
						}
						
						object.x = chaseBG.x + (offset * 6);
						
						if (object.x >= (dadOpponent.x - hitboxOfs * 6) && !pipeEnd)
						{
							if (object.animation.curAnim.name != 'break')
								object.animation.play('break', true);
						}
					}
					
					boyfriend.y = Std.int(bfPos.y / 6) * 6 + 3.5;
					legsBF.y = Std.int(boyfriend.y - (bfDefPos.y - BFlegsDefPos.y));
					
					dadOpponent.y = Std.int(mxPos.y / 6) * 6;
					dadOpponent.y += 3.4;
					legs.y = Std.int(legsPos.y / 6) * 6;
					legs.y += 1.2;
				} else if (pipeEnd)
				{
					legsBF.visible = false;
					boyfriend.x -= (22 * 6) * elapsed * moveMult;
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}
	
	public function switchScene(isWall:Bool = true):Void
	{
		if (isWall)
		{
			PlayState.isChase = false;
			legs.visible = false;
			legsBF.visible = false;
			backgroundsArray['bg'].visible = false;
			chaseBG.visible = false;
			backgroundsArray['wall'].visible = true;
		}
		else
		{
			legs.visible = true;
			legsBF.visible = true;
			chaseBG.visible = true;
			chaseBG.x = -956.95 * 6;
			chaseBGPos.x = -956.95 * 6;
			backgroundsArray['wall'].visible = false;
			PlayState.isChase = true;
		}
	}
	
	function jumpFall(tween) //does this when mx reaches the top height to lower him back to the ground
	{
		FlxTween.tween(mxPos, { y: mxDefPos.y }, 0.4, {ease: FlxEase.sineIn, onComplete: 
			function(tween:FlxTween)
			{
				PlayState.dadOpponent.isJumping = false;
				if (PlayState.dadOpponent.animation.curAnim.name == 'jump')
					PlayState.dadOpponent.dance();
			}
		});
	}
	
	function jumpFalllegs(tween) //does this when mx reaches the top height to lower him back to the ground
	{
		FlxTween.tween(legsPos, { y: legsDefPos.y}, 0.4, {ease: FlxEase.sineIn, onComplete: 
			function(tween:FlxTween)
			{
				legs.animation.play('idle'+madPrefix, true);
			}
		});
	}
	
	//BRICK
	
	function jumpFallBF(tween) //does this when bf reaches the top height to lower him back to the ground
	{
		FlxTween.tween(bfPos, { y: bfDefPos.y }, 0.5, {ease: FlxEase.sineIn, onComplete: 
			function(tween:FlxTween)
			{
				PlayState.boyfriend.isJumping = false;
				if (PlayState.boyfriend.animation.curAnim.name == 'jump')
					PlayState.boyfriend.dance();
			}
		});
	}
	
	function jumpFalllegsBF(tween) //does this when bf reaches the top height to lower him back to the ground
	{
		FlxTween.tween(BFlegsPos, { y: BFlegsDefPos.y}, 0.5, {ease: FlxEase.sineIn, onComplete: 
			function(tween:FlxTween)
			{
				legsBF.animation.play('run'+legsPrefix, true, false, PlayState.bfLegFrame);
			}
		});
	}
	
	//GAP 2
	
	function bfFallFast(tween) //does this when bf reaches the top height to lower him back to the ground
	{
		FlxTween.tween(bfPos, { y: bfDefPos.y }, 0.3, {ease: FlxEase.sineIn, onComplete: 
			function(tween:FlxTween)
			{
				PlayState.boyfriend.isJumping = false;
				if (PlayState.boyfriend.animation.curAnim.name == 'jump')
					PlayState.boyfriend.dance();
			}
		});
	}
	
	function legsFallFast(tween) //does this when bf reaches the top height to lower him back to the ground
	{
		FlxTween.tween(BFlegsPos, { y: BFlegsDefPos.y}, 0.3, {ease: FlxEase.sineIn, onComplete: 
			function(tween:FlxTween)
			{
				legsBF.animation.play('run'+legsPrefix, true, false, PlayState.bfLegFrame);
			}
		});
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
