//
//  QueueManager.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 03/04/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import RxSwift

class QueueManager {
    var currentRadio: Radio? {
        willSet {
            currentIndex = radioQueue.index(of: newValue!)!
        }
    }
    
    private var currentIndex = -1
    
    private var radioQueue: [Radio]!
    
    private let disposeBag = DisposeBag()
    
    init(radioSource: RadioSource){
        radioSource
            .fetchRadios()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.radioQueue = $0
            })
            .disposed(by: disposeBag)
    }
    
    func skipToNext() {
        let index = (currentIndex + 1) % radioQueue.count
        
        currentRadio = radioQueue[index]
    }
    
    func skipToPrevious() {
        var index = (currentIndex - 1)
        if index < 0 {
            index = radioQueue.count - 1
        }
        
        currentRadio = radioQueue[index]
    }
}
