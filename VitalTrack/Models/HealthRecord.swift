//
//  HealthRecord.swift
//  VitalTrack
//
//  Created by VIS Swimming on 4/11/18.
//  Copyright © 2018 TOR. All rights reserved.
//

import Foundation
import UIKit

struct Health: Codable {
    var Date: String
    var Weight: String?
    var Temp: String?
    var BloodPressure: String?
    var Notes: String?
    var Oxygen: String?
    var HeartRate: String?
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func saveToFile(healthRecord: [Health]) {
        let encoder = PropertyListEncoder()
        let encodedParcels = try? encoder.encode(healthRecord)
        try? encodedParcels?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadList() -> [Health]? {
        let decoder = PropertyListDecoder()
        if
            let data = try? Data(contentsOf: archiveURL),
            let decodedHealthRecord = try? decoder.decode(Array<Health>.self, from: data)
        {
            return decodedHealthRecord
        } else {
            return nil
        }
    }
    static var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory
            .appendingPathComponent("healthRecords")
            .appendingPathExtension("plist")
        return archiveURL
    }
}

