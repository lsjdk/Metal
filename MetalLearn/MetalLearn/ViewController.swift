//
//  ViewController.swift
//  MetalLearn
//
//  Created by 李世举 on 2022/2/20.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    private var colorRender: LSJColorRender?
    private var triangleRender: LSJTriangleRender?
    
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
        //绘制三角形
        self.renderTriangle(With: kView)
        //绘制颜色
//        self.renderColor(With: kView)
    }


}
//绘制颜色
extension ViewController {
    func renderTriangle(With kView: MTKView) -> Void {
        self.triangleRender = LSJTriangleRender.init(With: kView)
        self.triangleRender?.mtkView(kView, drawableSizeWillChange: kView.drawableSize)
        kView.delegate = self.triangleRender
    }
}
//绘制颜色
extension ViewController {
    func renderColor(With kView: MTKView) -> Void {
        self.colorRender = LSJColorRender.init(With: kView)
        
        kView.delegate = self.colorRender
    }
}
