import UIKit

enum Orientation {
    case vertical
    case horizontal
}

enum Alignment {
    case none
    case left
    case right
    case center
    case top
    case bottom
    case middle
}

class LinearLayoutParams: LayoutParams {
    var alignment: Alignment = .none
    var fill: CGFloat = 0
}

class LinearLayout: UIView {
    var orientation = Orientation.vertical {
        didSet {
            setNeedsLayout()
        }
    }

    var padding = EdgeZero {
        didSet {
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(orientation: Orientation, padding: Edge = EdgeZero) {
        self.init(frame: CGRect.zero)
        self.orientation = orientation
        self.padding = padding
    }

    convenience init(padding: Edge) {
        self.init(frame: CGRect.zero)
        self.padding = padding
    }

    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        view.layoutParams = LinearLayoutParams()
    }

    func addView(_ view: UIView, width: CGFloat = LayoutParams.WrapContent, height: CGFloat = LayoutParams.WrapContent,
                 margin: Edge = EdgeZero, align: Alignment = .left, fill: CGFloat = 0) {
        super.addSubview(view)
        let lp = LinearLayoutParams()
        lp.width = width
        lp.height = height
        lp.margin = margin
        lp.alignment = align
        lp.fill = fill
        view.layoutParams = lp
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let sizes: [CGSize]
        var measuredSize = CGSize.zero

        if orientation == .horizontal {
            sizes = calculateHorizontalSizes(size)
            for size in sizes {
                measuredSize.width += size.width
                measuredSize.height = max(measuredSize.height, size.height)
            }
        } else {
            sizes = calculateVerticalSizes(size)
            for size in sizes {
                measuredSize.width = max(measuredSize.width, size.width)
                measuredSize.height += size.height
            }
        }

        return padding.growSize(measuredSize)
    }

    override func layoutSubviews() {
        if orientation == .horizontal {
            let sizes = calculateHorizontalSizes(frame.size)
            layoutHorizontally(sizes)
        } else {
            let sizes = calculateVerticalSizes(frame.size)
            layoutVertically(sizes)
        }
    }

    // MARK:- Private

    private func calculateHorizontalSizes(_ size: CGSize) -> [CGSize] {
        let size = padding.shrinkSize(size)
        let undefined: CGFloat = -1
        var availableWidth = size.width
        var totalFill: CGFloat = 0
        var sizes = [CGSize](repeating: CGSize(width: undefined, height: undefined), count: subviews.count)

        for (index, view) in subviews.enumerated() {
            if view.isHidden {
                sizes[index].width = 0
                sizes[index].height = 0
                continue
            }

            if let spec = view.layoutParams as? LinearLayoutParams {
                let margin = spec.margin.left + spec.margin.right
                var measuredSize: CGSize?
                var viewWidth: CGFloat = 0
                totalFill += spec.fill

                switch spec.width {
                case LayoutParams.MatchParent:
                    viewWidth = availableWidth - margin
                case LayoutParams.WrapContent:
                    let availableSize = CGSize(width: availableWidth, height: size.height)
                    measuredSize = view.sizeThatFits(availableSize)
                    viewWidth = measuredSize!.width
                default:
                    viewWidth = spec.width
                }

                viewWidth = max(viewWidth, spec.minWidth)
                viewWidth = min(viewWidth, spec.maxWidth)
                viewWidth = min(viewWidth, availableWidth - margin)

                sizes[index].width = viewWidth
                if let measuredSize = measuredSize, measuredSize.width == viewWidth {
                    sizes[index].height = measuredSize.height
                }

                availableWidth -= (viewWidth + margin)
            }
        }

        for (index, view) in subviews.enumerated() {
            if !view.isHidden, let spec = view.layoutParams as? LinearLayoutParams {
                let margin = spec.margin.top + spec.margin.bottom

                if spec.fill > 0 && availableWidth > 0 {
                    let extra = availableWidth * spec.fill / totalFill
                    if extra > 0 {
                        sizes[index].width += extra
                        sizes[index].height = undefined
                        availableWidth -= extra
                    }
                }

                var viewHeight: CGFloat = 0
                switch spec.height {
                case LayoutParams.MatchParent:
                    viewHeight = size.height - margin
                case LayoutParams.WrapContent:
                    viewHeight = sizes[index].height
                    if viewHeight == undefined {
                        let availableSize = CGSize(width: sizes[index].width, height: size.height)
                        let measuredSize = view.sizeThatFits(availableSize)
                        viewHeight = measuredSize.height
                    }
                default:
                    viewHeight = spec.height
                }

                viewHeight = max(viewHeight, spec.minHeight)
                viewHeight = min(viewHeight, spec.maxHeight)
                viewHeight = min(viewHeight, size.height - margin)

                sizes[index].width += (spec.margin.left + spec.margin.right)
                sizes[index].height = viewHeight + margin
            }
        }

        return sizes
    }

    private func calculateVerticalSizes(_ size: CGSize) -> [CGSize] {
        let size = padding.shrinkSize(size)
        let undefined: CGFloat = -1
        var availableHeight = size.height
        var totalFill: CGFloat = 0
        var sizes = [CGSize](repeating: CGSize(width: undefined, height: undefined), count: subviews.count)

        for (index, view) in subviews.enumerated() {
            if view.isHidden {
                sizes[index].width = 0
                sizes[index].height = 0
                continue
            }

            if let spec = view.layoutParams as? LinearLayoutParams {
                let margin = spec.margin.top + spec.margin.bottom
                var measuredSize: CGSize?
                var viewHeight: CGFloat = 0
                totalFill += spec.fill

                switch spec.height {
                case LayoutParams.MatchParent:
                    viewHeight = availableHeight - margin
                case LayoutParams.WrapContent:
                    let availableSize = CGSize(width: size.width, height: availableHeight)
                    measuredSize = view.sizeThatFits(availableSize)
                    viewHeight = measuredSize!.height
                default:
                    viewHeight = spec.height
                }

                viewHeight = max(viewHeight, spec.minHeight)
                viewHeight = min(viewHeight, spec.maxHeight)
                viewHeight = min(viewHeight, availableHeight - margin)

                sizes[index].height = viewHeight
                if let measuredSize = measuredSize, measuredSize.height == viewHeight {
                    sizes[index].width = measuredSize.width
                }

                availableHeight -= (viewHeight + margin)
            }
        }

        for (index, view) in subviews.enumerated() {
            if !view.isHidden, let spec = view.layoutParams as? LinearLayoutParams {
                let margin = spec.margin.left + spec.margin.right

                if spec.fill > 0 && availableHeight > 0 {
                    let extra = availableHeight * spec.fill / totalFill
                    if extra > 0 {
                        sizes[index].width = undefined
                        sizes[index].height += extra
                        availableHeight -= extra
                    }
                }

                var viewWidth: CGFloat = 0
                switch spec.width {
                case LayoutParams.MatchParent:
                    viewWidth = size.width - margin
                case LayoutParams.WrapContent:
                    viewWidth = sizes[index].width
                    if viewWidth == undefined {
                        let availableSize = CGSize(width: size.width, height: sizes[index].height)
                        let measuredSize = view.sizeThatFits(availableSize)
                        viewWidth = measuredSize.width
                    }
                default:
                    viewWidth = spec.width
                }

                viewWidth = max(viewWidth, spec.minWidth)
                viewWidth = min(viewWidth, spec.maxWidth)
                viewWidth = min(viewWidth, size.width - margin)

                sizes[index].width = viewWidth + margin
                sizes[index].height += (spec.margin.top + spec.margin.bottom)
            }
        }
        
        return sizes
    }

    private func layoutHorizontally(_ sizes: [CGSize]) {
        let height = frame.size.height
        var left = padding.left
        for (index, size) in sizes.enumerated() {
            let view = subviews[index]
            if !view.isHidden, let params = view.layoutParams as? LinearLayoutParams {
                let margin = params.margin
                var top: CGFloat

                switch params.alignment {
                case .center:
                    top = padding.top + margin.top + (height - size.height - padding.top - padding.bottom) / 2
                case .bottom:
                    top = height - padding.bottom - size.height + margin.top
                default:
                    top = padding.top + margin.top
                }

                view.frame = CGRect(
                    x: left + margin.left,
                    y: top,
                    width: size.width - margin.left - margin.right,
                    height: size.height - margin.top - margin.bottom)

                view.layoutSubviews()
                left += size.width
            }
        }
    }

    private func layoutVertically(_ sizes: [CGSize]) {
        let width = frame.size.width
        var top = padding.top
        for (index, size) in sizes.enumerated() {
            let view = subviews[index]
            if !view.isHidden, let params = view.layoutParams as? LinearLayoutParams {
                let margin = params.margin
                var left: CGFloat

                switch params.alignment {
                case .center:
                    left = padding.left + margin.left + (width - size.width - padding.left - padding.right) / 2
                case .right:
                    left = width - padding.right - size.width + margin.left
                default:
                    left = padding.left + margin.left
                }

                view.frame = CGRect(
                    x: left,
                    y: top + margin.top,
                    width: size.width - margin.left - margin.right,
                    height: size.height - margin.top - margin.bottom)

                view.layoutSubviews()
                top += size.height
            }
        }
    }
}
