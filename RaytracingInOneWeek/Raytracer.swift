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
    var pixelColor : Color3 = Color3(e1: 0, e2: 0, e3: 0)
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
    
    func render() async {
        await MainActor.run{
            self.pixelArray = self.initPixels
        }
        
        for j in 0..<height{
            await MainActor.run{
                self.progress = "Scanlines remaining : \(height - j)"
            }

            self.scanlinePixels = []
            for i in 0..<width{
                pixelColor = Color3(e1: Double(Double(i) / Double(width - 1)), 
                                    e2: Double(Double(j) / Double(height - 1)),
                                    e3: 0)
                self.scanlinePixels.append(contentsOf: self.updateScanlinePixels(pixelColor: pixelColor))
            }

            // update screen
            await MainActor.run{
                self.pixelArray.replaceSubrange((self.width*j*4..<(self.width*j)*4+self.width), with: self.scanlinePixels)
            }

        }
        
        await MainActor.run{
            self.progress = "Done."
        }
    }
    
    func updateScanlinePixels(pixelColor: Color3, alpha: Double = 1) -> [UInt8]{
        let r : UInt8 = UInt8(clamping: Int( floor( pixelColor.x * 255.999 )))
        let g : UInt8 = UInt8(clamping: Int( floor( pixelColor.y * 255.999 )))
        let b : UInt8 = UInt8(clamping: Int( pixelColor.z  * 255.999 ))
        let a : UInt8 = UInt8(clamping: Int( alpha * 255.999 ))
        return [r,g,b,a]
    }
}
