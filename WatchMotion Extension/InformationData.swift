//
//  TableGroupController.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 12/6/15.
//  Copyright © 2015 jeffgukang. All rights reserved.
//

import WatchKit

class InformationData: NSObject {
    
    // Properties
    var label: String!
    var value: String?
    
    init(label: String) {
        self.label = label
    }
}
