//
//  Meme.swift
//  MemeMaker
//
//  Created by Atul Acharya on 6/6/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var uuid: String
    var top: String
    var bottom: String
    var originalImage:  UIImage
    var memedImage:     UIImage
}

extension Meme: Equatable {}

func ==(left: Meme, right:Meme) -> Bool {
    return left.uuid == right.uuid
}