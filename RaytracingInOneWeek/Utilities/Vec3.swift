//
//  vec3.swift
//  RaytracingInOneWeek
//
//  Created by Jae Choi on 2024-02-11.
//

import Foundation

class Vec3 : CustomStringConvertible{
    var e: [Double] = [0,0,0]
    
    init(e1: Double, e2: Double, e3: Double){
        self.e = [e1,e2,e3]
    }
    
    var x: Double {
        return e[0]
    }
    var y: Double {
        return e[1]
    }
    var z: Double {
        return e[2]
    }
    
    var description: String {
        return "vec3(x: \(e[0]), y: \(e[1]), z: \(e[2]))"
    }
    
    subscript(index: Int) -> Double {
        get{ e[index] }
        set{
            guard index < e.count else { return }
            e[index] = newValue
        }
    }
    
    static prefix func - (v1: Vec3) -> Vec3 {
        return Vec3(e1: -Double(v1.x), e2: -Double(v1.y), e3: -Double(v1.z))
    }
    
    static func += (_ lhs: Vec3, _ rhs: Vec3) {
        lhs.e[0] += rhs.x
        lhs.e[1] += rhs.y
        lhs.e[2] += rhs.z
    }
    
    static func -= (_ lhs: Vec3, _ rhs: Vec3) {
        lhs.e[0] -= rhs.x
        lhs.e[1] -= rhs.y
        lhs.e[2] -= rhs.z
    }
    
    static func *= (_ lhs: Vec3, _ rhs: Double) {
        lhs.e[0] *= rhs
        lhs.e[1] *= rhs
        lhs.e[2] *= rhs
    }
    
    static func /= (_ lhs: Vec3, _ rhs: Double) {
        lhs.e[0] *= 1/rhs
        lhs.e[1] *= 1/rhs
        lhs.e[2] *= 1/rhs
    }

    static func + (_ lhs: Vec3, _ rhs: Vec3) -> Vec3{
        return Vec3(e1: lhs.x + rhs.x, e2:lhs.y + rhs.y, e3:lhs.z + rhs.z)
    }
    
    static func - (_ lhs: Vec3, _ rhs: Vec3) -> Vec3{
        return Vec3(e1: lhs.x - rhs.x, e2:lhs.y - rhs.y, e3:lhs.z - rhs.z)
    }

    static func * (_ lhs: Vec3, _ rhs: Vec3) -> Vec3{
        return Vec3(e1: lhs.x * rhs.x, e2:lhs.y * rhs.y, e3:lhs.z * rhs.z)
    }

    static func * (_ lhs: Double, _ rhs: Vec3) -> Vec3{
        return Vec3(e1: lhs * rhs.x, e2:lhs * rhs.y, e3:lhs * rhs.z)
    }

    static func * (_ lhs: Vec3 , _ rhs: Double) -> Vec3{
        return rhs * lhs
    }
   
    static func / (_ lhs: Vec3 , _ rhs: Double) -> Vec3{
        return (1/rhs) * lhs
    }
    
    static func dot (_ lhs: Vec3 , _ rhs: Vec3) -> Double{
        return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
    }

    static func cross (_ lhs: Vec3 , _ rhs: Vec3) -> Vec3{
        return Vec3(e1: lhs.y * rhs.z - lhs.z * rhs.y,
                    e2: lhs.z * rhs.x - lhs.x * rhs.z,
                    e3: lhs.x * rhs.y - lhs.y * rhs.x)
    }
    
    static func unit (v1: Vec3) -> Vec3{
        return v1 / v1.length()
    }
    
    func length() -> Double {
        return sqrt(self.length_squared())
    }
    
    func length_squared() -> Double {
        return e[0]*e[0] + e[1]*e[1] + e[2]*e[2]
    }
}

typealias Point3 = Vec3
typealias Color3 = Vec3
