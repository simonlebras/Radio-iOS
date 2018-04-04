//
//  RemoteRadioSource.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 31/03/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import RxSwift
import RxCocoa

class RemoteRadioSource: RadioSource {
    private static let radiosEndpoint = "https://radio-france-77818.firebaseapp.com/radios.json"
    private static let retryCount = 3
    private static let retryInitialDelay: TimeInterval = 3.0
    private static let retryMultiplier = 1.5
    
    let requestState = BehaviorRelay(value: RequestState.idle)
    
    private let retry = PublishRelay<Bool>()
    
    private let appSchedulers: AppSchedulers
    
    init(appSchedulers: AppSchedulers) {
        self.appSchedulers = appSchedulers
    }
    
    func fetchRadios() -> Observable<[Radio]> {
        let request = URLRequest(url: URL(string: RemoteRadioSource.radiosEndpoint)!)
        return URLSession.shared.rx
                .data(request: request)
                .map { try JSONDecoder().decode([Radio].self, from: $0) }
                .retryWhen({ [unowned self] errors in
                    return errors.enumerated().flatMap({ tuple -> Observable<Void> in
                        let (index, error) = tuple
                        
                        guard index < RemoteRadioSource.retryCount else {
                            return Observable.error(error)
                        }
                        
                        guard (error as NSError).domain != NSURLErrorDomain && (error as NSError).code != NSURLErrorNotConnectedToInternet else {
                            return Observable.error(error)
                        }
                        
                        let delay = index == 0 ? RemoteRadioSource.retryInitialDelay : RemoteRadioSource.retryInitialDelay * pow(RemoteRadioSource.retryMultiplier, Double(index))
                        return Observable<Int>.timer(delay, scheduler: self.appSchedulers.utility)
                            .map { _ in () }
                    })
                })
                .do(
                    onError: { [unowned self] _ in
                        self.requestState.accept(.error)
                    },
                    onCompleted: { [unowned self] in
                        self.requestState.accept(.complete)
                    },
                    onSubscribe: {
                        self.requestState.accept(.loading)
                    }
                )
                .retryWhen{ _ in self.retry }
                .share(replay: 1)
    }
    
    func retryRadioFetching(){
        retry.accept(true)
    }
}
