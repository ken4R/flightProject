//
//  ViewController.swift
//  FlightCoreData
//
//  Created by Ken 4B on 21/07/2020.
//  Copyright © 2020 Ken 4B. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var result: [FlightLog] = []
    var totalAmount: Double = 0.0
    var weeklyValue: Double = 0.0
    var monthlyValue: Double = 0.0
    var yearValue: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        APIManager.shared.getStation(delegate: self)
        APIManager.shared.getMetar(delegate: self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        refreshData()
        tableView.register(UINib(nibName: "StandardTableViewCell", bundle: nil), forCellReuseIdentifier: "StandardTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
    }
    
    func daysBetwennCurrentDateAndDate(_ date: Date) -> Int {
        let calendar = NSCalendar.current
        let now = Date()
        let firstDate = calendar.startOfDay(for: date)
        let secondDate = calendar.startOfDay(for: now)
        let components = calendar.dateComponents([.day], from: firstDate, to: secondDate)
        return abs(components.day!)
    }

    
    

    fileprivate func convertingResult(days: Int, result: [FlightLog]) -> Double {
        return result.reduce(0, { (newResult, flightLog) -> Double in
            var newResultt = newResult
            if let createdDate = flightLog.createdAt, daysBetwennCurrentDateAndDate(createdDate) < days {
                newResultt += flightLog.flightTimeAmount
            }
            return newResultt
        })
    }
    
    func refreshData() {
        result = CoreDataManager.sharedInstance.fetchAllLogs()
        totalAmount = result.reduce(0, { (newResult, flightLog) -> Double in
            var newResultt = newResult
            newResultt += flightLog.flightTimeAmount
            return newResultt
        })
        weeklyValue = convertingResult(days: 7, result: result)
        monthlyValue = convertingResult(days: 28, result: result)
        yearValue = convertingResult(days: 365, result: result)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }
    @IBAction func addNewRecord(_ sender: Any) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewFlightViewController") as? AddNewFlightViewController else {
            return
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var title = ""
        var valueLab = ""
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandardTableViewCell", for: indexPath) as? StandardTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        if indexPath.section == 0 {
            title = "Total (hours) : "
            valueLab = String(totalAmount.minutes.inHours.value.rounded(toPlaces: 1))
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                title = "Last 7 days"
                valueLab = String(weeklyValue.minutes.inHours.value.rounded(toPlaces: 1))
            } else if indexPath.row == 1 {
                title = "Last 28 days"
                valueLab = String(monthlyValue.minutes.inHours.value.rounded(toPlaces: 1))
            } else {
                title = "Last 1 year"
                valueLab = String(yearValue.minutes.inHours.value.rounded(toPlaces: 1))
            }
            
        }
        cell.titleLabel.text = title
        cell.valueLabel.text = valueLab
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Trends"
        default:
            return "At a glance"
        }
        
    }
    
}

extension ViewController: APIWSDelegate {
    func didFinishRequest(endPoint: APIEndPoints, response: Data?) {
        if endPoint == .station {
            guard let result = response else { return}
            let decoder = JSONDecoder()
            let jsonData = try? decoder.decode(ResponseAPI.self, from: result)
            if let station = jsonData?.sample {
                if !CoreDataManager.sharedInstance.checkIfItemExist(item: station) {
                    CoreDataManager.sharedInstance.insertStationData(station: station)
                }
                
            }
        } else if endPoint == .metar {
            guard let result = response else { return}
            let decoder = JSONDecoder()
            let jsonData = try? decoder.decode(CommonResponAPI.self, from: result)
            if let metarResponse = jsonData?.sample {
                let alert = UIAlertController(title: "Metar", message: metarResponse.sanitized, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Done", style: .default) { (action) in
                    APIManager.shared.getTaf(delegate: self)
                }
                alert.addAction(yesAction)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                
                
            }
        } else if endPoint == .taf {
            guard let result = response else { return}
            let decoder = JSONDecoder()
            let jsonData = try? decoder.decode(Welcome.self, from: result)
            if let tafResponse = jsonData?.sample?.forecast?.first {
                let alert = UIAlertController(title: "TAF", message: tafResponse.sanitized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

