//
//  Ray.swift
//  RaytracingInOneWeek
//
//  Created by Jae Choi on 2024-02-11.
//

class Ray {
    private var orig: Point3
    private var dir: Vec3

    init() {
        self.orig = Point3(e1: 0, e2: 0, e3: 0)
        self.dir = Vec3(e1: 0, e2: 0, e3: -1)
    }

    init(origin: Point3, direction: Vec3) {
        self.orig = origin
        self.dir = direction
    }
    
    func origin() -> Point3 {
        return self.orig
    }
    
    func direction() -> Vec3 {
        return self.dir
    }

    func at(t: Double) -> Point3 {
        return self.orig + t * self.dir
    }
    
}
