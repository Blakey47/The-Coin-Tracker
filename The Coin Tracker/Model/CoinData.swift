//
//  CoinData.swift
//  The Coin Tracker
//
//  Created by Darragh Blake on 13/12/2019.
//  Copyright © 2019 Darragh Blake. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let last: Double
    let open: Open
    let averages: Averages
    let changes: Changes
    let volume: Double
}

struct Open: Decodable {
    let day: Double
    let week: Double
    let month: Double
}

struct Averages: Decodable {
    let day: Double
    let week: Double
    let month: Double
}

struct Changes: Decodable {
    let price: Price
    let percent: Percent
}

struct Price: Decodable {
    let day: Double
    let week: Double
    let month: Double
}

struct Percent: Decodable {
    let day: Double
    let week: Double
    let month: Double
}
