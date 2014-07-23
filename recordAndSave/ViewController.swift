//
//  ViewController.swift
//  mircrophone
//
//  Created by Martin Jaroszewicz on 6/26/14.
//  Copyright (c) 2014 com.cosmos. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
  //  @IBOutlet var myLabel : UILabel
    
  //  @IBOutlet var mySlider: UISlider
    
   
    
    @IBOutlet var start: UIButton
    
    @IBOutlet var labelRecord: UILabel
    
    @IBOutlet var stop: UIButton
    
    
    @IBOutlet var play: UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    let dispatcher = PdDispatcher()
   //     dispatcher.addListener(self, forSource:"snapshot") //receive messages from symbol snapshot
   //     PdBase.setDelegate(dispatcher)
        let fileName = "oscil.pd"
        let bp = NSBundle.mainBundle().bundlePath
        PdBase.openFile(String(fileName), path: bp)
        
        //Search paths for Documents Directory
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var samplePath = paths.stringByAppendingPathComponent("recording.wav")
        PdBase.sendMessage(samplePath, withArguments: nil, toReceiver: "filename")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  //  func receiveFloat(received:Float, fromSource:String)->Void{
   //     myLabel.text=String(received)
   // }
//    @IBAction func mySliderAction(sender: AnyObject) {
 //       PdBase.sendFloat(mySlider.value, toReceiver: "osc")
  //  }
    

    @IBAction func startAction(sender: UIButton) {
        PdBase.sendBangToReceiver("start")
    }
    
    @IBAction func stopAction(sender: UIButton) {
        PdBase.sendBangToReceiver("stop")
    }
    
    @IBAction func playAction(sender: UIButton) {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var samplePath = paths.stringByAppendingPathComponent("recording.wav")
        println(samplePath)
        PdBase.sendMessage(samplePath, withArguments: nil, toReceiver: "play")
        //PdBase.sendBangToReceiver("play")
    }
    
}

