import UIKit

struct Edge {
    let left: CGFloat
    let right: CGFloat
    let top: CGFloat
    let bottom: CGFloat

    init(_ all: CGFloat) {
        left = all
        right = all
        top = all
        bottom = all
    }

    init(left: CGFloat = 0, top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }

    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.left = horizontal
        self.top = vertical
        self.right = horizontal
        self.bottom = vertical
    }

    func growSize(size: CGSize) -> CGSize {
        let width = max(size.width + left + right, 0)
        let height = max(size.height + top + bottom, 0)
        return CGSize(width: width, height: height)
    }

    func shrinkSize(size: CGSize) -> CGSize {
        let width = max(size.width - left - right, 0)
        let height = max(size.height - top - bottom, 0)
        return CGSize(width: width, height: height)
    }

    func growRect(rect: CGRect) -> CGRect {
        return CGRect(x: rect.origin.x - left, y: rect.origin.y - top,
                      width: rect.width + left + right, height: rect.height + top + bottom)
    }

    func shrinkRect(rect: CGRect) -> CGRect {
        return CGRect(x: rect.origin.x + left, y: rect.origin.y + top,
                      width: rect.width - left - right, height: rect.height - top - bottom)
    }
}

var EdgeZero = Edge(0)

class LayoutParams {
    static let MatchParent: CGFloat = -1
    static let WrapContent: CGFloat = -2

    var width = MatchParent
    var height = MatchParent
    var margin = EdgeZero
    var minWidth: CGFloat = 0
    var maxWidth: CGFloat = CGFloat.max
    var minHeight: CGFloat = 0
    var maxHeight: CGFloat = CGFloat.max
}

extension UIView {
    private struct Keys {
        static var layoutParamsKey = "layoutParams"
    }

    var layoutParams: LayoutParams {
        get {
            if let lp = objc_getAssociatedObject(self, &Keys.layoutParamsKey) as? LayoutParams {
                return lp
            }
            let lp = LayoutParams()
            objc_setAssociatedObject(self, &Keys.layoutParamsKey,
                                     lp, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return lp
        }
        set {
            objc_setAssociatedObject(self, &Keys.layoutParamsKey,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
