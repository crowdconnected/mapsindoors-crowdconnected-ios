# MapsIndoors CrowdConnected Position Provider for iOS

## Overview

This Swift Package enables the integration of CrowdConnected's Indoor Positioning System (IPS) as a position provider within the MapsIndoors iOS SDK. This integration allows for highly accurate indoor location services in your MapsIndoors-enabled applications.

## Features

* **Seamless Integration:** Effortlessly incorporate CrowdConnected's advanced positioning technology into your MapsIndoors projects.
* **Accurate Indoor Location:** Leverage CrowdConnected's IPS to provide precise location data within indoor spaces.
* **Swift Package Manager Support:** Easily install and manage the dependency using Swift Package Manager.

## Requirements

* iOS 15.0 or later
* Xcode 16.0 or later
* MapsIndoors iOS SDK (using either [Mapbox Maps](https://github.com/MapsPeople/mapsindoors-mapbox-ios) or [Google Maps](https://github.com/MapsPeople/mapsindoors-googlemaps-ios)
* CrowdConnected iOS SDK (automatically added by Swift Package Manager)
* A MapsIndoors API key
* A CrowdConnected account and API key

## Installation

### Using Swift Package Manager in Xcode

1.  In Xcode, open your project.
2.  Go to `File` -> `Add Package Dependencies…`
3.  Enter the repository URL for this package (https://github.com/MapsPeople/mapsindoors-crowdconnected-ios.git)
4.  Follow the prompts to select the package and target for installation.

### Using Swift Package Manager Manifest

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/MapsPeople/mapsindoors-crowdconnected-ios.git", .upToNextMajor(from: "1.0.0")),
]
```

### Fork the repository

If you prefer more control, want to understand how it works, or want to customize the position provider package, you can fork this repository. By forking the repository, you create your own copy of the project, which you can modify to suit your specific requirements while retaining the base functionality.

1.  Fork the repository to your own GitHub account.
2.  Clone the forked repository to your local machine.
3.  Add the forked repository as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/YOUR_USERNAME/mapsindoors-crowdconnected-ios.git", .upToNextMajor(from: "1.0.0")),
]
```

## Usage

The position provider should only be initialized when user positioning is required. It depends on MapsIndoors being initialized.

### 1. Prerequisites

* Obtain the necessary API keys and credentials for both MapsIndoors and CrowdConnected.
    * Get MapsIndoors API key from the MapsIndoors CMS, or contact MapsPeople. 
    * Getting Authentication Credentials for CrowdConnected is described [here](https://customer.support.crowdconnected.com/servicedesk/customer/portal/1/article/2888139205).

### 2. Configure Info.plist

Ensure your `Info.plist` file includes the necessary privacy-sensitive usage descriptions for location services, as required by both the MapsIndoors and CrowdConnected SDKs. This typically includes:

* `NSLocationWhenInUseUsageDescription`
* `NSLocationAlwaysAndWhenInUseUsageDescription` (if your app requires background location)
* `NSBluetoothPeripheralUsageDescription` (since your app needs to use Bluetooth for the CrowdConnected IPS to work)

### 3. Import the Module

```swift
// Import the MapsIndoors SDK
import MapsIndoors
// Import the CrowdConnected Position Provider for MapsIndoors
import MapsIndoors_CrowdConnected
```

### 4. Set up the CrowdConnected Position Provider for MapsIndoors

```swift
// Initialize the CrowdConnected based PositionProvider. Replace with your actual CrowdConnected credentials.
let crowdConnectedPositionProvider = CrowdConnectedPositionProvider(appKey: "YOUR_CROWDCONNECTED_APP_KEY", token: "YOUR_CROWDCONNECTED_TOKEN", secret: "YOUR_CROWDCONNECTED_SECRET")

// Use the CrowdConnected Position Provider in MapsIndoors.
MPMapsIndoors.shared.positionProvider = crowdConnectedPositionProvider
mapControl?.showUserPosition = true
```
