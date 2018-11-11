//
//  AddHealthRecordTableViewController.swift
//  VitalTrack
//
//  Created by VIS Swimming on 4/11/18.
//  Copyright © 2018 TOR. All rights reserved.
//

import UIKit

class AddHealthRecordTableViewController: UITableViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heartRateTextField: UITextField!
    @IBOutlet weak var bloodPressureTextField: UITextField!
    @IBOutlet weak var oxygenTextField: UITextField!
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var additionalNotesTextField: UITextView!
    
    var newHealthRecord: Health?
    var isDatePickerHidden = false
    
    override func viewDidLoad() {
        updateSaveButton()
        isDatePickerHidden = true
        let midnightToday = Calendar.current.startOfDay(for: Date())
        datePicker.date = midnightToday
        let toolBar = UIToolbar()

        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        
        //Add done bar code lines here
        weightTextField.inputAccessoryView = toolBar
        heartRateTextField.inputAccessoryView = toolBar
        bloodPressureTextField.inputAccessoryView = toolBar
        oxygenTextField.inputAccessoryView = toolBar
        temperatureTextField.inputAccessoryView = toolBar
        additionalNotesTextField.inputAccessoryView = toolBar
        
        //add new health record
        if let newHealthData = newHealthRecord {
            dateLabel.text = newHealthData.Date
            weightTextField.text = newHealthData.Weight
            heartRateTextField.text = newHealthData.HeartRate
            bloodPressureTextField.text = newHealthData.BloodPressure
            temperatureTextField.text = newHealthData.Temp
            oxygenTextField.text = newHealthData.Oxygen
            additionalNotesTextField.text = newHealthData.Notes
        }
    }

//IB Actions

    @IBAction func datePickerChanged(_ sender: Any) {
        dateLabel.text = Health.dateFormatter.string(from:datePicker.date)
        updateSaveButton()
    }
    //Save Health Record

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let date = dateLabel.text
        let weight = weightTextField.text
        let heartRate = heartRateTextField.text
        let bloodPressure = bloodPressureTextField.text
        let temperature = temperatureTextField.text
        let oxygen = oxygenTextField.text
        let notes = additionalNotesTextField.text
        
        newHealthRecord = Health(Date: date!, Weight: weight!, Temp: temperature!, BloodPressure: bloodPressure!, Notes: notes!, Oxygen: oxygen!, HeartRate: heartRate!)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let pickerHeight = CGFloat(150)
        let hiddenHeight = CGFloat(0)
        let normalHeight = CGFloat(44)
        
        switch (indexPath) {
            
        case [0,1]:
            return !isDatePickerHidden ? pickerHeight: hiddenHeight
        case [6,0]:
            return pickerHeight
        default:
            return normalHeight
        }
    }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            switch (indexPath) {
            case [0,0]: isDatePickerHidden = !isDatePickerHidden
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
            default:
                break
            }
    }

    func updateSaveButton() {
        let recordDate = dateLabel.text ?? ""
        
        saveButton.isEnabled = !recordDate.isEmpty
        
    }
@objc func doneClicked() {
    view.endEditing(true)
}

}
