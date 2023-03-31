//
//  BuscaminasCollectionViewCell.swift
//  BuscaminasV1
//
//  Created by imac on 31/03/23.
//

import UIKit

class BuscaminasCollectionViewCell: UICollectionViewCell {
    var celda: Celdas?
    @IBOutlet weak var imvCelda: UIImageView!
    @IBOutlet weak var imvOverCelda: UIImageView!
    
    func setearCeldas(campo: Celdas) {
        celda = campo;
        
        imvOverCelda.image = UIImage(named: "cellover")
        imvCelda.image = UIImage(named: (celda?.imageName)!)
        imvCelda.alpha = 1
        
        // Ubicar las celdas que han sido descubiertas
        if (celda?.isOpen)! {
            imvOverCelda.alpha = 0
        }
        else {
            imvOverCelda.alpha = 1
        }
    }
    
    // Colocar banderas sobre las celdas
    func flag() {
        imvOverCelda.image = UIImage(named: "flag")
        if !(celda?.mina)! {
            imvCelda.image = UIImage(named: "wrongflag")
        }
    }
    
    // Quitar una bandera sobre una celda
    func unflag() {
        imvOverCelda.image = UIImage(named: "cellover")
        if !(celda?.mina)! {
            imvCelda.image = UIImage(named: (celda?.imageName)!)
        }
    }
    
    // Descubrir una celda
    func descubrirCelda() {
        imvOverCelda.alpha = 0
    }
    
    // Explosión de minas
    func explosion() {
        imvCelda.image = UIImage(named: "explodedmine")
        celda?.imageName = "explodedmine"
        descubrirCelda()
    }
    
    
}
