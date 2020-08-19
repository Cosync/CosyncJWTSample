//
//  StringExtension.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/7/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import Foundation

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
