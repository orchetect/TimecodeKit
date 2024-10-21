//
//  DoubleMathExpressionView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct DoubleMathExpressionView: View {
    var operation: MathOperation
    @TimecodeState var lhs: Timecode
    @State var rhs: Double
    
    @TimecodeState private var result: Timecode
    
    init(operation: MathOperation, lhs: Timecode, rhs: Double) {
        self.operation = operation
        self.rhs = rhs
        self.lhs = lhs
        result = operation.result(lhs: lhs, rhs: rhs)
    }
    
    var body: some View {
        LabeledContent("") {
            Grid(alignment: .trailing) {
                GridRow {
                    Color.clear
                        .gridCellUnsizedAxes([.horizontal, .vertical])
                    TimecodeField(timecode: $lhs)
                }
                GridRow {
                    operation.image
                    TextField("Value", value: $rhs, format: .number.precision(.fractionLength(2)))
                        #if !os(macOS)
                        .keyboardType(.decimalPad)
                        #endif
                        .labelsHidden()
                }
                GridRow {
                    Rectangle().fill(.primary).frame(height: 2)
                        .gridCellColumns(2)
                        .gridCellUnsizedAxes([.horizontal, .vertical])
                }
                GridRow {
                    Color.clear
                        .gridCellUnsizedAxes([.horizontal, .vertical])
                    TimecodeText(result)
                        .foregroundStyle(.tint)
                }
            }
        }
        
        .onChange(of: rhs, initial: true) { _, _ in
            result = operation.result(lhs: lhs, rhs: rhs)
        }
        .onChange(of: lhs, initial: true) { _, _ in
            result = operation.result(lhs: lhs, rhs: rhs)
        }
    }
}

extension DoubleMathExpressionView {
    enum MathOperation {
        case multiply
        case divide
        
        var image: Image {
            switch self {
            case .multiply:
                Image(systemName: "multiply")
            case .divide:
                Image(systemName: "divide")
            }
        }
        
        func result(lhs: Timecode, rhs: Double) -> Timecode {
            switch self {
            case .multiply:
                return lhs * rhs
            case .divide:
                guard !rhs.isZero else { return Timecode(.zero, using: lhs.properties) }
                return lhs / rhs
            }
        }
    }
}
