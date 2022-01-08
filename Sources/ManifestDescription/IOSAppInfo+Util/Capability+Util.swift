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

    var condition: ProductSetting.IOSAppInfo.DeviceFamilyCondition? {
        switch self {
        case .appTransportSecurity(_, let condition),
                .bluetoothAlways(_, let condition),
                .calendars(_, let condition),
                .camera(_, let condition),
                .contacts(_, let condition),
                .faceID(_, let condition),
                .localNetwork(_, _, let condition),
                .locationAlwaysAndWhenInUse(_, let condition),
                .locationWhenInUse(_, let condition),
                .mediaLibrary(_, let condition),
                .microphone(_, let condition),
                .motion(_, let condition),
                .nearbyInteractionAllowOnce(_, let condition),
                .photoLibrary(_, let condition),
                .photoLibraryAdd(_, let condition),
                .reminders(_, let condition),
                .speechRecognition(_, let condition),
                .userTracking(_, let condition):
            return condition
        }
    }
}
