//
//  SoundGameVC.swift
//  Pitch²
//
//  Created by Cluster 5 on 7/10/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

import UIKit

class SoundGameVC: UIViewController {
    
    let audioController = PdAudioController();
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var initialPitch = arc4random() % 901 + 100; //generate random int between 100-10000
        println(initialPitch);
        audioController.configurePlaybackWithSampleRate(44100, numberChannels: 2, inputEnabled: true, mixingEnabled: true)
        PdBase.setDelegate(self);
        runPatch();
        audioController.print();
        
        PdBase.sendFloat(Float(initialPitch), toReceiver: "number");
        
    }
    
    func runPatch() -> Void {
        let fileName = "test4.pd";
        let bp = NSBundle.mainBundle().bundlePath;
        PdBase.openFile(String(fileName), path: bp);
        audioController.active = true;
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
