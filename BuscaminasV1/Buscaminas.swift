//
//  Buscaminas.swift
//  BuscaminasV1
//
//  Created by imac on 31/03/23.
//

import UIKit

class Buscaminas: NSObject {
    var celdas = [Celdas]()
    var n = 0
    
    func getCelda(numeroCeldas: Int, numeroMinas: Int) -> [Celdas] {
        n = Int(sqrt(Double(numeroCeldas)))
        
        //Genera las minas
        for _ in 1...numeroMinas {
            let field = Celdas()
            field.mina = true
            field.imageName = "mine"
            celdas.append(field)
        }
        
        //Genera las celdas restantes en el tablero
        for _ in 1...(numeroCeldas - numeroMinas) {
            let field = Celdas()
            field.vecinoDeMina = 0
            field.imageName = "blank"
            celdas.append(field)
        }
        
        //Distribuye las minas en el tablero
        for i in 0..<numeroCeldas {
            let randomNumber = Int(arc4random_uniform(UInt32(numeroCeldas)))
            let temp = celdas[randomNumber]
            celdas[randomNumber] = celdas[i]
            celdas[i] = temp
        }
        
        // Calcular el número de celdas vecinas a las minas
        for i in 0..<numeroCeldas {
            if celdas[i].mina {
                contarCeldas(row: i / n - 1, col: i % n - 1)
                contarCeldas(row: i / n - 1, col: i % n)
                contarCeldas(row: i / n - 1, col: i % n + 1)
                contarCeldas(row: i / n, col: i % n - 1)
                contarCeldas(row: i / n, col: i % n + 1)
                contarCeldas(row: i / n + 1, col: i % n - 1)
                contarCeldas(row: i / n + 1, col: i % n)
                contarCeldas(row: i / n + 1, col: i % n + 1)
            }
        }
        
        return celdas
    }
    
    func contarCeldas(row: Int, col: Int) {
        if (row > -1 && row < n && col > -1 && col < n && !celdas[row * n + col].mina) {
            let field = celdas[row * n + col]
            field.vecinoDeMina! += 1
            field.imageName = "\(field.vecinoDeMina!)"
        }
    }

}
