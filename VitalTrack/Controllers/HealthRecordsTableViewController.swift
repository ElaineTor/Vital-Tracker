//
//  HealthRecordsTableViewController.swift
//  VitalTrack
//
//  Created by VIS Swimming on 4/11/18.
//  Copyright © 2018 TOR. All rights reserved.
//

import UIKit

class HealthRecordsTableViewController: UITableViewController {

        var healthRecords : [Health] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.leftBarButtonItem = self.editButtonItem
            if let savedHealth = Health.loadList() {
                self.healthRecords = savedHealth
            }
        }
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return healthRecords.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "healthCell") else {
                fatalError("Count not dequeue a cell")
            }
            
            let health = healthRecords[indexPath.row]
            
            cell.textLabel?.text = health.Date
            cell.detailTextLabel?.text = "Weight: \(health.Weight!)kg, BP: \(health.BloodPressure!), HR: \(health.HeartRate!), Temp: \(health.Temp!)"
            
            return cell
        
        }
        
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                healthRecords.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                Health.saveToFile(healthRecord: healthRecords)
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "editRecord" {
                let addHealthTableViewController = segue.destination as! AddHealthRecordTableViewController
                let indexPath = tableView.indexPathForSelectedRow!
                let selectedRecord = healthRecords[indexPath.row]
                addHealthTableViewController.newHealthRecord = selectedRecord
            }
        }
        
        @IBAction func unwindToHealthList(segue: UIStoryboardSegue) {
            
            let sourceViewController = segue.source as! AddHealthRecordTableViewController
            
            
            if let healthSave = sourceViewController.newHealthRecord, segue.identifier == "saveUnwind" {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    healthRecords[selectedIndexPath.row] = healthSave
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    tableView.reloadData()
                } else {
                    let newIndexPath = IndexPath(row: healthRecords.count, section: 0)
                    healthRecords.append(healthSave)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                    tableView.reloadData()
                }
            } else if segue.identifier == "deleteUnwind" {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    healthRecords.remove(at: selectedIndexPath.row)
                    tableView.deleteRows(at: [selectedIndexPath], with: .automatic)
                    tableView.reloadData()
                }
            }
            
            Health.saveToFile(healthRecord: healthRecords)
}

}
