//
//  StringExtension.swift
//  WikiGeoPhotoNamesComparator
//
//  Created by Андрей Рожков on 08.03.17.
//  Copyright © 2017 AndreyRozhkov. All rights reserved.
//

import Foundation

extension String {
    
    func countInstances(of stringToFind: String) -> Int {
        var stringToSearch = self
        var count = 1
        repeat {
            guard let foundRange = stringToSearch.range(of: stringToFind, options: .diacriticInsensitive)
                else { break }
            stringToSearch = stringToSearch.replacingCharacters(in: foundRange, with: "")
            count += 1
            
        } while (true)
        
        return count
    }
    
    func cutFileWordFromBeginning() -> (String) {
        let startIndex = self.index(self.startIndex, offsetBy: 5)
        return self.substring(from: startIndex)
    }
}
