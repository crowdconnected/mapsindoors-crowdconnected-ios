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
* MapsIndoors iOS SDK
* CrowdConnected iOS SDK
* A MapsIndoors API key
* A CrowdConnected account and API key

## Installation

### Using Swift Package Manager

1.  In Xcode, open your project.
2.  Go to `File` -> `Swift Packages` -> `Add Package Dependency...`
3.  Enter the repository URL for this package.
4.  Follow the prompts to select the package and target for installation.

## Usage

### 1. Prerequisites

* Obtain the necessary API keys and credentials for both MapsIndoors and CrowdConnected.
    * Get MapsIndoors API Key from the MapsIndoors CMS, or contact MapsPeople. 
    * Getting Authentication Credentials for CrowdConnected is described [here](https://customer.support.crowdconnected.com/servicedesk/customer/portal/1/article/2888139205).

### 2. Import the Module

```swift
// Import the MapsIndoors SDK
import MapsIndoors
// Import the CrowdConnected Position Provider for MapsIndoors
import MapsIndoors_CrowdConnected
```

### 3. Set up the CrowdConnected Position Provider for MapsIndoors

```swift
// Initialize the CrowdConnected based PositionProvider. Replace with your actual CrowdConnected credentials.

let crowdConnectedPositionProvider = CrowdConnectedPositionProvider(appKey: "YOUR_CROWDCONNECTED_APP_KEY", token: "YOUR_CROWDCONNECTED_TOKEN", secret: "YOUR_CROWDCONNECTED_SECRET")

// Use the CrowdConnected Position Provider in MapsIndoors.
MPMapsIndoors.shared.positionProvider = crowdConnectedPositionProvider
mapControl?.showUserPosition = true
```

### 4. Configure Info.plist

Ensure your `Info.plist` file includes the necessary privacy-sensitive usage descriptions for location services, as required by both the MapsIndoors and CrowdConnected SDKs. This typically includes:

`NSLocationWhenInUseUsageDescription`

`NSLocationAlwaysAndWhenInUseUsageDescription` (if your app requires background location)

`NSBluetoothPeripheralUsageDescription` (since your app needs to use Bluetooth for the CrowdConnected IPS to work)
