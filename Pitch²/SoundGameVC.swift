//
//  SoundGameVC.swift
//  Pitch
//
//  Created by Cluster 5 on 7/10/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

import UIKit

import CoreMotion



class SoundGameVC: UIViewController {
    
    let audioController = PdAudioController();
    
    let motionManager = CMMotionManager()
    var valuesXYZ : Array<Float> = [0.0,0.0,0.0]
    @IBOutlet var backButton: UIButton
    @IBOutlet var alabelX : UILabel
    @IBOutlet var alabelY : UILabel
    @IBOutlet var alabelZ : UILabel

    @IBOutlet var debugL: UILabel
    @IBOutlet var calibrateButton: UIButton
    
    var xVal : CDouble;
    var yVal : CDouble;
    var zVal : CDouble;
    
    var initX: CDouble;
    var initY: CDouble;
    var initZ: CDouble;
    
    var xDiff : CDouble = 0;
    var yDiff : CDouble = 0;
    var zDiff : CDouble = 0;

    
    var initPitch: Float;
    
    init(coder aDecoder: NSCoder!)
    {   xVal = 0;
        yVal = 0;
        zVal = 0;
        initX = 0;
        initY = 0;
        initZ = 0;
        initPitch = 0;
        super.init(coder: aDecoder)
        startAccelerationCollection()
        
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        xVal = 0;
        yVal = 0;
        zVal = 0;
        initX = 0;
        initY = 0;
        initZ = 0;
        initPitch = 0;
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioController.configurePlaybackWithSampleRate(44100, numberChannels: 2, inputEnabled: true, mixingEnabled: true)
        PdBase.setDelegate(self);
        openAndRunTestPatch();
        audioController.print();
        
       // initPitch = Float(drand48());
      //  initPitch * 1000 + 100;
     //   println(initPitch);
     //   PdBase.sendFloat(initPitch, toReceiver: "number");
        
        backButton.layer.cornerRadius = 5.0;
        backButton.layer.borderWidth = 2.0;
        backButton.layer.borderColor = UIColor(red: 79/255, green: 225/255, blue: 180/255, alpha: 1.0).CGColor;
        
        startAccelerationCollection();
        
        self.calibrateButton.layer.cornerRadius = 5.0;
        self.calibrateButton.frame.size =  CGSizeMake(150, 30);
        self.calibrateButton.layer.borderWidth = 2.0;
        self.calibrateButton.layer.borderColor = UIColor(red: 79/255, green: 225/255, blue: 180/255, alpha: 1.0).CGColor;
        
    }
    
    func calibrate() -> Void{
        
        xDiff = xVal;
        yDiff = yVal;
        zDiff = zVal;
        
        
        xVal -= xDiff
        yVal -= yDiff
        zVal -= zDiff
        
    }
    
    @IBAction func calibrateAction(sender: UIButton) {
        calibrate()
    }
    
    
    func startAccelerationCollection() -> Void{
         motionManager.accelerometerUpdateInterval = 0.05
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData :     CMAccelerometerData!, error : NSError!) in
            
            self.xVal = accelerometerData.acceleration.x;
            self.yVal = accelerometerData.acceleration.y;
            self.zVal = accelerometerData.acceleration.z;
            
            var strX = NSString(format: "%.2f", self.xVal-self.xDiff);
            var strY = NSString(format: "%.2f", self.yVal-self.yDiff);
            var strZ = NSString(format: "%.2f", self.zVal-self.zDiff);
            
            self.alabelX.text =  strX
            self.alabelY.text =  strY
            self.alabelZ.text =  strZ
            
            
            self.audioController.active=true
            
            PdBase.sendFloat((fabsf(strX.floatValue) * 200)+300, toReceiver: "carrier")
            //PdBase.sendFloat((fabsf(strY.floatValue) * 200)+300, toReceiver: "harmonicity")
            PdBase.sendFloat(0.0, toReceiver: "harmonicity")
            PdBase.sendFloat(0.0, toReceiver: "index")
            PdBase.sendFloat(1000.0, toReceiver: "duration")
            //println((fabsf(strX.floatValue) * 200)+300)
        })
    }
    
    func openAndRunTestPatch() -> Void {
        let fileName = "compatible_test.pd";
        let bp = NSBundle.mainBundle().bundlePath;
        PdBase.openFile(String(fileName), path: bp);
        audioController.active = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
