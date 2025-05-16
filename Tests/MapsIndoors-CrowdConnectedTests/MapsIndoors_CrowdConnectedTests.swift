import Testing
import MapsIndoorsCore
@testable import MapsIndoors_CrowdConnected

@Test
func assignPositionProvider() async throws {
    let crowdConnectedPositionProvider = CrowdConnectedPositionProvider(appKey: "YOUR_APP_KEY", token: "YOUR_TOKEN", secret: "YOUR_SECRET")

    MPMapsIndoors.shared.positionProvider = crowdConnectedPositionProvider
    
    #expect(MPMapsIndoors.shared.positionProvider != nil)
}
