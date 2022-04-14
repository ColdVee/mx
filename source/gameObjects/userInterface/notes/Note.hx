package gameObjects.userInterface.notes;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gameObjects.userInterface.notes.*;
import gameObjects.userInterface.notes.Strumline.UIStaticArrow;
import meta.*;
import meta.data.*;
import meta.data.Section.SwagSection;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

class Note extends FNFSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var noteAlt:Float = 0;
	public var noteType:Float = 0;
	public var noteString:String = "";

	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	// only useful for charting stuffs
	public var chartSustain:FlxSprite = null;
	public var rawNoteData:Int;

	// not set initially
	public var noteQuant:Int = -1;
	public var noteVisualOffset:Float = 0;
	public var noteSpeed:Float = 0;
	public var noteDirection:Float = 0;

	public static var swagWidth:Float = 160 * 0.7;

	public function new(strumTime:Float, noteData:Int, noteAlt:Float, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super(x, y);

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		// oh okay I know why this exists now
		y -= 2000;

		this.strumTime = strumTime;
		this.noteData = noteData;
		this.noteAlt = noteAlt;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			if (strumTime > Conductor.songPosition - (Timings.msThreshold) && strumTime < Conductor.songPosition + (Timings.msThreshold))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - (Timings.msThreshold) && !wasGoodHit)
				tooLate = true;
		}
		else // make sure the note can't be hit if it's the dad's I guess
			canBeHit = false;

		if (tooLate)
			alpha -= 0.05;
	}

	/**
		Note creation scripts

		these are for all your custom note needs
	**/
	public function changeSkin()
	{
		var skin = 'shroom';
		if (noteType == 2)
		{
			skin = 'flower';
		}
		if (noteType == 3)
		{
			skin = 'poison';
		}
		if (noteType == 5)
		{
			skin = 'flower';
		}

		animation.remove('greenScroll');
		animation.remove('redScroll');
		animation.remove('blueScroll');
		animation.remove('purpleScroll');

		loadGraphic(Paths.image('noteskins/notes/default/pixel/' + skin), true, 16, 16);
		animation.add('greenScroll', [0]);
		animation.add('redScroll', [0]);
		animation.add('blueScroll', [0]);
		animation.add('purpleScroll', [0]);
	}

	public static function returnDefaultNote(assetModifier, strumTime, noteData, noteType, noteAlt, ?isSustainNote:Bool = false, ?prevNote:Note = null):Note
	{
		var newNote:Note = new Note(strumTime, noteData, noteAlt, prevNote, isSustainNote);
		newNote.noteType = noteType;

		// frames originally go here
		switch (assetModifier)
		{
			case 'pixel': // pixel arrows default
				if (isSustainNote)
				{
					var noteskin = "default";
					if (Init.trueSettings.get("Quant Notes"))
						noteskin = "quant";
					newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('arrowEnds', assetModifier, noteskin,
						'noteskins/notes')), true, 7,
						6);
					newNote.animation.add('purpleholdend', [4]);
					newNote.animation.add('greenholdend', [6]);
					newNote.animation.add('redholdend', [7]);
					newNote.animation.add('blueholdend', [5]);
					newNote.animation.add('purplehold', [0]);
					newNote.animation.add('greenhold', [2]);
					newNote.animation.add('redhold', [3]);
					newNote.animation.add('bluehold', [1]);
				}
				else
				{
					if (newNote.noteType == 0) 
					{
						var noteskin = "default";
						if (Init.trueSettings.get("Quant Notes"))
							noteskin = "quant";
						newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('arrows-pixels', assetModifier, noteskin,
							'noteskins/notes')),
							true, 17, 17);
						newNote.animation.add('greenScroll', [6]);
						newNote.animation.add('redScroll', [7]);
						newNote.animation.add('blueScroll', [5]);
						newNote.animation.add('purpleScroll', [4]);
					}
					else if (newNote.noteType == 1)
					{
						// here too
						newNote.loadGraphic(Paths.image('noteskins/notes/default/pixel/shroom'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 2)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/pixel/flower'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 3)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/pixel/poison'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
				}
				newNote.antialiasing = false;
				newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
				newNote.updateHitbox();
			case 'gameboy':
				if (isSustainNote)
				{
					var noteskin = "default";
					if (Init.trueSettings.get("Quant Notes"))
						noteskin = "quant";
					newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('arrowEnds', assetModifier, noteskin,
						'noteskins/notes')), true, 7,
						6);
					newNote.animation.add('purpleholdend', [4]);
					newNote.animation.add('greenholdend', [6]);
					newNote.animation.add('redholdend', [7]);
					newNote.animation.add('blueholdend', [5]);
					newNote.animation.add('purplehold', [0]);
					newNote.animation.add('greenhold', [2]);
					newNote.animation.add('redhold', [3]);
					newNote.animation.add('bluehold', [1]);
				}
				else
				{
					if (newNote.noteType == 0) 
					{
						var noteskin = "default";
						if (Init.trueSettings.get("Quant Notes"))
							noteskin = "quant";
						newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('arrows-pixels', assetModifier, noteskin,
							'noteskins/notes')),
							true, 17, 17);
						newNote.animation.add('greenScroll', [6]);
						newNote.animation.add('redScroll', [7]);
						newNote.animation.add('blueScroll', [5]);
						newNote.animation.add('purpleScroll', [4]);
					}
					else if (newNote.noteType == 1)
					{
						// here too
						newNote.loadGraphic(Paths.image('noteskins/notes/default/gameboy/shroom'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 2)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/gameboy/flower'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 3)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/gameboy/poison'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
				}
				newNote.antialiasing = false;
				newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
				newNote.updateHitbox();
			case 'mari0':
				if (isSustainNote)
				{
					var noteskin = "default";
					if (Init.trueSettings.get("Quant Notes"))
						noteskin = "quant";
					newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('arrowEnds', assetModifier, noteskin,
						'noteskins/notes')), true, 7,
						6);
					newNote.animation.add('purpleholdend', [4]);
					newNote.animation.add('greenholdend', [6]);
					newNote.animation.add('redholdend', [7]);
					newNote.animation.add('blueholdend', [5]);
					newNote.animation.add('purplehold', [0]);
					newNote.animation.add('greenhold', [2]);
					newNote.animation.add('redhold', [3]);
					newNote.animation.add('bluehold', [1]);
				}
				else
				{
					if (newNote.noteType == 0) 
					{
						var noteskin = "default";
						if (Init.trueSettings.get("Quant Notes"))
							noteskin = "quant";
						newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('arrows-pixels', assetModifier, noteskin,
							'noteskins/notes')),
							true, 17, 17);
						newNote.animation.add('greenScroll', [6]);
						newNote.animation.add('redScroll', [7]);
						newNote.animation.add('blueScroll', [5]);
						newNote.animation.add('purpleScroll', [4]);
					}
					else if (newNote.noteType == 1)
					{
						// here too
						newNote.loadGraphic(Paths.image('noteskins/notes/default/mari0/shroom'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 2)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/mari0/flower'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 3)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/mari0/poison'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 4)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/mari0/shroom'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 5)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/mari0/flower'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
				}
				newNote.antialiasing = false;
				newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
				newNote.updateHitbox();
			case 'smm':
				if (isSustainNote)
				{
					var noteskin = "default";
					if (Init.trueSettings.get("Quant Notes"))
						noteskin = "quant";
					newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('arrowEnds', assetModifier, noteskin,
						'noteskins/notes')), true, 7,
						6);
					newNote.animation.add('purpleholdend', [4]);
					newNote.animation.add('greenholdend', [6]);
					newNote.animation.add('redholdend', [7]);
					newNote.animation.add('blueholdend', [5]);
					newNote.animation.add('purplehold', [0]);
					newNote.animation.add('greenhold', [2]);
					newNote.animation.add('redhold', [3]);
					newNote.animation.add('bluehold', [1]);
				}
				else
				{
					if (newNote.noteType == 0) 
					{
						var noteskin = "default";
						if (Init.trueSettings.get("Quant Notes"))
							noteskin = "quant";
						newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('arrows-pixels', assetModifier, noteskin,
							'noteskins/notes')),
							true, 17, 17);
						newNote.animation.add('greenScroll', [6]);
						newNote.animation.add('redScroll', [7]);
						newNote.animation.add('blueScroll', [5]);
						newNote.animation.add('purpleScroll', [4]);
					}
					else if (newNote.noteType == 1)
					{
						// here too
						newNote.loadGraphic(Paths.image('noteskins/notes/default/smm/shroom'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 2)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/smm/flower'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 3)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/smm/poison'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 6)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/smm/shroom'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
				}
				newNote.antialiasing = false;
				newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
				newNote.updateHitbox();
			case 'sonic':
				if (isSustainNote)
				{
					var noteskin = "default";
					if (Init.trueSettings.get("Quant Notes"))
						noteskin = "quant";
					newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('arrowEnds', assetModifier, noteskin,
						'noteskins/notes')), true, 7,
						6);
					newNote.animation.add('purpleholdend', [4]);
					newNote.animation.add('greenholdend', [6]);
					newNote.animation.add('redholdend', [7]);
					newNote.animation.add('blueholdend', [5]);
					newNote.animation.add('purplehold', [0]);
					newNote.animation.add('greenhold', [2]);
					newNote.animation.add('redhold', [3]);
					newNote.animation.add('bluehold', [1]);
				}
				else
				{
					if (newNote.noteType == 0) 
					{
						var noteskin = "default";
						if (Init.trueSettings.get("Quant Notes"))
							noteskin = "quant";
						newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('arrows-pixels', assetModifier, noteskin,
							'noteskins/notes')),
							true, 19, 19);
						newNote.animation.add('greenScroll', [6]);
						newNote.animation.add('redScroll', [7]);
						newNote.animation.add('blueScroll', [5]);
						newNote.animation.add('purpleScroll', [4]);
					}
					else if (newNote.noteType == 1)
					{
						// here too
						newNote.loadGraphic(Paths.image('noteskins/notes/default/sonic/shroom'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 2)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/sonic/flower'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 3)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/sonic/poison'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 4)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/sonic/shroom'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
					else if (newNote.noteType == 5)
					{
						newNote.loadGraphic(Paths.image('noteskins/notes/default/sonic/flower'), true, 16, 16);
						newNote.animation.add('greenScroll', [0]);
						newNote.animation.add('redScroll', [0]);
						newNote.animation.add('blueScroll', [0]);
						newNote.animation.add('purpleScroll', [0]);
					}
				}
				newNote.antialiasing = false;
				newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
				newNote.updateHitbox();
		// default: // base game arrows for no reason whatsoever
		// 	var noteskin = "default";
		// 	if (Init.trueSettings.get("Quant Notes"))
		// 		noteskin = "quant";
		// 	newNote.frames = Paths.getSparrowAtlas(ForeverTools.returnSkinAsset('NOTE_assets', assetModifier, noteskin,
		// 		'noteskins/notes'));
		// 	newNote.animation.addByPrefix('greenScroll', 'green0');
		// 	newNote.animation.addByPrefix('redScroll', 'red0');
		// 	newNote.animation.addByPrefix('blueScroll', 'blue0');
		// 	newNote.animation.addByPrefix('purpleScroll', 'purple0');
		// 	newNote.animation.addByPrefix('purpleholdend', 'pruple end hold');
		// 	newNote.animation.addByPrefix('greenholdend', 'green hold end');
		// 	newNote.animation.addByPrefix('redholdend', 'red hold end');
		// 	newNote.animation.addByPrefix('blueholdend', 'blue hold end');
		// 	newNote.animation.addByPrefix('purplehold', 'purple hold piece');
		// 	newNote.animation.addByPrefix('greenhold', 'green hold piece');
		// 	newNote.animation.addByPrefix('redhold', 'red hold piece');
		// 	newNote.animation.addByPrefix('bluehold', 'blue hold piece');
		// 	newNote.setGraphicSize(Std.int(newNote.width * 0.7));
		// 	newNote.updateHitbox();
		// 	newNote.antialiasing = true;
		}
		//
		if (!isSustainNote)
			newNote.animation.play(UIStaticArrow.getColorFromNumber(noteData) + 'Scroll');
		// trace(prevNote);
		if (isSustainNote && prevNote != null)
		{
			newNote.noteSpeed = prevNote.noteSpeed;
			newNote.alpha = 1;
			newNote.animation.play(UIStaticArrow.getColorFromNumber(noteData) + 'holdend');
			newNote.updateHitbox();
			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(UIStaticArrow.getColorFromNumber(prevNote.noteData) + 'hold');
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * prevNote.noteSpeed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
		
		if (noteType != 0)
			newNote.changeSkin();
		return newNote;
	}

	public static function returnQuantNote(assetModifier, strumTime, noteData, noteType, noteAlt, ?isSustainNote:Bool = false, ?prevNote:Note = null):Note
	{
		var newNote:Note = new Note(strumTime, noteData, noteAlt, prevNote, isSustainNote);
		newNote.noteType = noteType;

		// actually determine the quant of the note
		if (newNote.noteQuant == -1)
		{
			/*
				I have to credit like 3 different people for these LOL they were a hassle
				but its gede pixl and scarlett, thank you SO MUCH for baring with me
			 */
			final quantArray:Array<Int> = [4, 8, 12, 16, 20, 24, 32, 48, 64, 192]; // different quants

			var curBPM:Float = Conductor.bpm;
			var newTime = strumTime;
			for (i in 0...Conductor.bpmChangeMap.length) {
				if (strumTime > Conductor.bpmChangeMap[i].songTime){
					curBPM = Conductor.bpmChangeMap[i].bpm;
					newTime = strumTime-Conductor.bpmChangeMap[i].songTime;
				}
			}

			final beatTimeSeconds:Float = (60 / curBPM); // beat in seconds
			final beatTime:Float = beatTimeSeconds * 1000; // beat in milliseconds
			// assumed 4 beats per measure?
			final measureTime:Float = beatTime * 4;

			final smallestDeviation:Float = measureTime / quantArray[quantArray.length - 1];

			for (quant in 0...quantArray.length)
			{
				// please generate this ahead of time and put into array :)
				// I dont think I will im scared of those
				final quantTime = (measureTime / quantArray[quant]);
				if ((newTime + Init.trueSettings['Offset'] + smallestDeviation) % quantTime < smallestDeviation * 2)
				{
					// here it is, the quant, finally!
					newNote.noteQuant = quant;
					break;
				}
			}
		}

		var folderName = "pixel";
		var noteSize = 17;

		switch (assetModifier)
		{
			case "sonic":
				folderName = "sonic";
				assetModifier = "pixel";
				noteSize = 19;
			case "smm":
				folderName = "smm";
				assetModifier = "pixel";
			case "mari0":
				folderName = "mari0";
				assetModifier = "pixel";
			case "gameboy":
				folderName = "gameboy";
				assetModifier = "pixel";
		}

		// note quants
		switch (assetModifier)
		{
			default:
				// inherit last quant if hold note
				if (isSustainNote && prevNote != null)
					newNote.noteQuant = prevNote.noteQuant;
				// base quant notes
				if (!isSustainNote)
				{
					// in case you're unfamiliar with these, they're ternary operators, I just dont wanna check for pixel notes using a separate statement
					var newNoteSize:Int = (assetModifier == 'pixel') ? noteSize : 157;
					var noteskin = "default";
					if (Init.trueSettings.get("Quant Notes"))
						noteskin = "quant";

					newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('NOTE_quants', folderName, noteskin,
						'noteskins/notes', 'quant')),
						true, newNoteSize, newNoteSize);

					newNote.animation.add('leftScroll', [0 + (newNote.noteQuant * 4)]);
					// LOL downscroll thats so funny to me
					newNote.animation.add('downScroll', [1 + (newNote.noteQuant * 4)]);
					newNote.animation.add('upScroll', [2 + (newNote.noteQuant * 4)]);
					newNote.animation.add('rightScroll', [3 + (newNote.noteQuant * 4)]);
				}
				else
				{
					// quant holds
					var noteskin = "default";
					if (Init.trueSettings.get("Quant Notes"))
						noteskin = "quant";
					
					newNote.loadGraphic(Paths.image(ForeverTools.returnSkinAsset('HOLD_quants', folderName, noteskin,
						'noteskins/notes', 'quant')),
						true, (assetModifier == 'pixel') ? 17 : 109, (assetModifier == 'pixel') ? 6 : 52);
					newNote.animation.add('hold', [0 + (newNote.noteQuant * 4)]);
					newNote.animation.add('holdend', [1 + (newNote.noteQuant * 4)]);
					newNote.animation.add('rollhold', [2 + (newNote.noteQuant * 4)]);
					newNote.animation.add('rollend', [3 + (newNote.noteQuant * 4)]);
				}

				if (assetModifier.startsWith('pixel'))
				{
					newNote.antialiasing = false;
					newNote.setGraphicSize(Std.int(newNote.width * PlayState.daPixelZoom));
					newNote.updateHitbox();
				}
				else
				{
					newNote.setGraphicSize(Std.int(newNote.width * 0.7));
					newNote.updateHitbox();
					newNote.antialiasing = true;
				}
		}

		//
		if (!isSustainNote)
			newNote.animation.play(UIStaticArrow.getArrowFromNumber(noteData) + 'Scroll');

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			newNote.noteSpeed = prevNote.noteSpeed;
			newNote.alpha = 1;
			newNote.animation.play('holdend');
			newNote.updateHitbox();

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play('hold');

				prevNote.scale.y *= Conductor.stepCrochet / 100 * (43 / 52) * 1.5 * prevNote.noteSpeed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}

		if (noteType != 0)
			newNote.changeSkin();
		return newNote;
	}
}
