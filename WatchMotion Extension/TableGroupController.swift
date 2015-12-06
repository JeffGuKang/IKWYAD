//
//  TableGroupController.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 12/6/15.
//  Copyright © 2015 jeffgukang. All rights reserved.
//

import WatchKit

class TableGroupController: WKInterfaceGroup {
    @IBOutlet var axisLabel: WKInterfaceLabel!
    @IBOutlet var axisValue: WKInterfaceLabel!
    init(Label: String) {
        self.axisLabel.setText(Label)
    }
}
