package gameObjects.userInterface;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.CoolUtil;
import meta.InfoHud;
import meta.data.Conductor;
import meta.data.Timings;
import meta.state.PlayState;

using StringTools;

class Mari0HUD extends FlxTypedGroup<FlxBasic>
{
	// set up variables and stuff here
	var infoBar:FlxText; // small side bar like kade engine that tells you engine info
	var scoreBar:FlxText;
	var accuracyText:FlxText;
	var accuracyText2:FlxText;

	var scoreLast:Float = -1;
	var scoreDisplay:String;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var SONG = PlayState.SONG;
	public var ratingIcon:FlxSprite;
	public var flagIcon:FlxSprite;
	private var stupidHealth:Float = 0;

	var curBeat = 0;

	// eep
	public function new()
	{
		// call the initializations and stuffs
		super();

		// fnf mods
		var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop';

		// le healthbar setup
		var barY = FlxG.height - (7 * 6);
		if (Init.trueSettings.get('Downscroll'))
			barY = 3 * 6;
		
		var UIBox:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('UI/default/mari0/bg'));
		UIBox.setGraphicSize(Std.int(UIBox.width * 6));
		UIBox.updateHitbox();
		UIBox.scrollFactor.set();
		UIBox.antialiasing = false;
		add(UIBox);

		if (Init.trueSettings.get('Downscroll'))
			UIBox.flipY = true;

		healthBarBG = new FlxSprite(0,
			barY).loadGraphic(Paths.image(ForeverTools.returnSkinAsset('healthBar', PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = false;
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8));
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		healthBar.visible = false;
		// healthBar
		add(healthBar);

		scoreBar = new FlxText(0, barY, 0, "00000000");
		scoreBar.autoSize = false;
		scoreBar.borderSize = 0;
		scoreBar.setFormat(Paths.font("smb1.ttf"), 8, FlxColor.WHITE, LEFT);
		scoreBar.setGraphicSize(Std.int(scoreBar.width * 6));
		scoreBar.scrollFactor.set();
		scoreBar.antialiasing = false;
		add(scoreBar);

		accuracyText = new FlxText(0, barY, 0, "000000.00%");
		accuracyText.autoSize = false;
		accuracyText.borderSize = 0;
		accuracyText.setFormat(Paths.font("smb1.ttf"), 8, FlxColor.WHITE, LEFT);
		accuracyText.setGraphicSize(Std.int(accuracyText.width * 6));
		accuracyText.scrollFactor.set();
		accuracyText.antialiasing = false;
		add(accuracyText);

		accuracyText2 = new FlxText(0, barY + (1 * 6) + 2, 0, "000000.00%");
		accuracyText2.autoSize = false;
		accuracyText2.borderSize = 0;
		accuracyText2.setFormat(Paths.font("pixel_smaller.ttf"), 5, FlxColor.WHITE, LEFT);
		accuracyText2.setGraphicSize(Std.int(accuracyText2.width * 6));
		accuracyText2.scrollFactor.set();
		accuracyText2.antialiasing = false;
		add(accuracyText2);

		ratingIcon = new FlxSprite(0, 
			barY + (1 * 6)).loadGraphic(Paths.image("UI/default/mari0/rankings"), true, 8, 8);
		ratingIcon.animation.add("icon", [0, 1, 2, 3, 4, 5, 6, 7], 0, false);
		ratingIcon.animation.frameIndex = 0;
		
		ratingIcon.setGraphicSize(Std.int(ratingIcon.width * 6));
		ratingIcon.antialiasing = false;
		add(ratingIcon);

		flagIcon = new FlxSprite(0, barY + (1 * 6)).loadGraphic(Paths.image("UI/default/mari0/flags"), true, 8, 8);
		flagIcon.animation.add("icon", [0, 1, 2], 0, false);
		flagIcon.animation.frameIndex = 1;

		flagIcon.setGraphicSize(Std.int(flagIcon.width * 6));
		flagIcon.antialiasing = false;
		add(flagIcon);

		updateScoreText();

		// small info bar, kinda like the KE watermark
		// based on scoretxt which I will set up as well
		var infoDisplay:String = CoolUtil.dashToSpace(PlayState.SONG.song) + ' - ' + CoolUtil.difficultyFromNumber(PlayState.storyDifficulty);
		var engineDisplay:String = "Forever Engine BETA v" + Main.gameVersion;
		var engineBar:FlxText = new FlxText(0, FlxG.height - 30, 0, engineDisplay, 16);
		engineBar.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		engineBar.updateHitbox();
		engineBar.x = FlxG.width - engineBar.width - 5;
		engineBar.scrollFactor.set();
		engineBar.visible = false;
		add(engineBar);

		infoBar = new FlxText(5, FlxG.height - 30, 0, infoDisplay, 20);
		infoBar.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoBar.scrollFactor.set();
		infoBar.visible = false;
		add(infoBar);
	}

	public function flicker(object:FlxBasic)
	{
		if (object.visible && FlxG.random.bool(3))
		{
			object.visible = false;
		}
		else
		{
			object.visible = true;
		}
	}

	override public function update(elapsed:Float)
	{
		// pain, this is like the 7th attempt
		healthBar.percent = (PlayState.health * 50);

		var isMinus = SONG.song == 'Wrong-Warp';
		if (isMinus && !Init.trueSettings.get("Photosensitivity") && Std.int(Sys.time() * 1000) % 12 == 0)
		{
			flicker(scoreBar);
			flicker(accuracyText);
			flicker(accuracyText2);
			flicker(ratingIcon);
		}
	}

	private final divider:String = ' - ';

	public function updateScoreText()
	{
		var importSongScore = PlayState.songScore;
		var importPlayStateCombo = PlayState.combo;
		var importMisses = PlayState.misses;
		scoreBar.text = Std.string(importSongScore);

		///
		var accuracyString = Std.string(Math.floor(Timings.getAccuracy() * 100) / 100);
		var stringSplit = accuracyString.split(".");
		switch (stringSplit[0].length)
		{
			case 1:
				stringSplit[0] = "00" + stringSplit[0];
			case 2:
				stringSplit[0] = "0" + stringSplit[0];
		}
		if (stringSplit[1].length == 1)
			stringSplit[1] = "0" + stringSplit[1];
		if (stringSplit[1] == null)
			stringSplit[1] = "00";
		accuracyText.text = stringSplit[0];
		accuracyText2.text = "." + stringSplit[1] + '%';
		///

		var isNegative:Bool = false;
		if (scoreBar.text.charAt(0) == "-") 
		{
			scoreBar.color = 0x822E24;
			scoreBar.text = scoreBar.text.substr(1);
		}
		else
		{
			scoreBar.color = 0xFFFFFF;
		}

		// lol i'm lazy and don't want to use math for this
		switch (scoreBar.text.length)
		{
			case 1:
				scoreBar.text = "00000" + scoreBar.text;
			case 2:
				scoreBar.text = "0000" + scoreBar.text;
			case 3:
				scoreBar.text = "000" + scoreBar.text;
			case 4:
				scoreBar.text = "00" + scoreBar.text;
			case 5:
				scoreBar.text = "0" + scoreBar.text;
		}

		// testing purposes
		var displayAccuracy:Bool = Init.trueSettings.get('Display Accuracy');
		if (displayAccuracy)
		{
			// scoreBar.text += divider + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%' + Timings.comboDisplay;
			// scoreBar.text += divider + 'Combo Breaks: ' + Std.string(PlayState.misses);
			// scoreBar.text += divider + 'Rank: ' + Std.string(Timings.returnScoreRating().toUpperCase());
		}

		scoreBar.x = 20 * 6;
		accuracyText.x = FlxG.width - (18 * 6);
		accuracyText2.x = accuracyText.x + (24 * 6);
		ratingIcon.x = FlxG.width - (47 * 6);
		flagIcon.x = ratingIcon.x - (8 * 6);

		ratingIcon.animation.frameIndex = Timings.ratingIntFinal;
		flagIcon.animation.frameIndex = Timings.comboDisplay;

		// update playstate
		PlayState.detailsSub = scoreBar.text;
		PlayState.updateRPC(false);
	}

	public function beatHit()
	{
		
	}
}
