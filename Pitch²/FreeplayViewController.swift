//
//  FreeplayViewController.swift
//  PitchSquared
//
//  Created by Cluster 5 on 7/16/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

import UIKit
import CoreMotion

class FreeplayViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    
    @IBOutlet var playButton: UIButton
    @IBOutlet var backButton: UIButton
    @IBOutlet var calibrateButton: UIButton
    @IBOutlet var record: UIButton
    
    var xVal : CDouble = 0;
    var yVal : CDouble = 0;
    var zVal : CDouble = 0;
    var recordOn: Bool;
    var xDiff : CDouble = 0;
    var yDiff : CDouble = 0;
    var dateStart : NSDate;
    var zDiff : CDouble = 0;
    var freq : Int = 0
    var scale : Int = 0
    var prevRec: Bool;
    var hasRec : Bool = false;
    var rec: Bool = false;
    var freqList : Float[] = [110.0,116.54,123.47,130.81,138.59,146.83,155.56,164.81,174.61,185.00,196.00,207.65,220.0,233.08,246.94,261.63,277.18,293.66,311.13,329.63,349.23,369.99,392.63,415.30,440.00,466.16,493.88,523.25,554.37,587.33,622.25,659.25,698.46,739.99,783.99,830.61,880.0,932.33,987.77,1046.50,1108.73,1174.66,1244.51,1318.51,1396.91,1479.98,1567.98,1661.22,1760.00];
    
    var freqListNote : Dictionary<Float, String> = [110.0:"A2",116.54:"A2S",123.47:"B2",130.81:"C3",138.59:"C3S",146.83:"D3",155.56:"D3S",164.81:"E3",174.61:"F3",185.00:"F3S",196.00:"G3",207.65:"G3S",220.0:"A3",233.08:"A3S",246.94:"B3",261.63:"C4",277.18:"C4S",293.66:"D4",311.13:"D4S",329.63:"E4",349.23:"F4",369.99:"F4S",392.63:"G4",415.30:"G4S",440.00:"A4",466.16:"A4S",493.88:"B4",523.25:"C5",554.37:"C5S",587.33:"D5",622.25:"D5S",659.25:"E5",698.46:"F5",739.99:"F5S",783.99:"G5",830.61:"G5S",880.0:"A5",932.33:"A5S",987.77:"B5",1046.50:"C6",1108.73:"C6S",1174.66:"D6",1244.51:"D6S",1318.51:"E6",1396.91:"F6",1479.98:"F6S",1567.98:"G6",1661.22:"G6S",1760.00:"A6"];
    
    init(coder aDecoder: NSCoder!)
    {
        // freqToNote = [440.0: "A4", 466.16: "As4"]
        recordOn = false;
        self.prevRec = false;
        dateStart = NSDate();
        super.init(coder: aDecoder)
    }
    
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        recordOn = false;
        self.prevRec = false;
        dateStart = NSDate();
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    override func viewDidAppear(animated: Bool)  {
        //start
        
    }
    
    @IBAction func backAction(sender: UIButton) {
        stopUpdates()
    }
    
    func stopUpdates() -> Void{
        motionManager.stopAccelerometerUpdates();
        
    }

    func calibrate() -> Void{
        
        xDiff = xVal;
        yDiff = yVal;
        zDiff = zVal;
        
        xVal -= xDiff
        yVal -= yDiff
        zVal -= zDiff
        
    }
    
    @IBAction func calibrateAction(sender: AnyObject) {
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
            
            self.freq = Int(floor(1.0+strX.doubleValue * 6.0))+6
            //println(strX.doubleValue)
            self.scale = Int(floor((strY.doubleValue + 1.0)*2))
            // println("freqB: \(self.freq)");
            if (self.scale) >= 3
            {  //println("octave: \(self.freqList[self.freq])")
                self.freq += 36;
                if(self.freq>=48){
                    self.freq = 47
                }
            }
            else if (self.scale) >= 2 {
                self.freq += 24
                
            }
            else if (self.scale) >= 1 {
                self.freq += 12
            }
            else{
                if(self.freq<=0)
                {
                    self.freq=0;
                }
            }
            
            var superfreq : CFloat =  self.freqList[self.freq]
            self.playButton.setTitle(self.freqListNote[superfreq], forState: UIControlState.Normal);
            self.playButton.setTitle(self.freqListNote[superfreq], forState: UIControlState.Highlighted);
//            UIView.animateWithDuration(0.1, animations:
//                {self.playButton.setTitleColor(UIColor(red: strX.floatValue + 1, green: strY.floatValue + 1, blue: strZ.floatValue + 1, alpha: 1.0), forState: nil)
//                    
//                });
            if(self.playButton.touchInside)
            {//println("button pressed")
                PdBase.sendBangToReceiver("vocoderStart")
                PdBase.sendFloat(superfreq, toReceiver: "vocoderTransposition")
                if(self.recordOn){
                    //self.timeMeasure.updateValue(NSString(format: "%.2f", superfreq).floatValue, forKey: self.diffMill());
                }
                //self.playButton.titleLabel.text="";
                //self.playButton.titleLabel.text=self.freqListNote[superfreq];
                //self.playButton.titleLabel.sizeThatFits(CGSize(width: 300, height:150))
                //record sound to pd
            }
            else{
                //println("button let go")
                PdBase.sendBangToReceiver("vocoderStop")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAccelerationCollection();
        
        backButton.layer.cornerRadius = 5.0;
        backButton.layer.borderWidth = 2.0;
        backButton.layer.borderColor = UIColor(red: 79/255, green: 225/255, blue: 180/255, alpha: 1.0).CGColor;
        
        calibrateButton.layer.cornerRadius = 5.0;
        calibrateButton.layer.borderWidth = 2.0;
        calibrateButton.layer.borderColor = UIColor(red: 79/255, green: 225/255, blue: 180/255, alpha: 1.0).CGColor;
        
//        var paths = "/Users/cluster5/Desktop/hi.wav"
//        paths = paths.stringByAppendingString("/hi");
//        println(paths);
//        PdBase.sendMessage(paths, withArguments: nil, toReceiver: "fileLoc");
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var samplePath = paths.stringByAppendingPathComponent("recording.wav")
        PdBase.sendMessage(samplePath, withArguments: nil, toReceiver: "filename")
        
    }
    
    func diffMill() -> Float{
        var dateCur: NSDate = NSDate()
        
        return  NSString(format: "%.2f", dateCur.timeIntervalSinceDate(dateStart)).floatValue;
    }

    
    @IBAction func recording(sender: UIButton) {
        if(!recordOn) {
            UIView.animateWithDuration(0.5, animations: {
                self.record.setImage(UIImage(named: "recordStop"), forState: UIControlState.Normal)
                self.recordOn = !self.recordOn;
            });
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.record.setImage(UIImage(named: "record"), forState: UIControlState.Normal)
                self.recordOn = !self.recordOn;
            });
        }
        
        if (recordOn) {
            PdBase.sendBangToReceiver("start")
//            PdBase.sendFloat(20000, toReceiver:"recLen")
//            PdBase.sendBangToReceiver("rec")
        }
            
        else if (recordOn != true && prevRec == true) {
//            PdBase.sendFloat(diffMill() * 44100.0, toReceiver: "resVal")
//            println(diffMill() * 44100)
            PdBase.sendBangToReceiver("stop")
            hasRec = true;
        }
        prevRec = recordOn

    }
    
    @IBAction func playbackAction(sender: AnyObject) {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var samplePath = paths.stringByAppendingPathComponent("recording.wav")
        println(samplePath)
        PdBase.sendMessage(samplePath, withArguments: nil, toReceiver: "play")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
