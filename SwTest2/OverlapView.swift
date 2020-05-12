//
//  OverlapView.swift
//  SwTest2
//
//  Created by JimLai on 2020/4/10.
//  Copyright © 2020 stargate. All rights reserved.
//

import UIKit

class OverlapView: UIView {
    
    @IBOutlet var rightView: UIStackView!
    @IBOutlet var leftView: UIStackView!
    @IBOutlet var centerView: UIStackView!
    
    func update(_ data: [UIView]) {
        let views = [leftView, centerView, rightView]
        for v in views {
            v?.arrangedSubviews.forEach {$0.removeFromSuperview()}
        }
        
        switch data.count {
        case 0:
            break
        case 1:
            leftView.addArrangedSubview(data[0])
        case 2:
            leftView.addArrangedSubview(data[0])
            centerView.addArrangedSubview(data[1])
        default:
            leftView.addArrangedSubview(data[0])
            centerView.addArrangedSubview(data[1])
            rightView.addArrangedSubview(data[2])
        }
    }
}
