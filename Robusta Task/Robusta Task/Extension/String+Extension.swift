//
//  String+Extension.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 20/11/2021.
//

import Foundation

extension String {
    
    func descriptiveDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"

        if let newDate = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: newDate)
        }
        return ""
    }
}
