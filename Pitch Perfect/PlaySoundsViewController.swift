//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kevin Boyse on 4/25/15.
//  Copyright (c) 2015 Kevin Boyse. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audio:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audio = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audio.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        var fullFilePath:String
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var filePathsArray = NSFileManager.defaultManager().subpathsOfDirectoryAtPath(paths, error: nil)

        if receivedAudio.filePathUrl != nil {
            var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            var filename = receivedAudio.title! as String!
            var fullFilePath = paths.stringByAppendingPathComponent(filename)
            NSFileManager.defaultManager().removeItemAtPath(fullFilePath, error: nil)
        }
    }
    func startSounds() {
        audio.stop()
        audio.currentTime = 0.0
        audio.play()
    }
    @IBAction func stopPlaySounds(sender: UIButton) {
        audio.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playSoundsQuickly(sender: UIButton) {
        audio.stop()
        audioEngine.stop()
        audioEngine.reset()
        audio.rate = 1.5
        startSounds()
    }
    
    @IBAction func playSoundsSlowly(sender: UIButton) {
        audio.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //Play audio sloooooly here...
        audio.rate = 0.5
        startSounds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func echo(sender: UIButton) {
        audio.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.2
        audioEngine.attachNode(echoEffect)
        
        audioEngine.connect(audioPlayerNode, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func reverb(sender: UIButton) {
        audio.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 30
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audio.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}
