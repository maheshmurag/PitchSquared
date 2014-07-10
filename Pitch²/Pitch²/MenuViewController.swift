//
//  MenuViewController.swift
//  Pitch
//
//  Created by Cluster 5 on 7/9/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

import UIKit
import Foundation

class MenuViewController: UIViewController {
    
    @IBOutlet var pitchTitle: UILabel
    @IBOutlet var squaredLabel: UILabel
    @IBOutlet var startCover: UIView
    @IBOutlet var highScoreCover: UIView
    @IBOutlet var helpCover: UIView
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.pitchTitle.frame = CGRect(x: 267, y: self.pitchTitle.frame.origin.y , width: self.pitchTitle.frame.size.width, height: self.pitchTitle.frame.size.height)
             self.squaredLabel.alpha = 1.0
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(0.5, animations: {
                    self.startCover.frame = CGRect(x: 1024, y: self.startCover.frame.origin.y , width: 457, height: self.startCover.frame.size.height)
                }, completion: {(value: Bool) in})
                UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.highScoreCover.frame = CGRect(x: 1024, y: self.highScoreCover.frame.origin.y , width: 457, height: self.highScoreCover.frame.size.height)
                }, completion: {(value: Bool) in})
                UIView.animateWithDuration(0.5, delay: 0.4, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.helpCover.frame = CGRect(x: 1024, y: self.helpCover.frame.origin.y, width: 457, height: self.helpCover.frame.size.height)
                }, completion: {(value: Bool) in})
            });
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var pitchData:PitchData = PitchData.sharedInstance;
//        pitchData.score = 10;
//        println("\(pitchData.score)")
        
        //Cool Animations
            
        
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
