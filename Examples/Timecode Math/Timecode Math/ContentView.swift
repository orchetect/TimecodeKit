//
//  ContentView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct ContentView: View {
    @State private var frameRate: TimecodeFrameRate = .fps24
    
    var body: some View {
        VStack(spacing: 20) {
            Form {
                Picker("Frame Rate", selection: $frameRate) {
                    ForEach(TimecodeFrameRate.allCases) { rate in
                        Text(rate.stringValueVerbose).id(rate)
                    }
                }
                
                ExpressionsView(frameRate: frameRate).id(frameRate)
            }
            .formStyle(.grouped)
        }
        .padding()
    }
}

struct ExpressionsView: View {
    let frameRate: TimecodeFrameRate
    
    var body: some View {
        Group {
            TimecodeMathExpressionView(
                operation: .add,
                lhs: Timecode(.components(h: 1), at: frameRate, by: .allowingInvalid),
                rhs: Timecode(.components(m: 20), at: frameRate, by: .allowingInvalid)
            )
            
            TimecodeMathExpressionView(
                operation: .subtract,
                lhs: Timecode(.components(h: 1), at: frameRate, by: .allowingInvalid),
                rhs: Timecode(.components(m: 20), at: frameRate, by: .allowingInvalid)
            )
            
            DoubleMathExpressionView(
                operation: .multiply,
                lhs: Timecode(.components(h: 1), at: frameRate, by: .allowingInvalid),
                rhs: 2.5
            )
            
            DoubleMathExpressionView(
                operation: .divide,
                lhs: Timecode(.components(h: 1), at: frameRate, by: .allowingInvalid),
                rhs: 2.5
            )
        }
        .font(.title3)
        .foregroundStyle(.primary)
        .timecodeFormat([.showSubFrames])
        .timecodeSeparatorStyle(.secondary)
        .timecodeSubFramesStyle(.secondary, scale: .secondary)
        .timecodeFieldInputStyle(.autoAdvance)
        .timecodeFieldInputWrapping(.noWrap)
        .timecodeFieldValidationPolicy(.enforceValid)
    }
}

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
                        .foregroundStyle(.accent)
                }
            }
        }
        
        .onChange(of: [rhs, lhs], initial: true) { _, _ in
            result = operation.result(lhs: lhs, rhs: rhs)
        }
    }
    
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

struct DoubleMathExpressionView: View {
    var operation: MathOperation
    @TimecodeState var lhs: Timecode
    @State var rhs: Double
    
    @TimecodeState private var result: Timecode
    
    init(operation: MathOperation, lhs: Timecode, rhs: Double) {
        self.operation = operation
        self.rhs = rhs
        self.lhs = lhs
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
                        .foregroundStyle(.accent)
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

extension Image {
    func sizeForOperation() -> some View {
        self.resizable()
            .frame(width: 30, height: 30)
    }
}

#Preview {
    ContentView()
}
