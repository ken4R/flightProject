//
//  AddNewFlightViewController.swift
//  FlightCoreData
//
//  Created by Braham Youssef on 7/23/20.
//  Copyright © 2020 Ken 4B. All rights reserved.
//

import UIKit

class AddNewFlightViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var amountHoursTextField: UITextField!
    @IBOutlet weak var amountMinsTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!

    var selectedDate: Date? = Date()
    var flightAmountHours: Double = 0.0
    var flightAmoubtMins: Double = 0.0
    var result: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountHoursTextField.tag = 10
        amountMinsTextField.tag = 20
        amountHoursTextField.delegate = self
        amountMinsTextField.delegate = self
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        // Do any additional setup after loading the view.
        
        
    }
    
    @objc
    func handleDatePicker(_ datePicker: UIDatePicker) {
        selectedDate = datePicker.date
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        result = flightAmountHours * 60 + flightAmoubtMins
        if result == 0.0 {
            let alert = UIAlertController(title: "Error", message: "Please enter inputs", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            CoreDataManager.sharedInstance.insertNewLog(log: result, date: selectedDate ?? Date())
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddNewFlightViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 10 {
            if let text = textField.text {
                if let intText = Int(text) , intText >= 24 {
                    let alert = UIAlertController(title: "Error", message: "Should enter less than 24 hours", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    flightAmountHours = Double(text) ?? 0.0
                }
            }
        }
        
        if textField.tag == 20 {
            if let text = textField.text {
                if let intText = Int(text) , intText >= 60 {
                    let alert = UIAlertController(title: "Error", message: "Should enter less than 60 minutes", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    flightAmoubtMins = Double(text) ?? 0.0
                }
            }
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 10 {
            if let text = textField.text {
                if let intText = Int(text) , intText >= 24 {
                    let alert = UIAlertController(title: "Error", message: "Should enter less than 24 hours", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    flightAmountHours = Double(text) ?? 0.0
                }
            }
        }
        
        if textField.tag == 20 {
            if let text = textField.text {
                if let intText = Int(text) , intText >= 60 {
                    let alert = UIAlertController(title: "Error", message: "Should enter less than 60 minutes", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    flightAmoubtMins = Double(text) ?? 0.0
                }
            }
        }
    }
}

