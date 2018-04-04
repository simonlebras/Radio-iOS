//
//  RadioListViewModel.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 31/03/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import RxSwift
import RxCocoa

class RadioListViewModel {
    lazy var fetchRadios: Driver<[Radio]> = { [unowned self] in
        return Observable.combineLatest(
            radioSource.fetchRadios(),
            searchRadioQuery
        ) { (radios: $0, query: $1) }
            .observeOn(appSchedulers.computation)
            .flatMapLatest { tuple -> Observable<[Radio]> in
                let (radios, query) = tuple
                
                return Observable.from(radios)
                    .filter{ radio in query.isEmpty || radio.name.lowercased().range(of: query) != nil }
                    .toArray()
            }
            .asDriver(onErrorJustReturn: [])
    }()
    
    var playerMetadata: BehaviorRelay<Radio?> {
        return playbackManager.playerMetadata
    }
    
    let searchRadioQuery = BehaviorRelay(value: "")
    var requestState: BehaviorRelay<RequestState> {
        return radioSource.requestState
    }
    
    private let radioSource: RadioSource
    private let playbackManager: PlaybackManager
    private let appSchedulers: AppSchedulers
    
    init(radioSource: RadioSource, playbackManager: PlaybackManager, appSchedulers: AppSchedulers) {
        self.radioSource = radioSource
        self.playbackManager = playbackManager
        self.appSchedulers = appSchedulers
    }
    
    func retryRadioFetching() {
        radioSource.retryRadioFetching()
    }
    
    func play(radio: Radio) {
        playbackManager.play(radio: radio)
    }
}
