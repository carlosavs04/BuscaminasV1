//
//  RecordsTableViewController.swift
//  BuscaminasV1
//
//  Created by imac on 14/04/23.
//

import UIKit

class RecordsTableViewController: UITableViewController {
    let records = Records.sharedData()
    var sortedJugadoresTiempo: [(key: String, value: Float)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        sortedJugadoresTiempo = records.jugadoresTiempo.sorted(by: { $0.value < $1.value })
        records.jugadoresTiempo = Dictionary(uniqueKeysWithValues: sortedJugadoresTiempo)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "celda")
        tableView.separatorStyle = .none // Quia los bordes de la tabla
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        let nombre = sortedJugadoresTiempo[indexPath.row].key
        let tiempo = sortedJugadoresTiempo[indexPath.row].value
        
        cell.textLabel?.text = nombre + " - " +  String(tiempo) + " s"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 26)
        cell.textLabel?.textAlignment = .center // Alinea el texto al centro
        
        cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) // Cambia el fondo de la celda a gris claro
        return cell
    }
}
