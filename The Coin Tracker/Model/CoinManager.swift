//
//  CoinManager.swift
//  The Coin Tracker
//
//  Created by Darragh Blake on 13/12/2019.
//  Copyright © 2019 Darragh Blake. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(bitcoinPrice: CoinData, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR",
                        "JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        // Defining the API call
        let urlString = baseURL + currency
        if let url = URL(string: urlString) {
            // Creating the URLSession
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        self.delegate?.didUpdatePrice(bitcoinPrice: bitcoinPrice, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinData? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
