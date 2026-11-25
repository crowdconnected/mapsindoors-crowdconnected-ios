# MapsIndoors CrowdConnected Position Provider for iOS

## Overview

This Swift Package enables the integration of CrowdConnected's Indoor Positioning System (IPS) as a position provider within the MapsIndoors iOS SDK. This integration allows for highly accurate indoor location services in your MapsIndoors-enabled applications.

## Features

* **Seamless Integration:** Effortlessly incorporate CrowdConnected's advanced positioning technology into your MapsIndoors projects.
* **Accurate Indoor Location:** Leverage CrowdConnected's IPS to provide precise location data within indoor spaces.
* **Swift Package Manager Support:** Easily install and manage the dependency using Swift Package Manager.

## Requirements

* iOS 16.0 or later
* Xcode 26.3 or later (required by the CrowdConnected SDK 3.x binaries)
* MapsIndoors iOS SDK 4.24.2 or later (using either [Mapbox Maps](https://github.com/MapsPeople/mapsindoors-mapbox-ios) or [Google Maps](https://github.com/MapsPeople/mapsindoors-googlemaps-ios))
* CrowdConnected iOS SDK 3.3.0 or later, from [crowdconnected-sdk-swift-spm](https://github.com/crowdconnected/crowdconnected-sdk-swift-spm) (added automatically by Swift Package Manager)
* A MapsIndoors API key
* A CrowdConnected app key, client ID and client secret

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
    .package(url: "https://github.com/MapsPeople/mapsindoors-crowdconnected-ios.git", .upToNextMajor(from: "2.0.0")),
]
```

### Fork the repository

If you prefer more control, want to understand how it works, or want to customize the position provider package, you can fork this repository. By forking the repository, you create your own copy of the project, which you can modify to suit your specific requirements while retaining the base functionality.

1.  Fork the repository to your own GitHub account.
2.  Clone the forked repository to your local machine.
3.  Add the forked repository as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/YOUR_USERNAME/mapsindoors-crowdconnected-ios.git", .upToNextMajor(from: "2.0.0")),
]
```

## Usage

The position provider should only be initialized when user positioning is required. It depends on MapsIndoors being initialized.

### 1. Prerequisites

* Obtain the necessary API keys and credentials for both MapsIndoors and CrowdConnected.
    * Get MapsIndoors API key from the MapsIndoors CMS, or contact MapsPeople. 
    * Get your CrowdConnected app key, client ID and client secret as described [here](https://customer.support.crowdconnected.com/servicedesk/customer/portal/1/article/2888139205). The client ID and client secret were called "token" and "secret" before CrowdConnected SDK 3.0.

### 2. Configure Info.plist

Ensure your `Info.plist` file includes the necessary privacy-sensitive usage descriptions, as required by both the MapsIndoors and CrowdConnected SDKs. The CrowdConnected SDK checks for these when it starts and fails to start if a required one is missing.

Always required:

* `NSLocationWhenInUseUsageDescription`
* `NSLocationAlwaysAndWhenInUseUsageDescription`

Required only if you use CrowdConnected's CoreBluetooth module (`useCoreBluetooth: true`), which is needed for Eddystone and all other beacons that are not Apple iBeacon. Apple iBeacon is scanned through Core Location and does not need these:

* `NSBluetoothAlwaysUsageDescription`
* `bluetooth-central` in `UIBackgroundModes` (background tracking only)

Required only if you use `trackingMode: .background`:

* `location` in `UIBackgroundModes`

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Your location is used to show where you are on the map.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Your location is used to show where you are on the map.</string>

<!-- Only with useCoreBluetooth: true (Eddystone and other non-iBeacon beacons) -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth is used to find your position indoors.</string>

<!-- Only with trackingMode: .background -->
<key>UIBackgroundModes</key>
<array>
    <string>location</string>
    <!-- Only with useCoreBluetooth: true -->
    <string>bluetooth-central</string>
</array>
```

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
let crowdConnectedPositionProvider = CrowdConnectedPositionProvider(
    appKey: "YOUR_CROWDCONNECTED_APP_KEY",
    clientId: "YOUR_CROWDCONNECTED_CLIENT_ID",
    clientSecret: "YOUR_CROWDCONNECTED_CLIENT_SECRET",
    trackingMode: .foreground, // or .background, see Info.plist above
    useCoreBluetooth: false    // true for Eddystone or other non-iBeacon beacons, see Info.plist above
)

// Use the CrowdConnected Position Provider in MapsIndoors.
MPMapsIndoors.shared.positionProvider = crowdConnectedPositionProvider
mapControl?.showUserPosition = true
```

The provider starts the CrowdConnected SDK with the IPS module, plus the CoreBluetooth module when `useCoreBluetooth` is `true`. If your app has already started the CrowdConnected SDK, the provider attaches to the running SDK instead of starting it again. Positions without a floor (for example, outdoor GPS fixes) are not passed to MapsIndoors.

Call `stopPositioning()` to stop the CrowdConnected SDK when you no longer need the user's position.

## Migrating from 1.x

Version 2.0.0 moves to CrowdConnected SDK 3.x, which is distributed as a single package, [crowdconnected-sdk-swift-spm](https://github.com/crowdconnected/crowdconnected-sdk-swift-spm), instead of `crowdconnected-core-ios` and `crowdconnected-ips-ios`.

* **Minimum iOS is now 16.0**, because MapsIndoors 4.18.0 and later require iOS 16.
* **Xcode 26.3 or later** is required to build the CrowdConnected SDK 3.x binaries.
* **Credentials are renamed.** Use `init(appKey:clientId:clientSecret:trackingMode:useCoreBluetooth:)`. The old `init(appKey:token:secret:)` still works but is deprecated; your existing token and secret values are your client ID and client secret.
* **Remove the old CrowdConnected packages.** If your app also depends on `crowdconnected-core-ios` or `crowdconnected-ips-ios` directly, replace them with `crowdconnected-sdk-swift-spm` so the 2.x and 3.x frameworks are not both linked.
* **Info.plist:** remove `NSBluetoothPeripheralUsageDescription`. If your site uses Eddystone or other non-iBeacon beacons, pass `useCoreBluetooth: true` and add `NSBluetoothAlwaysUsageDescription` (plus `bluetooth-central` in `UIBackgroundModes` for background tracking). See [Configure Info.plist](#2-configure-infoplist).
