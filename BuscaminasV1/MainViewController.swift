//
//  MainViewController.swift
//  BuscaminasV1
//
//  Created by imac on 13/04/23.
//

import UIKit

class MainViewController: UIViewController {

    
     @IBOutlet weak var btnplay: UIButton!
    
    
    @IBOutlet weak var btnrecords: UIButton!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
