import UIKit

class TableViewCell<T: UIView>: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    let view = T()

    override var contentView: UIView {
        return view
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layoutIfNeeded()
        var contentSize = view.sizeThatFits(CGSize(width: view.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        if let layout = view as? LinearLayout {
            contentSize.height = max(contentSize.height, layout.layoutParams.minHeight)
        }

        return CGSize(width: size.width, height: ceil(contentSize.height + 0.5))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Private

    private var cellSize = CGSize.zero

    private func setup() {
        let view = UIView()
        view.backgroundColor = UIColor(red: 65.5 / 100, green: 83.1 / 100, blue: 100 / 100, alpha: 0.5)
        selectedBackgroundView = view
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        addSubview(self.view)
    }
}
