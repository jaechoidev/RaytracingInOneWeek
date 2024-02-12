//
//  ContentView.swift
//  RaytracingInOneWeek
//
//  Created by Jae Choi on 2024-02-10.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State var width = "100"
    @State var height = "100"
    @StateObject var raytracer = Raytracer(width: 100, height: 100)
    
    var body: some View {
        VStack{
            HStack{
                Text("Width")
                TextField(text: $width){}
            }
            HStack{
                Text("Height")
                TextField(text: $height){}
            }
            Spacer()
            PixelsToImage(raytracer: raytracer)
            Button(action: {
                Task{
                    await raytracer.render()
                }
                raytracer.forceUpdate()
            }, label: {
                Text("Render")
            })
            Text(raytracer.progress)
        }
        .frame(width: 550, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .onChange(of: [width, height]) {
            raytracer.width = Int(width) ?? 100
            raytracer.height = Int(height) ?? 100
            raytracer.refreshImage()
        }
    }
}

struct PixelsToImage: View {
    @StateObject var raytracer : Raytracer
    
    var body: some View {
        if let nsImage = createImage() {
            Image(nsImage: nsImage)
                .resizable()
                .frame(width: CGFloat(raytracer.width), height: CGFloat(raytracer.height))
        } else {
            Text("Failed to create image")
        }
    }
    
    func createImage() -> NSImage? {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        
        guard let providerRef = CGDataProvider(data: Data(raytracer.pixelArray) as CFData) 
        else { return nil }
        
        guard let cgim = CGImage(
            width: raytracer.width,
            height: raytracer.height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: raytracer.width * 4,
            space: rgbColorSpace,
            bitmapInfo: CGBitmapInfo(rawValue: bitmapInfo),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        ) else { return nil }

        let cgImageWidth = cgim.width
        let cgImageHeight = cgim.height
        let screenScale = NSScreen.main?.backingScaleFactor ?? 1.0
        let imageSize = NSSize(width: CGFloat(cgImageWidth) / screenScale, height: CGFloat(cgImageHeight) / screenScale)
        return NSImage(cgImage: cgim, size: imageSize)
    }
}

#Preview {
    ContentView()
}
