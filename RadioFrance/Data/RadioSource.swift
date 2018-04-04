//
//  RadioSource.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 31/03/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RadioSource: class {
    var requestState: BehaviorRelay<RequestState> { get }
    
    func fetchRadios() -> Observable<[Radio]>
    
    func retryRadioFetching()
}
