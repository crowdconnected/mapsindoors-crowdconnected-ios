import CoreLocation
import CrowdConnectedCore
import CrowdConnectedIPS
import Foundation
import MapsIndoors

@objc
public final class CrowdConnectedPositionProvider: NSObject, MPPositionProvider {

    public weak var delegate: (any MapsIndoors.MPPositionProviderDelegate)?
    public var latestPosition: MapsIndoors.MPPositionResult?

    public var ccPositionTimestamp = Date()
    private var ccPositionSource = "NA"

    private var deviceID: String?
    private let ccAppKey: String
    private let ccToken: String
    private let ccSecret: String

    public init(appKey: String, token: String, secret: String) {
        ccAppKey = appKey
        ccToken = token
        ccSecret = secret
        
        super.init()
        
        startPositioning()
    }

    public func startPositioning() {
        guard CrowdConnected.shared.isSuccessfullyRunning == false, CrowdConnected.shared.isNavigationRunning == false else {
            return
        }

        CLLocationManager().requestWhenInUseAuthorization()

        CrowdConnectedIPS.activate()
        CrowdConnected.shared.start(appKey: ccAppKey, token: ccToken, secret: ccSecret) { deviceID, error in
            guard error == nil, let deviceID else {
                print("Error starting CrowdConnected: \(error!)")
                return
            }

            self.deviceID = deviceID
            CrowdConnected.shared.delegate = self
            CrowdConnected.shared.startNavigation()
        }
    }

    public func stopPositioning() {
        CrowdConnected.shared.stopNavigation()
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
    public func didUpdateLocation(_ locations: [Location]) {
        guard let location = locations.last else {
            return
        }

        let positionCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let positionAccuracy = accuracyFromCCQuality(location.quality)
        let newPosition = MPPositionResult(coordinate: positionCoordinate, floorIndex: location.floor, accuracy: positionAccuracy)
        latestPosition = newPosition

        ccPositionTimestamp = Date(timeIntervalSince1970: TimeInterval(location.timestamp))
        ccPositionSource = location.type

        delegate?.onPositionUpdate(position: newPosition)
    }

    // Translate CrowdConnected accuracy to MapsIndoors accuracy
    // CC quality 2 (best) -> ~7m accuracy, quality 1 (medium) -> ~14m accuracy, quality 0 (worst) -> ~20m accuracy
    func accuracyFromCCQuality(_ ccAccuracy: Int) -> Double {
        20 / (Double(ccAccuracy) + 1)
    }
}
