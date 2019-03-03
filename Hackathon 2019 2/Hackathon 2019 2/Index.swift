//
//  Index.swift
//  Hackathon 2019 2
//
//  Created by Hanzhe Chen on 3/2/19.
//  Copyright © 2019 Hanzhe Chen. All rights reserved.
//

import Foundation

class Index: NSObject{
    
    private var arrayIndex: Int = 0
    
    func getArrayIndex() -> Int {
        return arrayIndex;
    }
    
    func setArrayIndex(arrayIndex: Int){
        self.arrayIndex = arrayIndex
    }
}
