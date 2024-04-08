import Foundation
import AVFoundation

@MainActor
class CameraManager: ObservableObject{
    @Published var authStatus: Bool = false
    
    func getPermission() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            authStatus = true
        case .notDetermined:
            await AVCaptureDevice.requestAccess(for: .video)
            authStatus = true
        case .denied:
            authStatus = false
        case .restricted:
            authStatus = false
            
        default:
            authStatus = false
        }
    }
}
