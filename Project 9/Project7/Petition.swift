//
//  Petition.swift
//  Project7
//
//  Created by William Fernandez on 10/15/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import Foundation

// structure of each of the petitions
struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
