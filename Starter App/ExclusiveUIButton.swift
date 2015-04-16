//
//  ExclusiveUIButton.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/16/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import UIKit

class ExclusiveUIButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.exclusiveTouch = true
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
