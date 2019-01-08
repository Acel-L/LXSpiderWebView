//
//  ViewController.swift
//  LXSpiderWebView
//
//  Created by 罗欣 on 2019/1/8.
//  Copyright © 2019 罗欣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let spiderwebView = LXSpiderWebView(frame: CGRect(x: 20, y: 50, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40), sideNum: 5)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configLayout()
    }


}


extension ViewController {
    
    func configLayout() {
        view.backgroundColor = UIColor.white
        view.addSubview(spiderwebView)
        
        //只写了五个滑块  例子八个边可以添加8个滑块控制
        let a0 = UISlider(frame: CGRect(x: 40, y: spiderwebView.frame.maxY + 20, width: 300, height: 20))
        let a1 = UISlider(frame: CGRect(x: 40, y: a0.frame.maxY + 20, width: 300, height: 20))
        let a2 = UISlider(frame: CGRect(x: 40, y: a1.frame.maxY + 20, width: 300, height: 20))
        let a3 = UISlider(frame: CGRect(x: 40, y: a2.frame.maxY + 20, width: 300, height: 20))
        let a4 = UISlider(frame: CGRect(x: 40, y: a3.frame.maxY + 20, width: 300, height: 20))
        
        view.addSubview(a0)
        view.addSubview(a1)
        view.addSubview(a2)
        view.addSubview(a3)
        view.addSubview(a4)
        
        
        a0.tag = 0
        a1.tag = 1
        a2.tag = 2
        a3.tag = 3
        a4.tag = 4
        
        a0.addTarget(self, action: #selector(sliderAction(slider:)), for: .valueChanged)
        a1.addTarget(self, action: #selector(sliderAction(slider:)), for: .valueChanged)
        a2.addTarget(self, action: #selector(sliderAction(slider:)), for: .valueChanged)
        a3.addTarget(self, action: #selector(sliderAction(slider:)), for: .valueChanged)
        a4.addTarget(self, action: #selector(sliderAction(slider:)), for: .valueChanged)
        
    }
    
    
    @objc func sliderAction(slider: UISlider) {
        
        spiderwebView.spiderWebViewChangeValue(value: CGFloat(slider.value), type: LXSpiderWebItemType(rawValue: slider.tag))
        
        
    }
    
}
