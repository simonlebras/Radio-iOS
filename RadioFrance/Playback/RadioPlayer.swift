//
//  RadioPlayer.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 03/04/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import RxCocoa

protocol RadioPlayer {
    var playerStatus: BehaviorRelay<PlayerStatus> { get }
    var playerMetadata: BehaviorRelay<Radio?> { get }
    
    func play(radio: Radio)
    
    func pause()
}
