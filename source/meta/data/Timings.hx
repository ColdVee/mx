package meta.data;

import gameObjects.userInterface.notes.*;
import meta.state.PlayState;

/**
	Here's a class that calculates timings and judgements for the songs and such
**/
class Timings
{
	//
	public static var accuracy:Float;
	public static var trueAccuracy:Float;
	public static var judgementRates:Array<Float>;

	// from left to right
	// max milliseconds, score from it and percentage
	public static var judgementsMap:Map<String, Array<Dynamic>> = [
		"sick" => [0, 50, 350, 100, 3, 30],
		"good" => [1, 100, 150, 75, 2, 15],
		"bad" => [2, 120, 0, 25, 1, 0],
		"shit" => [3, 140, -50, -150, 0, -300],
		"miss" => [4, 180, -100, -175, 0, 505],
	];

	public static var msThreshold:Float = 0;

	// set the score judgements for later use
	public static var scoreRating:Map<String, Int> = [
		"S+" => 100, 
		"S" => 95, 
		"A" => 90, 
		"b" => 85, 
		"c" => 80, 
		"d" => 75, 
		"e" => 70, 
		"f" => 65,
	];

	// set the score judgements for later use
	public static var scoreIndex:Map<Int, Int> = [
		7 => 100,
		6 => 95,
		5 => 90,
		4 => 85,
		3 => 80,
		2 => 75,
		1 => 70,
		0 => 65,
	];

	public static var ratingIntFinal:Int = 0;
	public static var ratingFinal:String = "f";
	public static var notesHit:Int = 0;

	public static var comboDisplay:Int = 0;
	public static var notesHitNoSus:Int = 0;

	public static var gottenJudgements:Map<String, Int> = [];
	public static var smallestRating:String;

	public static function callAccuracy()
	{
		// reset the accuracy to 0%
		accuracy = 0.001;
		trueAccuracy = 0;
		judgementRates = new Array<Float>();

		// reset ms threshold
		var biggestThreshold:Float = 0;
		for (i in judgementsMap.keys())
			if (judgementsMap.get(i)[1] > biggestThreshold)
				biggestThreshold = judgementsMap.get(i)[1];
		msThreshold = biggestThreshold;

		// set the gotten judgement amounts
		for (judgement in judgementsMap.keys())
			gottenJudgements.set(judgement, 0);
		smallestRating = 'sick';

		notesHit = 0;
		notesHitNoSus = 0;

		ratingFinal = "f";

		comboDisplay = 0;
	}

	/*
		You can create custom judgements here! just assign values to it as explained below.
		Null means that it is the highest judgement, meaning it doesn't get a check and is set automatically
	 */
	public static function accuracyMaxCalculation(realNotes:Array<Note>)
	{
		// first we split the notes and get a total note number
		var totalNotes:Int = 0;
		for (i in 0...realNotes.length)
		{
			if (realNotes[i].mustPress)
				totalNotes++;
		}
	}

	public static function updateAccuracy(judgement:Int, isSustain:Bool = false)
	{
		notesHit++;
		if (!isSustain)
			notesHitNoSus++;
		accuracy += Math.max(0, judgement);
		trueAccuracy = (accuracy / notesHit);

		updateFCDisplay();
		updateScoreRating();
	}

	public static function updateFCDisplay()
	{
		// update combo display
		comboDisplay = 0;
		if (judgementsMap.get(smallestRating)[4] != null)
			comboDisplay = judgementsMap.get(smallestRating)[4];

		// this updates the most so uh
		if (PlayState.isGameboy)
		{
			PlayState.gameboyHUD.updateScoreText();
		}
		else if (PlayState.isMari0)
		{
			PlayState.mari0HUD.updateScoreText();
		}
		else if (PlayState.isSMM)
		{
			PlayState.smmHUD.updateScoreText();
		}
		else if (PlayState.isSonic)
		{
			PlayState.sonicHUD.updateScoreText();
		}
		else
		{
			PlayState.uiHUD.updateScoreText();
		}
	}

	public static function getAccuracy()
	{
		return trueAccuracy;
	}

	public static function updateScoreRating()
	{
		updateScoreIntRating();
		var biggest:Int = 0;
		for (score in scoreRating.keys())
		{
			if ((scoreRating.get(score) <= trueAccuracy) && (scoreRating.get(score) >= biggest))
			{
				biggest = scoreRating.get(score);
				ratingFinal = score;
			}
		}
	}

	public static function updateScoreIntRating()
	{
		var biggest:Int = 0;
		for (score in scoreIndex.keys())
		{
			if ((scoreIndex.get(score) <= trueAccuracy) && (scoreIndex.get(score) >= biggest))
			{
				biggest = scoreIndex.get(score);
				ratingIntFinal = score;
			}
		}
	}

	public static function returnScoreRating()
	{
		return ratingFinal;
	}
}
