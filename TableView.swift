import UIKit

class TableView<T: UIView>: UITableView {
    convenience init() {
        self.init(frame: CGRect.zero, style: .plain)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var autoBounce = true

    func cell(_ indexPath: IndexPath) -> TableViewCell<T> {
        let cell = dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell<T>
        cell.view.setNeedsLayout()
        return cell
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if autoBounce {
            bounces = contentSize.height > frame.size.height
        }
    }

    func forceLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { self.layoutSubviews() }
    }

    // MARK: - Private

    private func setup() {
        separatorInset = UIEdgeInsets.zero
        register(TableViewCell<T>.self, forCellReuseIdentifier: "cell")
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = Styles.minTouchSize
        cellLayoutMarginsFollowReadableWidth = false
    }
}
