//
//  MultipleValidatable.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/24.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Validator
import RxSwift

protocol ValidationErrorType: Error {
    var message: String { get }
}

struct ValidationError: Error {
    let messages: [String]
    init(errors: [ValidationErrorType]) {
        self.messages = errors.map { $0.message }
    }
}

protocol MultipleValidatable {
    func validate() -> ValidationResult
}

extension MultipleValidatable {
    var validatedError: ValidationError? {
        switch validate() {
        case .valid:
            return nil
        case .invalid(let errors):
            guard let validationErrors = errors as? [ValidationErrorType] else {
                fatalError("Can't cast to ValidationErrorType")
            }
            return ValidationError(errors: validationErrors)
        }
    }
}
