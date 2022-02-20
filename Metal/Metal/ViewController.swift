//
//  ViewController.swift
//  Metal
//
//  Created by 李世举 on 2022/2/20.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    private var render: LSJColorRender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let kView = self.view as? MTKView else {
            return
        }
        kView.device = 
    }


}


