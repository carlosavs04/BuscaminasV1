//
//  MainViewController.swift
//  BuscaminasV1
//
//  Created by imac on 13/04/23.
//

import UIKit
import AVFoundation
class MainViewController: UIViewController {

    
     @IBOutlet weak var btnplay: UIButton!
    @IBOutlet weak var btnrecords: UIButton!
    
    var reproductor = AVAudioPlayer()
    
    override func viewWillAppear(_ animated: Bool) {
        musica()
        reproductor.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnplay.layer.shadowColor = UIColor.black.cgColor
        btnplay.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnplay.layer.shadowRadius = 9.0
        btnplay.layer.shadowOpacity = 0.5
        btnplay.layer.masksToBounds = false
        
        btnrecords.layer.shadowColor = UIColor.black.cgColor
        btnrecords.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnrecords.layer.shadowRadius = 9.0
        btnrecords.layer.shadowOpacity = 0.5
        btnrecords.layer.masksToBounds = false
    }
    

    func musica() {
        if let rutaTrack = Bundle.main.path(forResource: "(8-Bit) Paradise City- Guns N' Roses", ofType: "mp3") {
            let urlTrack = URL(fileURLWithPath: rutaTrack)
            do {
                try reproductor = AVAudioPlayer(contentsOf: urlTrack)
            }
            catch {
                let error = UIAlertController(title: "ERROR", message: "No se pudó cargar adecuadamente la canción", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Aceptar", style: .default)
                error.addAction(ok)
                self.present(error, animated: true)
            }
        } else {
            let error = UIAlertController(title: "ERROR", message: "No se pudó cargar adecuadamente la canción", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            error.addAction(ok)
            self.present(error, animated: true)
        }
    }
    
    
    @IBAction func pauseMusic(_ sender: UIButton) {
        if reproductor.isPlaying {
            reproductor.pause()
        }
    }
}
