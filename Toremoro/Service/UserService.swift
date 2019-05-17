//
//  UserService.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import RxSwift
import FirebaseAuth

struct UserService {

    // MARK: - Public

    func authenticate() -> Single<Void> {
        return .create { observer in
            Auth.auth().signInAnonymously { _, error in
                if let error = error {
                    observer(.error(error))
                }

                observer(.success(()))
            }

            return Disposables.create()
        }
    }
}
