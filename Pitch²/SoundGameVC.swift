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
    
    @IBOutlet var countDown: UILabel
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
    
    override func viewDidAppear(animated: Bool) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioController.configurePlaybackWithSampleRate(44100, numberChannels: 2, inputEnabled: true, mixingEnabled: true)
        PdBase.setDelegate(self);
        openAndRunTestPatch();
        audioController.print();
        
        backButton.layer.cornerRadius = 5.0;
        backButton.layer.borderWidth = 2.0;
        backButton.layer.borderColor = UIColor(red: 79/255, green: 225/255, blue: 180/255, alpha: 1.0).CGColor;
        
        self.calibrateButton.layer.cornerRadius = 5.0;
        self.calibrateButton.frame.size =  CGSizeMake(150, 30);
        self.calibrateButton.layer.borderWidth = 2.0;
        self.calibrateButton.layer.borderColor = UIColor(red: 79/255, green: 225/255, blue: 180/255, alpha: 1.0).CGColor;
        
        
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("animateCountDown"), userInfo: nil, repeats: false);
        
        var timer1 = NSTimer.scheduledTimerWithTimeInterval(3.5, target: self, selector: Selector("playRandomPitch"), userInfo: nil, repeats: false);
        
    }
    
    func calibrate() -> Void{
        
        xDiff = xVal;
        yDiff = yVal;
        zDiff = zVal;
        
        
        xVal -= xDiff
        yVal -= yDiff
        zVal -= zDiff
        
    }
    
    func playRandomPitch() -> Void {
        initPitch = (Float(arc4random() % 99 + 1)) / 100;
        var pitch = initPitch * 900 + 100;
        println(initPitch);
        PdBase.sendFloat(pitch, toReceiver: "number");
        
        var timer1 = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("startAccelerationCollection"), userInfo: nil, repeats: false)
    }
    
    @IBAction func calibrateAction(sender: UIButton) {
        calibrate()
    }
    
    func animateCountDown() -> Void {
        UIView.animateWithDuration(0.5, animations: {
            self.countDown.alpha = 1.0;
        }, completion: {
            (value: Bool) in
            UIView.animateWithDuration(0.5, animations: {
                self.countDown.alpha = 0.0;
                }, completion: {
                    (value: Bool)in
                    UIView.animateWithDuration(0.5, animations: {
                        self.countDown.text = String(2);
                        self.countDown.alpha = 1.0;
                        }, completion: {
                            (value: Bool)in
                            UIView.animateWithDuration(0.5, animations: {
                                self.countDown.alpha = 0.0;
                                }, completion: {
                                    (value: Bool)in
                                    UIView.animateWithDuration(0.5, animations: {
                                        self.countDown.text = String(1);
                                        self.countDown.alpha = 1.0;
                                        }, completion: {
                                            (value: Bool)in
                                            UIView.animateWithDuration(0.5, animations: {
                                                self.countDown.alpha = 0.0;
                                                });
                                        });
                                });
                        });
                });

        });
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
            
            PdBase.sendFloat(((strX).floatValue * 900) + 100, toReceiver: "number")
            println(strX.floatValue)
            })
        
        /*
        self.motionManager.gyroUpdateInterval = 0.2
        
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(gyroscopeData :     CMGyroData!, error : NSError!) in
        
        
        self.glabelX.text = String("gX = \(gyroscopeData.rotationRate.x)");
        self.glabelY.text = String("gY = \(gyroscopeData.rotationRate.y)");
        self.glabelZ.text = String("gZ = \(gyroscopeData.rotationRate.z)");
        
        //PdBase.sendList(data, toReceiver:"gyroscope")
        })
        */
    }
    
    func openAndRunTestPatch() -> Void {
        let fileName = "violin.pd";
        let bp = NSBundle.mainBundle().bundlePath;
        PdBase.openFile(String(fileName), path: bp);
        audioController.active = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
