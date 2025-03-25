//
//  BundleExtensions.swift
//  HealthKitOnFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import FHIR

extension FHIR.Bundle {
    private static let identifierKey = "identifier"
    
    public func resourceWithIdentifier(system: String, value: String) throws -> Resource? {
        guard let entries = self.entry else {
            return nil
        }
        
        let entry = try entries.first(where: { entry in
            guard let resource = entry.resource else { 
                return false 
            }
            
            let json = try resource.asJSON()
            guard let identifierCollection = json[Bundle.identifierKey] as? [FHIRJSON] else { 
                return false 
            }
            
            for identifierJson in identifierCollection {
                let identifier = try Identifier(json: identifierJson)
                if identifier.contains(system: system, value: value) {
                    return true
                }
            }
            
            return false
        })
        
        return entry?.resource
    }
}
