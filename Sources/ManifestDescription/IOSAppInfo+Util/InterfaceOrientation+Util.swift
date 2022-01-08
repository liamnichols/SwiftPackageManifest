import Foundation

public extension ProductSetting.IOSAppInfo.InterfaceOrientation {
    enum Label: String {
        case portrait, portraitUpsideDown, landscapeRight, landscapeLeft
    }

    var label: Label {
        switch self {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeRight:
            return .landscapeRight
        case .landscapeLeft:
            return .landscapeLeft
        }
    }

    var condition: ProductSetting.IOSAppInfo.DeviceFamilyCondition? {
        switch self {
        case .portrait(let condition),
                .portraitUpsideDown(let condition),
                .landscapeRight(let condition),
                .landscapeLeft(let condition):
            return condition
        }
    }
}
