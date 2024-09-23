import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Airbnb Cereal", size: 20)
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(hex: "#040415")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Airbnb Cereal", size: 10)
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = UIColor(hex: "#CDCDD0")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(hex: "#EAECF0").cgColor
        contentView.backgroundColor = .white
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderColor = UIColor(hex: "#196EB0").cgColor
            } else {
                contentView.layer.borderColor = UIColor(hex: "#EAECF0").cgColor
            }
        }
    }
}
