//
//  SandwichStore.swift
//  Sandwiches
//
//  Created by wjn on 2020/7/1.
//

import Foundation

class SandwichStore: ObservableObject {
    @Published var sandwiches: [Sandwich]
    
    init(sandwiches: [Sandwich] = [] ){
        self.sandwiches = sandwiches
    }
}

let testStore = SandwichStore(sandwiches: testData)



