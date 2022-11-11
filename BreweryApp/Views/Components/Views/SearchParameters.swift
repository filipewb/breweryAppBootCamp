import Foundation
import UIKit

class SearchParameters: UIView {
    
    var tableCount: Int
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Texts.userOpinion
        titleLabel.textColor = BreweryDesignSystem.Colors.black
        titleLabel.frame = CGRect(x: 0, y: 0, width: 328, height: 23)
        titleLabel.font = BreweryDesignSystem.FontTypes.robotoMediumX
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var resultLabel: UILabel = {
        let resultLabel = UILabel()
        resultLabel.text = resultLabelText(for: tableCount)
        resultLabel.textColor = BreweryDesignSystem.Colors.black
        resultLabel.frame = CGRect(x: 0, y: 0, width: 328, height: 16)
        resultLabel.font = BreweryDesignSystem.FontTypes.quicksandRegular
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        return resultLabel
    }()
    
    private func resultLabelText(for number: Int) -> String {
        if number == 1 { return "\(number) \(Texts.resultSearch)" }
        else { return "\(number) \(Texts.resultsSearch)" }
    }
    
    init(tableCount: Int = 0) {
        self.tableCount = tableCount
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setupView()
    }
    
    private func setupView() {
        self.addSubview(titleLabel)
        self.addSubview(resultLabel)
                
        self.translatesAutoresizingMaskIntoConstraints = false
        configurateConstraints()
    }
    
    private func configurateConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            resultLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 25.0),
            resultLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
