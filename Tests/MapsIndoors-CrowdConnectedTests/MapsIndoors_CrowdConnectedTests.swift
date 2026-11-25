import Testing
import MapsIndoorsCore
@testable import MapsIndoors_CrowdConnected

@Test
func assignPositionProvider() async throws {
    let crowdConnectedPositionProvider = CrowdConnectedPositionProvider(appKey: "YOUR_APP_KEY", clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")

    MPMapsIndoors.shared.positionProvider = crowdConnectedPositionProvider
    
    #expect(MPMapsIndoors.shared.positionProvider != nil)
}

@Test
func accuracyFromCCQuality() {
    let provider = CrowdConnectedPositionProvider(appKey: "YOUR_APP_KEY", clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")

    #expect(provider.accuracyFromCCQuality(0) == 20)
    #expect(provider.accuracyFromCCQuality(1) == 10)
}
