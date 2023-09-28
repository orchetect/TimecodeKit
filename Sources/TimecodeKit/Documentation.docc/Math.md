# Math

Performing mathematical calculations between timecodes.

Math operations are possible by either methods or operators.

Addition and subtraction may be performed using two timecode operands to produce a timecode result.

- `Timecode` + `Timecode` = `Timecode`
- `Timecode` - `Timecode` = `Timecode`

Multiplication and division may be performed using one timecode operand and one floating-point number operand. This forms a calculation of timecode (position or duration) against a number of iterations or subdivisions.

Multiplying timecode against timecode in order to produce a timecode result is not possible since it is ambiguous and considered undefined behavior.

- `Timecode` * `Double` = `Timecode`
- `Timecode` * `Timecode` is undefined and therefore not implemented
- `Timecode` / `Double` = `Timecode`
- `Timecode` / `Timecode` = `Double`

## Arithmetic Operators

Arithmetic operators are provided for convenience. These operators employ the ``Timecode/ValidationRule/wrapping`` validation rule in the event of underflows or overflows.

```swift
let tc1 = try "01:00:00:00".timecode(at: .fps23_976)
let tc2 = try "00:02:00:00".timecode(at: .fps23_976)

(tc1 + tc2).stringValue() // == "01:02:00:00"
(tc1 - tc2).stringValue() // == "00:58:00:00"
(tc1 * 2.0).stringValue() // == "02:00:00:00"
(tc1 / 2.0).stringValue() // == "00:30:00:00"
tc1 / tc2 // == 30.0
```

## Arithmetic Methods

Arithmetic methods follow the same behavior as ``Timecode`` initializers whereby the operation can be completed either using validation with a throwing call, or by using validation rules to constrain the result (See ``Timecode/ValidationRule``).

The right-hand operand may be a ``Timecode`` instance, or any time source value.

- `add()` / `adding()`
- `subtract()` / `subtracting()`
- `multiply()` / `multiplying()`
- `divide()` / `dividing()`

```swift
var tc1 = try "01:00:00:00".timecode(at: .fps23_976)
var tc2 = try "00:00:02:00".timecode(at: .fps23_976)

// in-place mutation
try tc1.add(tc2)
try tc1.add(tc2, by: wrapping) // using result validation rule

// return a new instance
let tc3 = try tc1.adding(tc2)
let tc3 = try tc1.adding(tc2, by: wrapping) // using result validation rule
```
