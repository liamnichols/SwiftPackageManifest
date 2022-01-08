import Foundation

public extension ProductSetting.IOSAppInfo.Capability {
    enum Label: String {
        case appTransportSecurity
        case bluetoothAlways
        case calendars
        case camera
        case contacts
        case faceID
        case localNetwork
        case locationAlwaysAndWhenInUse
        case locationWhenInUse
        case mediaLibrary
        case microphone
        case motion
        case nearbyInteractionAllowOnce
        case photoLibrary
        case photoLibraryAdd
        case reminders
        case speechRecognition
        case userTracking
    }

    var label: Label {
        switch self {
        case .appTransportSecurity:
            return .appTransportSecurity
        case .bluetoothAlways:
            return .bluetoothAlways
        case .calendars:
            return .calendars
        case .camera:
            return .camera
        case .contacts:
            return .contacts
        case .faceID:
            return .faceID
        case .localNetwork:
            return .localNetwork
        case .locationAlwaysAndWhenInUse:
            return .locationAlwaysAndWhenInUse
        case .locationWhenInUse:
            return .locationWhenInUse
        case .mediaLibrary:
            return .mediaLibrary
        case .microphone:
            return .microphone
        case .motion:
            return .motion
        case .nearbyInteractionAllowOnce:
            return .nearbyInteractionAllowOnce
        case .photoLibrary:
            return .photoLibrary
        case .photoLibraryAdd:
            return .photoLibraryAdd
        case .reminders:
            return .reminders
        case .speechRecognition:
            return .speechRecognition
        case .userTracking:
            return .userTracking
        }
    }
}
