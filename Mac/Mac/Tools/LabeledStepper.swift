import SwiftUI

public struct LabeledStepper<Label: View>: View {

    public init(
        value: Binding<Int>,
        in range: ClosedRange<Int> = 0...Int.max,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.label = label
        self._value = value
        self.range = range
    }

    @Binding public var value: Int

    public var label: () -> Label
    public var range = 0...Int.max

    private var isPlusButtonDisabled: Bool { value >= range.upperBound }
    private var isMinusButtonDisabled: Bool { value <= range.lowerBound }

    public var body: some View {

        HStack {
            label()

            Spacer()

            HStack(spacing: 0) {
                /// - Note: The action will be performed inside the `.onLongPressGesture` modifier.
                Button() {
                    value -= 1
                } label: {
                    Image(systemName: "minus")
                }
                    .frame(width: 48, height: 34)
                    .disabled(isMinusButtonDisabled)
                    .foregroundColor(
                        isMinusButtonDisabled
                        ? .gray
                        : .primary
                    )
                    .contentShape(Rectangle())
                
                Divider()
                    .padding([.top, .bottom], 8)
                
                Text("\(value)")
                    .frame(width: 48, height: 34)
                
                Divider()
                    .padding([.top, .bottom], 8)
                
                /// - Note: The action will be performed inside the `.onLongPressGesture` modifier.
                Button() {
                    value += 1
                } label: {
                    Image(systemName: "plus")
                }
                    .frame(width: 48, height: 34)
                    .disabled(isPlusButtonDisabled)
                    .foregroundColor(
                        isPlusButtonDisabled
                        ? .gray
                        : .primary
                    )
                    .contentShape(Rectangle())
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .frame(height: 34)
        }
        .lineLimit(1)
    }
}
struct LabeledStepper_Previews: PreviewProvider {
    struct Demo: View {
        @State private var value: Int = 5

        var body: some View {
            LabeledStepper(value: $value, in: 0...10) {
                Text("123")
            }
        }
    }

    static var previews: some View {
        Demo()
            .padding()
    }
}
