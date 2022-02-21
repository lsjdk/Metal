//
//  LSJTriangleRender.swift
//  MetalLearn
//
//  Created by 李世举 on 2022/2/20.
//

import Foundation
import MetalKit
import Metal



struct Vertex {
    var position: vector_float2
    var color: vector_float4
}

class LSJTriangleRender: NSObject {
    
    private var device: MTLDevice?
    private var commandQueue: MTLCommandQueue?
    private var pipelineState: MTLRenderPipelineState?
    private var viewportSize: vector_uint2 = vector_uint2(x: 0, y: 0)
    
//    vector_float4(r: 0, g: 0, b: 0, a: 0)
//    rgb
    private var triangleVertices  = [
        Vertex.init(position: vector_float2(x: 250, y: -250), color: vector_float4(1, 0, 0, 1)),
        Vertex.init(position: vector_float2(x: -250, y: -250), color: vector_float4(0, 1, 0, 1)),
        Vertex.init(position: vector_float2(x: 0, y: 250), color: vector_float4(0, 0, 1, 1)),
                                    ]
    
    
    init(With view: MTKView) {
        self.device = view.device
        
        guard let defaultLibrary = self.device?.makeDefaultLibrary() else {
            return
        }
        let vertexFunction = defaultLibrary.makeFunction(name: "vertexShader")
        let fragmentFunction = defaultLibrary.makeFunction(name: "fragmentShader")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor.init()
        
        pipelineStateDescriptor.label = "Simple Pipeline"
        
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        
        guard let pipelineState = try? self.device?.makeRenderPipelineState(descriptor: pipelineStateDescriptor) else {
            return
        }
        self.pipelineState = pipelineState
        self.commandQueue = self.device?.makeCommandQueue()
    }
}

extension LSJTriangleRender: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize.x = UInt32(size.width)
        self.viewportSize.y = UInt32(size.height)
    }
    
    func draw(in view: MTKView) {
        
        let commandBuffer = self.commandQueue?.makeCommandBuffer()
        commandBuffer?.label = "My Command"
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.label = "My RenderEncoder"
        
        print("-=-=-=\(self.viewportSize)")
        
        let viewPort = MTLViewport.init(originX: 0, originY: 0, width: Double(self.viewportSize.x), height: Double(self.viewportSize.y), znear: -1, zfar: 10)
        renderEncoder?.setViewport(viewPort)
        renderEncoder?.setRenderPipelineState(self.pipelineState!)
        
        renderEncoder?.setVertexBytes(&triangleVertices, length: MemoryLayout<Vertex>.size * triangleVertices.count, index: 0)
        
        renderEncoder?.setVertexBytes(&self.viewportSize, length: MemoryLayout<vector_uint2>.size, index: 1)
        
        renderEncoder?.drawPrimitives(type: MTLPrimitiveType.triangle, vertexStart: 0, vertexCount: 3)
        
        renderEncoder?.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
