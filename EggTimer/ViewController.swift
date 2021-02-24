//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController
{
	//Outlets link a UI component to it's code representation within this class.
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var progressBar: UIProgressView!
	let eggTimesDictionary = ["Soft": 3, "Medium": 4, "Hard": 7]
	var secondsRemaining = 0
	var timer = Timer()
	var totalTime = 0
	var secondsPassed = 0
	var player: AVAudioPlayer?
	
	// Private function.
	fileprivate func countDownTimer() -> Timer {
		return // Executes timer.
			Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
			{
				(Timer) in
				if self.secondsPassed < self.totalTime
				{
					self.secondsPassed += 1
					
					self.progressBar.progress = Float(self.secondsPassed) / Float(self.totalTime)
				}
				else
				{
					Timer.invalidate()
					self.titleLabel.text = "Done!"
					self.playAlarm()
				}
			}
	}
	
	fileprivate func playAlarm()
	{
		guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
		
		do
		{
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)

			/* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
			player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

			/* iOS 10 and earlier require the following line:
			player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

			guard let player = player else { return }

			player.play()

		}
		catch let error
		{
				print(error.localizedDescription)
		}
	}
	
	//IBActions are like event handlers in other languages. This one is for the hardness (text) buttons (e.g. the "Soft" button).
	@IBAction func hardnessSelected(_ sender: UIButton)
	{
		/* Note:
			"!" is used to indicate that you know that this variable may be null (or "nill" as they call it in Swift). You are acknowledging that you are sure that this value will not be nill. If it might be, surround with a check:
		
			if(variable != nill)
			{
				//Do something
			}
			//Else continue (skip this code^)
		*/
		
		
		
		//Invalidates timer so that previous timer thread stops, if there is one currently running, before a new one starts.
		timer.invalidate()
		//Stores hardness title. e.g. "Soft", "Medium", "Hard"
		let hardness = sender.currentTitle!
		//Sets seconds to countdown based on hardness selected.
		totalTime = eggTimesDictionary[hardness]!
		
		//Resets properties for next run (e.g. progress bar's progress).
		progressBar.progress = 0
		secondsPassed = 0
		titleLabel.text = hardness
		
		//Executes countDown on the timer
		timer = countDownTimer()
	}
	
}
