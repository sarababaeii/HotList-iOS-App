//
//  HotTask.swift
//  HotList
//
//  Created by Sara Babaei on 3/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

class HotTask{
    var caption: String
    var priority: Priority
    var completed = false
    
    init(caption: String?) {
        if let newCaption = caption{
            self.caption = newCaption
        }
        else{
            self.caption = "Do something"
        }
        priority = .top
    }
}
