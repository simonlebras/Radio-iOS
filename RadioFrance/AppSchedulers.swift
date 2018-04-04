//
//  AppSchedulers.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 02/04/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import RxSwift

class AppSchedulers {
    let computation = ConcurrentDispatchQueueScheduler(qos: .userInteractive)
    let utility = ConcurrentDispatchQueueScheduler(qos: .utility)
}
