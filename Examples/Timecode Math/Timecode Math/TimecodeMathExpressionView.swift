//
//  TimecodeMathExpressionView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct TimecodeMathExpressionView: View {
    var operation: MathOperation
    @TimecodeState var lhs: Timecode
    @TimecodeState var rhs: Timecode
    
    @TimecodeState private var result: Timecode
    
    init(operation: MathOperation, lhs: Timecode, rhs: Timecode) {
        self.operation = operation
        self.lhs = lhs
        self.rhs = rhs
        self.result = operation.result(lhs: lhs, rhs: rhs)
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
                    TimecodeField(timecode: $rhs)
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
        
        .onChange(of: [rhs, lhs], initial: true) { _, _ in
            result = operation.result(lhs: lhs, rhs: rhs)
        }
    }
}

extension TimecodeMathExpressionView {
    enum MathOperation {
        case add
        case subtract
        
        var image: Image {
            switch self {
            case .add:
                Image(systemName: "plus")
            case .subtract:
                Image(systemName: "minus")
            }
        }
        
        func result(lhs: Timecode, rhs: Timecode) -> Timecode {
            switch self {
            case .add:
                return lhs + rhs
            case .subtract:
                return lhs - rhs
            }
        }
    }
}
