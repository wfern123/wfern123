//
//  Person.swift
//  Project 10
//
//  Created by William Fernandez on 10/29/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit
// NSObject is what's called a universal base class for all Cocoa Touch classes
class Person: NSObject, Codable {
    // String must have a value, String? doesn't
    // What is the advantage of using a struct over a class?
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
