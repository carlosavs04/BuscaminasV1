//
//  Records.swift
//  BuscaminasV1
//
//  Created by imac on 14/04/23.
//

import UIKit

class Records: NSObject {
    var jugadoresTiempo: [String: Float]
    static var records: Records!
    
    override init()
    {
        jugadoresTiempo = ["Carlos": 50.00, "Pablo": 60.00, "Jhon": 70.00, "James": 80.00, "Peter": 90.00]
    }
    
    static func sharedData()->Records {
        if records == nil {
            records = Records.init()
        }
        
        return records
    }
}
