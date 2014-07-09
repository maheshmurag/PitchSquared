//
//  PitchData.swift
//  Pitch²
//
//  Created by Cluster 5 on 7/9/14.
//  Copyright (c) 2014 Alex Yeh. All rights reserved.
//

import UIKit

class PitchData {
    class var sharedInstance : PitchData {
        get {
            var onceToken : dispatch_once_t = dispatch_once_t(0)
            var instance : PitchData! = nil
            dispatch_once(&onceToken) {
                instance = PitchData()
            }
            return instance
        }
    }
    var score:Int = 0;
    var highscore:Int = 0;
}

