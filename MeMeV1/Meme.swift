//
//  Meme.swift
//  MeMeV1
//
//  Created by Andreas Talg on 20.09.15.
//  Copyright (c) 2015 Andreas Talg. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var originalImage : UIImage
    var memedImage : UIImage
    var topText : String
    var bottomText : String
    
    init(topText : String, bottomText : String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}