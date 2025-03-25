//
//  IdentifierExtensions.swift
//  HealthKitOnFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import FHIR

extension Identifier {
    public func contains(system targetSystem: String, value targetValue: String) -> Bool {
        guard let identifierSystem = self.system?.absoluteString,
              let identifierValue = self.value?.description else {
            return false
        }
        
        return identifierSystem == targetSystem && identifierValue == targetValue
    }
}
