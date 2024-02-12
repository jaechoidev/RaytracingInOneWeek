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
    @Published var width: Int
    @Published var height: Int
    
    init(width: Int, height: Int){
        self.width = width
        self.height = height

        self.pixelArray = Array(repeating: 0, count: self.width*self.height*4)
        self.initPixels = self.pixelArray
    }
    
    func forceUpdate() {
        self.objectWillChange.send()
    }
    
    func refreshImage() {
        self.pixelArray = Array(repeating: 0, count: self.width*self.height*4)
        self.initPixels = self.pixelArray
    }
    
    func render() async {
        await MainActor.run{
            self.pixelArray = self.initPixels
        }
        
        // Camera
        let focalLength : Double = 1.0
        let viewportHeight : Double = 2.0
        let viewportWidth = viewportHeight * Double(Double(width) / Double(height))
        let cameraCenter: Point3 = Point3(e1: 0, e2: 0, e3: 0)
        
        // calculate the vectors across the horizontal and down the vertical viewport edges.
        let viewportU : Vec3 = Vec3(e1: viewportWidth, e2: 0, e3: 0)
        let viewportV : Vec3 = Vec3(e1: 0, e2: viewportHeight, e3: 0)

        // calculate the horizontal and vertical delta vectors from pixel to pixel
        let pixelDeltaU = viewportU / Double(self.width)
        let pixelDeltaV = viewportV / Double(self.height)
        
        // calculate the location of the upper left pixel
        let viewportUpperLeft = cameraCenter - Vec3(e1:0, e2:0, e3:focalLength) - viewportU / 2.0 - viewportV / 2.0
        let pixel00Loc = viewportUpperLeft + 0.5 * (pixelDeltaU + pixelDeltaV)

        // Render
        for j in 0..<height{
            await MainActor.run{
                self.progress = "Scanlines remaining : \(height - j)"
            }

            self.scanlinePixels = []
            for i in 0..<width{
                let pixelCenter = pixel00Loc + (Double(i) * pixelDeltaU) + (Double(j) * pixelDeltaV)
                let rayDir = pixelCenter - cameraCenter
                let r = Ray(origin: cameraCenter, direction: rayDir)
                pixelColor = rayColor(r)
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
    
    func rayColor(_ ray : Ray) -> Color3 {
        let unitDir = Vec3.unit(v1: ray.direction())
        let a = 0.5 * (unitDir.y + 1.0)
        return (1.0 - a) * Color3(e1:1.0, e2:1.0, e3:1.0) + a * Color3(e1:0.5, e2:0.7, e3:1.0)
    }
    
    func updateScanlinePixels(pixelColor: Color3, alpha: Double = 1) -> [UInt8]{
        let r : UInt8 = UInt8(clamping: Int( floor( pixelColor.x * 255.999 )))
        let g : UInt8 = UInt8(clamping: Int( floor( pixelColor.y * 255.999 )))
        let b : UInt8 = UInt8(clamping: Int( pixelColor.z  * 255.999 ))
        let a : UInt8 = UInt8(clamping: Int( alpha * 255.999 ))
        return [r,g,b,a]
    }
}
