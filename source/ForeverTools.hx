package;

import flixel.FlxG;
import flixel.system.FlxSound;
import meta.data.*;
import openfl.utils.Assets;

/**
	This class is used as an extension to many other forever engine stuffs, please don't delete it as it is not only exclusively used in forever engine
	custom stuffs, and is instead used globally.
**/
class ForeverTools
{
	// set up maps and stuffs
	public static function resetMenuMusic(resetVolume:Bool = true)
	{
		// // make sure the music is playing
		// if (((FlxG.sound.music != null) && (!FlxG.sound.music.playing))
		// 	|| (FlxG.sound.music == null))
		// {
		var song = Paths.music('freakyMenu');
		FlxG.sound.playMusic(song, 0.7);
		FlxG.sound.music.volume = 0.7;
		FlxG.sound.music.looped = true;
		// placeholder bpm
		Conductor.changeBPM(89);
		// }
		//
	}

	// set up maps and stuffs
	public static function playFreeplayMusic(resetVolume:Bool = true)
	{	
		var song = Paths.music('freeplayMenu');
		FlxG.sound.playMusic(song, 0.7);
		// placeholder bpm
		Conductor.changeBPM(89);
	}

	// set up maps and stuffs
	public static function playOptionsMusic(resetVolume:Bool = true)
	{
		var song = Paths.music('optionsMenu');
		FlxG.sound.playMusic(song, 0.55);
		// placeholder bpm
		Conductor.changeBPM(89);
	}

	// set up maps and stuffs
	public static function playTitleMusic(resetVolume:Bool = true)
		{
			var song = Paths.music('titleMenu');
			FlxG.sound.playMusic(song, 0.65);
			FlxG.sound.music.looped = false;
			// placeholder bpm
			Conductor.changeBPM(89);
		}

	// set up maps and stuffs
	public static function playEasterEgg(resetVolume:Bool = true)
	{
		var song = Paths.file('images/UI/default/gameboy/music.ogg');
		FlxG.sound.playMusic(song, 0.55);
		// placeholder bpm
		Conductor.changeBPM(89);
	}
	

	public static function returnSkinAsset(asset:String, assetModifier:String = 'base', changeableSkin:String = 'default', baseLibrary:String,
			?defaultChangeableSkin:String = 'default', ?defaultBaseAsset:String = 'base'):String
	{
		var realAsset = '$baseLibrary/$changeableSkin/$assetModifier/$asset';
		if (!Assets.exists(Paths.image(realAsset)))
		{
			realAsset = '$baseLibrary/$defaultChangeableSkin/$assetModifier/$asset';
			if (!Assets.exists(Paths.image(realAsset)))
				realAsset = '$baseLibrary/$defaultChangeableSkin/$defaultBaseAsset/$asset';
		}

		return realAsset;
	}

	public static function killMusic(songsArray:Array<FlxSound>)
	{
		// neat function thing for songs
		for (i in 0...songsArray.length)
		{
			// stop
			songsArray[i].stop();
			songsArray[i].destroy();
		}
	}
}
