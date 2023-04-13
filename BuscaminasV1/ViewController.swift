//
//  ViewController.swift
//  BuscaminasV1
//
//  Created by imac on 30/03/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var celdas = [Celdas]()
    var buscaminas = Buscaminas()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnFlag: UIButton!
    @IBOutlet weak var lblTiempoRecord: UILabel!
    
    var numeroDeCeldas = 64
    var numeroDeMinas = 10
    var minasRestantes = 10
    var n = 8
    var proximoJuego = [64, 10]
    var flags = 0
    var flagMode = false
    var gameOver = false
    var nuevoJuego = false
    var tiempoRecord:Timer?
    var millis:Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        iniciarJuego()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iniciarJuego() {
        // Iniciar un nuevo juego
        celdas = buscaminas.getCelda(numeroCeldas: numeroDeCeldas, numeroMinas: numeroDeMinas)
        
        let flow = UICollectionViewFlowLayout()
        let horizontalInsets = (view.frame.size.width - CGFloat(24 * n)) / CGFloat(2)
        let verticalInsets = (view.frame.size.height - 210 - CGFloat(24 * n)) / CGFloat(2)
        flow.sectionInset = UIEdgeInsets(top: verticalInsets - 30, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
        flow.itemSize = CGSize(width: 24, height: 24)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        collectionView.setCollectionViewLayout(flow, animated: false)
        
        // Reiniciar la vista si se inicia un nuevo juego
        if nuevoJuego {
            collectionView.reloadData()
            
        }
        
        // Setear delegados
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Crear el contador
        self.tiempoRecord = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(tiempoTranscurrido), userInfo: nil, repeats: true)
        RunLoop.main.add(tiempoRecord!, forMode: .common)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numeroDeCeldas
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "CeldaBuscaminas", for: indexPath) as! BuscaminasCollectionViewCell
        let field = celdas[indexPath.row]
        celda.setearCeldas(campo: field)
        return celda
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let celda = collectionView.cellForItem(at: indexPath) as! BuscaminasCollectionViewCell
        let field = celdas[indexPath.row]
        
        // Evitar que cuando haya game over el jugador pueda seguir jugando
        if gameOver {
            return
        }
        
        if field.celdaAbierta {
            if field.vecinoDeMina == 0 {
                cambiarFlagMode()
            } else {
                // Descubrir todas las celdas cercanas si todas las minas cercanas están con las banderas correctas
                let rowNum = row(indexPath.row)
                let colNum = col(indexPath.row)
                let rows = [rowNum - 1, rowNum - 1, rowNum - 1, rowNum, rowNum, rowNum + 1, rowNum + 1, rowNum + 1]
                let cols = [colNum - 1, colNum, colNum + 1, colNum - 1, colNum + 1, colNum - 1, colNum, colNum + 1]
                flags = 0
                
                // Checar si las minas cercanas tienen las banderas correctas
                var minasBanderas = true
                
                for i in 0...7 {
                    minasBanderas = minasBanderas && minasBanderasCorrectas(row: rows[i], col: cols[i])
                }
                
                // Descubrir las celdas cercanas si no contienen minas
                if minasBanderas {
                    for i in 0...7 {
                        descubrirCeldasVecinas(row: rows[i], col: cols[i])
                    }
                } else if flags >= field.vecinoDeMina! {
                    gameOver(victoria: false)
                }
            }
        } else if flagMode {
            if !field.tieneBandera {
                // Si la celda no tiene bandera ni está abierta, se le pone bandera
                celda.flag()
                field.tieneBandera = true
                
                // Si la celda con bandera contiene una mina, el número de minas debe disminuir
                if field.mina {
                    minasRestantes -= 1
                }
                
                // Si todas las minas tienen bandera, el juego termina y el jugador gana
                if minasRestantes == 0 {
                    gameOver(victoria: true)
                }
            } else {
                // Si la celda tiene bandera, se le quita la bandera
                celda.unflag()
                field.tieneBandera = false
                
                // Si la celda sin bandera contiene una mina, el número de minas debe de aumentar
                if field.mina {
                    minasRestantes += 1
                }
            }
        } else {
            if !field.mina {
                if field.vecinoDeMina == 0 {
                    // Si la celda no contiene nada, se abren todas las celdas cercanas
                    descubrirVacias(row: indexPath.row / n, col: indexPath.row % n)
                } else {
                    // Se descubre la celda y se marca como abierta
                    celda.descubrirCelda()
                    field.celdaAbierta = true
                }
            } else {
                // Si la celda descubierta contiene una mina, el juego termina y el jugador pierde
                celda.explosion()
                gameOver(victoria: false)
            }
        }
    }
    
    // Checar si la celda con bandera realmente contiene una mina
    func minasBanderasCorrectas(row: Int, col: Int) -> Bool {
        if validate(row: row, col: col) {
            let field = celdas[index(row, col)]
            
            if field.tieneBandera {
                flags += 1
            }
            
            if field.celdaAbierta {
                return true
            } else if field.mina {
                return field.tieneBandera
            } else {
                return !field.tieneBandera
            }
        }
        
        return true
    }
    
    // Descubrir todas las celdas cercanas si no son minas si es que todas las minas cercanas tienen banderas
    func descubrirCeldasVecinas(row: Int, col: Int) {
        if validate(row: row, col: col) {
            let celda = collectionView.cellForItem(at: IndexPath(row: index(row, col), section: 0)) as! BuscaminasCollectionViewCell
            let field = celdas[index(row, col)]
            
            if (!field.mina) {
                if field.vecinoDeMina == 0 {
                    descubrirVacias(row: row, col: col)
                } else {
                    celda.descubrirCelda()
                    field.celdaAbierta = true
                }
            }
        }
    }
    
    // Descubrir celdas adyacentes a las minas
    func descubrirVacias(row: Int, col: Int) {
        if validate(row: row, col: col) {
            let celda = collectionView.cellForItem(at: IndexPath(row: index(row, col), section: 0)) as! BuscaminasCollectionViewCell
            let field = celdas[index(row, col)]
            
            if !field.celdaAbierta && !field.mina {
                celda.descubrirCelda()
                field.celdaAbierta = true
                
                if field.vecinoDeMina == 0 {
                    // Descubrir si las celdas están vacías
                    descubrirVacias(row: row - 1, col: col)
                    descubrirVacias(row: row + 1, col: col)
                    descubrirVacias(row: row, col: col - 1)
                    descubrirVacias(row: row, col: col + 1)
                    
                    // Continuar descubriendo las celdas vacías de la esquina
                    descubrirVaciasEsquina(row: row - 1, col: col - 1)
                    descubrirVaciasEsquina(row: row - 1, col: col + 1)
                    descubrirVaciasEsquina(row: row + 1, col: col - 1)
                    descubrirVaciasEsquina(row: row + 1, col: col + 1)
                    
                    // Descubrir solo las celdas vecinas de las esquinas si están vacías
                    descubrirVecinosEsquina(row: row - 1, col: col - 1)
                    descubrirVecinosEsquina(row: row - 1, col: col + 1)
                    descubrirVecinosEsquina(row: row + 1, col: col - 1)
                    descubrirVecinosEsquina(row: row + 1, col: col + 1)
                }
            }
        }
    }
    
    // Descubrir celdas vacías de la esquina
    func descubrirVaciasEsquina(row: Int, col: Int) {
        if validate(row: row, col: col) {
            let field = celdas[index(row, col)]
            
            if !field.celdaAbierta && field.vecinoDeMina == 0 {
                descubrirVacias(row: row, col: col)
            }
        }
    }
    
    // Descubrir las celdas vecinas de las esquina que estén vacías
    func descubrirVecinosEsquina(row: Int, col: Int) {
        if validate(row: row, col: col) {
            let celda = collectionView.cellForItem(at: IndexPath(row: index(row, col), section: 0)) as! BuscaminasCollectionViewCell
            let field = celdas[index(row, col)]
            
            if !field.celdaAbierta && !field.mina && field.vecinoDeMina! > 0 {
                celda.descubrirCelda()
                field.celdaAbierta = true
            }
        }
    }
    
    // Cambiar a flag mode
    func cambiarFlagMode() {
        flagMode = !flagMode
        
        if flagMode {
            btnFlag.setImage(UIImage(named: "flaggbuttontoggled"), for: .normal)
        }
        else {
            btnFlag.setImage(UIImage(named: "flagbutton"), for: .normal)
        }
    }
    
    func gameOver(victoria: Bool) {
        // Detener el contador
        self.tiempoRecord?.invalidate()
        
        // Cambiar game over a true para que el juego se detenga
        gameOver = true
        
        // Setar las variables del mensaje que cambiará según se gane o se pierda
        var title = ""
        var message = ""
        
        if victoria {
            // Si gana se abren todas las celdas que no sean minas
            for i in 0..<celdas.count {
                if !celdas[i].celdaAbierta && !celdas[i].mina {
                    let celda = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! BuscaminasCollectionViewCell
                    celda.descubrirCelda()
                }
            }
            
            title = "¡Felicidades, has ganado!"
            let segundos = String(format: "%.2f", millis/1000)
            message = "Terminaste en \(segundos) segundos"
        } else {
            // Si pierde se abren todas las minas que no tengan bandera y se muestran todas las celdas que tenían banderas incorrectas
            for i in 0..<celdas.count {
                if (celdas[i].mina && !celdas[i].tieneBandera) || (!celdas[i].mina && celdas[i].tieneBandera) {
                    let celda = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! BuscaminasCollectionViewCell
                    celda.descubrirCelda()
                }
            }
            
            title = "¡BOOM!"
            message = "Has perdido"
        }
        
        // Mostrar el mensaje al finalizar la partida
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
        self.tiempoRecord?.invalidate()
    }
    
    
    // Empeze un juego cuando se toque el botón new game
    @IBAction func newGame(_ sender: Any) {
        numeroDeCeldas = proximoJuego[0]
        numeroDeMinas = proximoJuego[1]
        minasRestantes = numeroDeMinas
        n = Int(sqrt(Double(numeroDeCeldas)))
        
        nuevoJuego = true
        gameOver = false
        millis = 0
        
        buscaminas = Buscaminas()
        iniciarJuego()
    }
    
    // Cambiar a flag mode cuando se toque el botón
    
    @IBAction func flagModeCambiar(_ sender: Any) {
        cambiarFlagMode()
    }
    
    @objc func tiempoTranscurrido() {
        millis += 1
        let segundos = String(format: "%.2f", millis/1000)
        lblTiempoRecord.text = "Tiempo\n\(segundos)"
    }
    
    
    // Convertir una row y col en index
    func index(_ row: Int, _ col: Int) -> Int {
        return row * n + col
    }
    
    // Convertir index a row
    func row(_ index: Int) -> Int {
        return index / n
    }
    
    // Convetir index a col
    func col(_ index: Int) -> Int {
        return index % n
    }
    
    // Validar rows y cols
    func validate(row: Int, col: Int) -> Bool {
        if row > -1 && row < n && col > -1 && col < n {
            return true
        }
        
        return false
    }
}

