import CoreLocation
import CrowdConnectedCore
import CrowdConnectedCoreBluetooth
import CrowdConnectedIPS
import Foundation
import MapsIndoors

@objc
public final class CrowdConnectedPositionProvider: NSObject, MPPositionProvider {

    public weak var delegate: (any MapsIndoors.MPPositionProviderDelegate)?
    public var latestPosition: MapsIndoors.MPPositionResult?

    public var ccPositionTimestamp = Date()
    private var ccPositionSource = "NA"

    /// The CrowdConnected device ID, available once the SDK has started successfully.
    public private(set) var deviceID: String?

    private let ccAppKey: String
    private let ccClientId: String
    private let ccClientSecret: String
    private let ccTrackingMode: LocationTrackingMode
    private let ccUseCoreBluetooth: Bool

    // Retained so the authorization prompt is not dropped when the manager is deallocated.
    private let locationManager = CLLocationManager()

    /// Creates the position provider and starts CrowdConnected positioning.
    ///
    /// - Parameters:
    ///   - appKey: Your CrowdConnected app key.
    ///   - clientId: Your CrowdConnected client ID (called "token" in SDK versions before 3.0).
    ///   - clientSecret: Your CrowdConnected client secret (called "secret" in SDK versions before 3.0).
    ///   - trackingMode: `.foreground` (default) or `.background`. Background tracking needs the
    ///     `location` background mode in your app's Info.plist.
    ///   - useCoreBluetooth: Set to `true` if your site uses Eddystone or other non-iBeacon beacons.
    ///     This enables CrowdConnected's CoreBluetooth module, which needs `NSBluetoothAlwaysUsageDescription`
    ///     and, for background tracking, the `bluetooth-central` background mode in your app's Info.plist.
    ///     Not needed for Apple iBeacon, which is scanned through Core Location.
    public init(appKey: String, clientId: String, clientSecret: String, trackingMode: LocationTrackingMode = .foreground, useCoreBluetooth: Bool = false) {
        ccAppKey = appKey
        ccClientId = clientId
        ccClientSecret = clientSecret
        ccTrackingMode = trackingMode
        ccUseCoreBluetooth = useCoreBluetooth

        super.init()

        startPositioning()
    }

    @available(*, deprecated, renamed: "init(appKey:clientId:clientSecret:trackingMode:useCoreBluetooth:)")
    public convenience init(appKey: String, token: String, secret: String) {
        self.init(appKey: appKey, clientId: token, clientSecret: secret)
    }

    public func startPositioning() {
        CrowdConnected.shared.delegate = self

        // The SDK may already have been started elsewhere in the app; just listen for locations.
        guard CrowdConnected.shared.isRunning == false else {
            return
        }

        locationManager.requestWhenInUseAuthorization()

        let configuration = Configuration.Builder()
            .withCredentials(appKey: ccAppKey, clientId: ccClientId, clientSecret: ccClientSecret)
            .with(modules: ccUseCoreBluetooth ? [.ips, .coreBluetooth] : [.ips])
            .with(trackingMode: ccTrackingMode)
            .build()

        CrowdConnected.shared.start(with: configuration)
    }

    public func stopPositioning() {
        CrowdConnected.shared.delegate = nil
        CrowdConnected.shared.stop()
    }

    public override var debugDescription: String {
        """
\(self)
position: \(latestPosition?.coordinate.latitude ?? 0), \(latestPosition?.coordinate.longitude ?? 0), \(latestPosition?.floorIndex ?? 0)
heading: \(latestPosition?.bearing ?? 0)
accuracy: \(latestPosition?.accuracy ?? -1)
source: \(ccPositionSource)
"""
    }

    // MARK: Properties from AppPositionProvider protocol
    @objc public var enableDebugInfo = false

}

extension CrowdConnectedPositionProvider: CrowdConnectedDelegate {
    public func locationProvider(_ crowdConnected: CrowdConnected, didStartSuccess deviceId: DeviceID) {
        deviceID = deviceId
    }

    public func locationProvider(_ crowdConnected: CrowdConnected, didStartFailure errorCode: ErrorCode) {
        print("Error starting CrowdConnected: \(errorCode.description)")
    }

    public func locationProvider(_ crowdConnected: CrowdConnected, didUpdateLocation location: Location) {
        // MapsIndoors needs a floor to place the blue dot; skip fixes without one (e.g. outdoor GPS).
        guard let floor = location.floor?.intValue else {
            return
        }

        let positionCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let positionAccuracy = accuracyFromCCQuality(location.quality)
        let newPosition = MPPositionResult(coordinate: positionCoordinate, floorIndex: floor, accuracy: positionAccuracy)
        latestPosition = newPosition

        // CrowdConnected 3.x timestamps are in milliseconds since 1970.
        ccPositionTimestamp = Date(timeIntervalSince1970: TimeInterval(location.timestamp) / 1000)
        ccPositionSource = location.type

        delegate?.onPositionUpdate(position: newPosition)
    }

    // Translate CrowdConnected accuracy to MapsIndoors accuracy
    // CC quality 2 (best) -> ~7m accuracy, quality 1 (medium) -> ~14m accuracy, quality 0 (worst) -> ~20m accuracy
    func accuracyFromCCQuality(_ ccAccuracy: Int) -> Double {
        20 / (Double(ccAccuracy) + 1)
    }
}
