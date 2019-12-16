//
//  ViewController.swift
//  The Coin Tracker
//
//  Created by Darragh Blake on 11/12/2019.
//  Copyright © 2019 Darragh Blake. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var currenySymbol: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var lastPrice: UILabel!
    @IBOutlet weak var mainPercentChange: UILabel!
    
    @IBOutlet weak var dailyOpen: UILabel!
    @IBOutlet weak var weeklyOpen: UILabel!
    @IBOutlet weak var monthlyOpen: UILabel!
    
    @IBOutlet weak var dailyAverage: UILabel!
    @IBOutlet weak var weeklyAverage: UILabel!
    @IBOutlet weak var monthlyAverage: UILabel!
    
    @IBOutlet weak var dailyChange: UILabel!
    @IBOutlet weak var weeklyChange: UILabel!
    @IBOutlet weak var monthlyChange: UILabel!
    
    @IBOutlet weak var dailyPercentChange: UILabel!
    @IBOutlet weak var weeklyPercentChange: UILabel!
    @IBOutlet weak var monthlyPercentChange: UILabel!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        
        coinManager.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func setupUI() {
        setupPickerView()
    }
    
    func setupPickerView() {
        menuView.layer.cornerRadius = 30
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        if let currency = self.currenySymbol.text {
            coinManager.getCoinPrice(for: currency)
        }
    }
    
    @IBAction func toggleMenuButton(_ sender: Any) {
        if menuView.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.menuView.backgroundColor = .white
                self.menuView.transform = CGAffineTransform(translationX: 0, y: -283)
                self.menuButton.setBackgroundImage(UIImage(systemName: "minus.circle"), for: UIControl.State.normal)
                self.menuButton.transform = CGAffineTransform(translationX: 0, y: -290)
            }) { (true) in
            }
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.menuView.transform = .identity
                self.menuView.backgroundColor = .clear
                self.menuButton.transform = .identity
                self.menuButton.setBackgroundImage(UIImage(systemName: "plus.circle"), for: UIControl.State.normal)
            }) { (true) in
            }
        }
    }
}


// MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    
    func didUpdatePrice(bitcoinPrice: CoinData, currency: String) {
        
        let currentCurrentSymbol = getSymbol(forCurrenyCode: currency)
        
        DispatchQueue.main.async {
            
            self.currenySymbol.text = currency
            self.timeStamp.text = bitcoinPrice.display_timestamp
            self.lastPrice.text = "\(currentCurrentSymbol ?? "$")\(String(bitcoinPrice.last))"
            
            self.mainPercentChange.text = "\(String(bitcoinPrice.changes.percent.day))%"
            self.handleTextColour(label: self.mainPercentChange, value: bitcoinPrice.changes.percent.day)
            
            self.dailyOpen.text = "\(currentCurrentSymbol ?? "$")\(String(bitcoinPrice.open.day))"
            self.weeklyOpen.text = "\(currentCurrentSymbol ?? "$")\(String(bitcoinPrice.open.week))"
            self.monthlyOpen.text = "\(currentCurrentSymbol ?? "$")\(String(bitcoinPrice.open.month))"
            
            self.dailyAverage.text = "\(currentCurrentSymbol ?? "$")\(String(bitcoinPrice.averages.day))"
            self.weeklyAverage.text = "\(currentCurrentSymbol ?? "$")\(String(bitcoinPrice.averages.week))"
            self.monthlyAverage.text = "\(currentCurrentSymbol ?? "$")\(String(bitcoinPrice.averages.month))"
            
            self.dailyChange.text = String(bitcoinPrice.changes.price.day)
            self.handleTextColour(label: self.dailyChange, value: bitcoinPrice.changes.price.day)
            self.weeklyChange.text = String(bitcoinPrice.changes.price.week)
            self.handleTextColour(label: self.weeklyChange, value: bitcoinPrice.changes.price.week)
            self.monthlyChange.text = String(bitcoinPrice.changes.price.month)
            self.handleTextColour(label: self.monthlyChange, value: bitcoinPrice.changes.price.month)
            
            self.dailyPercentChange.text = "\(String(bitcoinPrice.changes.percent.day))%"
            self.handleTextColour(label: self.dailyPercentChange, value: bitcoinPrice.changes.percent.day)
            self.weeklyPercentChange.text = "\(String(bitcoinPrice.changes.percent.week))%"
            self.handleTextColour(label: self.weeklyPercentChange, value: bitcoinPrice.changes.percent.week)
            self.monthlyPercentChange.text = "\(String(bitcoinPrice.changes.percent.month))%"
            self.handleTextColour(label: self.monthlyPercentChange, value: bitcoinPrice.changes.percent.month)
            
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func handleTextColour(label: UILabel, value: Double) {
        if value > 0 {
            label.textColor = .systemGreen
        } else if value < 0 {
            label.textColor = .systemRed
        } else {
            label.textColor = .systemTeal
        }
    }
    
    func getSymbol(forCurrenyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
}

//MARK: - UIPickerView DataSource & Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return coinManager.currencyArray.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return coinManager.currencyArray[row]
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          let selectedCurrency = coinManager.currencyArray[row]
          coinManager.getCoinPrice(for: selectedCurrency)
      }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: coinManager.currencyArray[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
    }
}


