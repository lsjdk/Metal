//
//  ViewController.swift
//  MetalLearn
//
//  Created by 李世举 on 2022/2/20.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    var colorRender: LSJColorRender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let kView = self.view as? MTKView else {
            return
        }
        guard let device = MTLCreateSystemDefaultDevice() else {
            return
        }
        
        kView.device = device
        
        self.colorRender = LSJColorRender.init(With: kView)
        
        kView.delegate = self.colorRender
        
//        kView.preferredFramesPerSecond = 60
    }


}

