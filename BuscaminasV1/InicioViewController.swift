//
//  InicioViewController.swift
//  BuscaminasV1
//
//  Created by imac on 30/03/23.
//

import UIKit

class InicioViewController: UIViewController {

    var minefield = [Minefield]()
    var model = MinesweeperModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flags = 0
    var flagMode = false
    var gameOver = false
    var newGameStarted = false
    
    var numberOfCells = 64
    var numberOfMines = 10
    var minesLeft = 10
    var n = 8
    var nextGame = [64, 10]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func newGame() {
        
        // Set up new minefield
        minefield = model.getMinefield(numberOfCells: numberOfCells, numberOfMines: numberOfMines)
        
        // Sets insets for collection view to properly layout minefield grid
        let flow = UICollectionViewFlowLayout()
        
        // Calculate horizontal and vertical insets
        let horInsets = (view.frame.size.width - CGFloat(24 * n)) / CGFloat(2)
        let verInsets = (view.frame.size.height - 210 - CGFloat(24 * n)) / CGFloat(2)
        
        // Apply values
        flow.sectionInset = UIEdgeInsets(top: verInsets - 30, left: horInsets, bottom: verInsets, right: horInsets)
        flow.itemSize = CGSize(width: 24, height: 24)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        collectionView.setCollectionViewLayout(flow, animated: false)
        
        // Reloads collection view with new data if new game
        if newGameStarted {
            collectionView.reloadData()
        }
        
        // Set delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create stopwatch
        self.stopwatch = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(stopwatchElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(stopwatch!, forMode: .commonModes)
    }

}
