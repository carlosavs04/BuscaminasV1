//
//  Records.swift
//  BuscaminasV1
//
//  Created by imac on 14/04/23.
//

import UIKit

class Records: NSObject {
    var jugadores: [String]
    var tiempo: [Float] = []
    static var records: Records!
    
    override init() {
        jugadores = []
        tiempo = []
    }
    
    static func sharedData()->Records {
        if records == nil {
            records = Records.init()
        }
        
        return records
    }
}
