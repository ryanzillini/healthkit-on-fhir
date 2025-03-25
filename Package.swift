// swift-tools-version:6.0
//  Package.swift
//  HealthKitOnFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import PackageDescription

let package = Package(
    name: "HealthKitOnFhir",
	platforms: [
        .iOS(.v14)
	],
    products: [
        .library(
            name: "HealthKitOnFhir",
            targets: ["HealthKitOnFhir"]),
    ],
    dependencies: [
        .package(url: "https://github.com/smart-on-fhir/Swift-FHIR", from: "4.2.0"),
        .package(url: "https://github.com/microsoft/iomt-fhir-client", from: "1.0.0"),
        .package(url: "https://github.com/microsoft/health-data-sync", from: "1.0.0"),
        .package(url: "https://github.com/microsoft/healthkit-to-fhir", from: "1.0.2"),
    ],
    targets: [
        .target(
            name: "HealthKitOnFhir",
            dependencies: [
                "FHIR", 
                "IomtFhirClient", 
                "HealthDataSync", 
                "HealthKitToFhir"
            ],
            path: "Sources",
            sources: ["IomtFhir", "Fhir"]),
    ]
)
