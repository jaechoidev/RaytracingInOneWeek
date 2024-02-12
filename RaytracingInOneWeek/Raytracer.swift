//
//  Raytracer.swift
//  RaytracingInOneWeek
//
//  Created by Jae Choi on 2024-02-11.
//

import SwiftUI
import AppKit

class Raytracer: ObservableObject {
    @Published var progress: String = ""
    @Published var pixelArray: [UInt8] = []
    var scanlinePixels: [UInt8] = []
    var initPixels: [UInt8] = Array(repeating: 0, count: 1000)
    var width: Int
    var height: Int
    
    init(width: Int, height: Int){
        self.width = width
        self.height = height

        self.pixelArray = Array(repeating: 0, count: self.width*self.height*4)
        self.initPixels = self.pixelArray
    }
    
    func forceUpdate() {
        self.objectWillChange.send()
    }
    
    func render () async {
        self.pixelArray = self.initPixels
        var r : UInt8 = 0;
        var g : UInt8 = 0;
        var b : UInt8 = 0;
        var a : UInt8 = 0;
        for j in 0..<height{
            self.progress = "Scanlines remaining : \(height - j)"
            self.scanlinePixels = []
            for i in 0..<width{
                r = UInt8(clamping: Int(floor(Double(Double(i) / Double(width - 1)) * 255.999)))
                g = UInt8(clamping: Int(floor(Double(Double(j) / Double(height - 1)) * 255.999)))
                b = UInt8(clamping: (0 * 255))
                a = UInt8(clamping: (1 * 255))
                self.scanlinePixels.append(contentsOf: [r,g,b,a])
            }
            self.pixelArray.replaceSubrange((self.width*j*4..<(self.width*(j+1))*4),
                                            with: self.scanlinePixels)
            self.scanlinePixels = []
        }
        self.progress = "Done."
    }
    
}
