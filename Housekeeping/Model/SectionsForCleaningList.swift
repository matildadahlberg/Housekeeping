//
//  SectionsForCleaningList.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-12.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import Foundation


struct SectionForCleaningList {
    var title: String!
    var list: [String]!
    var expanded: Bool!

    init(title: String, list: [String], expanded: Bool){
        self.title = title
        self.list = list
        self.expanded = expanded
    }
}

