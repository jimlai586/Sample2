//
//  ViewController.swift
//  SwTest2
//
//  Created by JimLai on 2020/4/10.
//  Copyright © 2020 stargate. All rights reserved.
//

import UIKit

enum State {
    case nonOverlap, layoutUnresolved, layoutResolved
}

class ViewController: UIViewController {

    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var row: UIStackView!
    @IBOutlet var separator: UIView!
    @IBOutlet var overlap: OverlapView!
    @IBOutlet var slider: UISlider!
    var users = [UIView]() {
        didSet {
            if state == .layoutResolved {
                state = .layoutUnresolved
            }
            view.setNeedsLayout()
        }
    }
    var state: State = .layoutUnresolved
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        slider.addTarget(self, action: #selector(slide(_:)), for: .valueChanged)
        slide(slider)
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        overlap.addGestureRecognizer(tap)

    }
    @objc func onTap() {
        state = .nonOverlap
        updateRow(users, [])
    }
    
    @objc func slide(_ sender: UISlider) {
        slider.value = slider.value.rounded()
        print(slider.value)
        users = (0 ..< Int(slider.value)).map {_ in UIImageView(image: UIImage(named: "man"))}
        state = .layoutUnresolved
        updateRow(users, [])
    }
    override func viewDidLayoutSubviews() {
        guard state == .layoutUnresolved else {return}
        row.layoutIfNeeded()
        guard let f = row.arrangedSubviews.first, f.frame.width > 0 else {
            return
        }
        let w = f.frame.width
        let sw = scroll.frame.width
        var tail = users
        var head = [UIView]()
        var contentWidth: CGFloat = 0
        while let v = tail.first {
            contentWidth += w
            guard contentWidth < sw else {
                break
            }
            tail.removeFirst()
            head.append(v)
        }
        updateRow(head, (0 ..< tail.count).map {_ in UIImageView(image: UIImage(named: "man"))})
        state = .layoutResolved
    }
    
    func updateRow(_ head: [UIView], _ tail: [UIView]) {
        row.arrangedSubviews.forEach {$0.removeFromSuperview()}
        head.forEach {row.addArrangedSubview($0)}
        if tail.count > 0 {
            overlap.update(tail)
            row.addArrangedSubview(separator)
        separator.widthAnchor.constraint(equalToConstant: 21).isActive = true
            separator.heightAnchor.constraint(equalTo: row.heightAnchor, multiplier: 1).isActive = true
            row.addArrangedSubview(overlap)
        }
    }


}

