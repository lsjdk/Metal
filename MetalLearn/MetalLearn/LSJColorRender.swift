//
//  LSJColorRender.swift
//  MetalLearn
//
//  Created by 李世举 on 2022/2/20.
//

import Foundation
import MetalKit



struct LSJColor {
    var red, green, blue, alpha : Double?
}

class LSJColorRender: NSObject {
    
    private var device: MTLDevice?
    private var commandQueue: MTLCommandQueue?
    
    private var colorChannels: [Double] = [1, 0, 0, 1]
    
    init(With view: MTKView) {
        self.device = view.device
        self.commandQueue = self.device?.makeCommandQueue()
    }
}

extension LSJColorRender: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        let color = self.makeFancyColor()
        view.clearColor = MTLClearColor.init(red: color.red ?? 0, green: color.green ?? 0, blue: color.blue ?? 0, alpha: color.alpha ?? 0)
        
        let commandBuffer = self.commandQueue?.makeCommandBuffer()
        commandBuffer?.label = "My Command"
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        let renderEncoder = commandBuffer?.makeParallelRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderEncoder?.label = "My RenderEncoder"
        
        renderEncoder?.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

extension LSJColorRender {
    func makeFancyColor() -> LSJColor {
        
        return LSJColor.init(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1), alpha: 1)
    }
}
