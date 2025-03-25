//
//  FHIRSearchExtensions.swift
//  HealthKitOnFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import FHIR

extension FHIRSearch {
    
    /// Performs a GET on the server after constructing the query URL, returning an error or a bundle resource with the callback and will fetch subsequent pages.
    ///
    /// - Parameters:
    ///   - server: The FHIRServer instance on which to perform the search
    ///   - callback: The callback, receives the response Bundle or an Error message describing what went wrong
    public func performAndContinue(_ server: FHIRServer, pageLimit: Int, callback: @escaping FHIRSearchBundleErrorCallback) {
        perform(server) { (bundle, error) in
            guard error == nil else {
                callback(nil, error)
                return
            }
            
            if self.hasMore {
                self.recursivePerform(server, bundle: bundle, pageLimit: pageLimit - 1, callback: callback)
            } else {
                callback(bundle, error)
            }
        }
    }
    
    private func recursivePerform(_ server: FHIRServer, bundle: FHIR.Bundle?, pageLimit: Int, callback: @escaping FHIRSearchBundleErrorCallback) {
        guard pageLimit > 0 else {
            callback(bundle, FHIRError.error("Page limit reached"))
            return
        }
        
        nextPage(server) { (nextBundle, error) in
            // Merge the results.
            let mergedBundle = if let currentBundle = bundle {
                self.addEntries(from: nextBundle, to: currentBundle)
            } else {
                nextBundle
            }
            
            guard error == nil else {
                callback(nil, error)
                return
            }
            
            if self.hasMore {
                self.recursivePerform(server, bundle: mergedBundle, pageLimit: pageLimit - 1, callback: callback)
            } else {
                callback(mergedBundle, error)
            }
        }
    }
    
    private func addEntries(from bundle: FHIR.Bundle?, to otherBundle: FHIR.Bundle) -> FHIR.Bundle {
        // The from bundle is nil or has no entries - nothing to merge.
        guard let entries = bundle?.entry else {
            return otherBundle
        }
        
        if otherBundle.entry == nil {
            otherBundle.entry = entries
        } else if var existingEntries = otherBundle.entry {
            existingEntries.append(contentsOf: entries)
            otherBundle.entry = existingEntries
        }
        
        return otherBundle
    }
}
