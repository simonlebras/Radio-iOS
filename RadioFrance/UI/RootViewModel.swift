//
//  RootViewModel.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 03/04/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import RxSwift
import RxCocoa

class RootViewModel {
    var playerMetadata: BehaviorRelay<Radio?> {
        return playbackManager.playerMetadata
    }
    
    private let playbackManager: PlaybackManager
    
    init(playbackManager: PlaybackManager) {
        self.playbackManager = playbackManager
    }
}
