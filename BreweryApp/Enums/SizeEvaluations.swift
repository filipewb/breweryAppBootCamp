enum SizeEvaluations: String {
    case single = "avaliação"
    case multiple = "avaliações"
    
    static func stringSize(for value: Int) -> String {
        let stringEvaluation: String
        switch value {
        case 0, 1:
            stringEvaluation = "\(value) \(SizeEvaluations.single.rawValue)"
        case 2...500:
            stringEvaluation = "\(value) \(SizeEvaluations.multiple.rawValue)"
        default:
            stringEvaluation = "+500 \(SizeEvaluations.multiple.rawValue)"
        }
        return stringEvaluation
    }
}
