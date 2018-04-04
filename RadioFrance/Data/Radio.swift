//
//  Radio.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 31/03/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

struct Radio: Decodable {
    let id: String
    let name: String
    let description: String
    let stream: String
    let logo: String
}

extension Radio: Equatable {
    static func == (lhs: Radio, rhs: Radio) -> Bool {
        return lhs.id == rhs.id
    }
}
