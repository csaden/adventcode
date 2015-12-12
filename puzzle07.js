/*
--- Day 7: Some Assembly Required ---

This year, Santa brought little Bobby Tables a set of wires and bitwise
logic gates! Unfortunately, little Bobby is a little under the recommended age
range, and he needs help assembling the circuit.

Each wire has an identifier (some lowercase letters) and can carry a 16-bit
signal (a number from 0 to 65535). A signal is provided to each wire by a gate,
another wire, or some specific value. Each wire can only get a signal from one
source, but can provide its signal to multiple destinations. A gate provides
no signal until all of its inputs have a signal.

The included instructions booklet describe how to connect the parts together:
    x AND y -> z means to connect wires x and y to an AND gate, and
    then connect its output to wire z.

For example:

123 -> x means that the signal 123 is provided to wire x.

x AND y -> z means that the bitwise AND of wire x and wire y is provided
to wire z.

p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then
provided to wire q.

NOT e -> f means that the bitwise complement of the value from wire e is
provided to wire f.

Other possible gates include OR (bitwise OR) and RSHIFT (right-shift).
If, for some reason, you'd like to emulate the circuit instead, almost all
programming languages (for example, C, JavaScript, or Python) provide
operators for these gates.

For example, here is a simple circuit:

123 -> x
456 -> y
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i
After it is run, these are the signals on the wires:

d: 72
e: 507
f: 492
g: 114
h: 65412
i: 65079
x: 123
y: 456
In little Bobby's kit's instructions booklet (provided as your puzzle input),
what signal is ultimately provided to wire a?
*/

var fs = require('fs');
var input = fs.readFileSync('puzzle7_datab.txt').toString();
input = input.split('\n');

var wires = createWireMap(input);
console.log(calculate('a'));

var input = fs.readFileSync('puzzle7_datab.txt').toString();
input = input.split('\n');
console.log(calculate('b'));

function createWireMap(data) {
    var wires = {};
    data.forEach(function(line) {
        var data = line.split('->');
        wires[data[1].trim()] = data[0].trim().split(' ');
    });
    return wires;
}
// unsigned int16 [0, 2^16 - 1]  2^16 - 1 = 65535
function calculate(wire) {
    var values = {};
    return calc(wire);

    function calc(wire) {
        var res, instr;
        if (values.hasOwnProperty(wire)) {
            res = values[wire];
        } else if (typeof wire === 'string' && /^[0-9]+$/.test(wire)) {
            res = parseInt(wire, 10);
        } else {
            instr = wires[wire];
            if (instr.length === 1) {
                res = calc(instr[0]);
            } else if (instr.length === 2) {
                res = 65535 - calc(instr[1]);
            } else {
                if (instr[1] === 'AND') {
                    res = calc(instr[0]) & calc(instr[2]);
                } else if (instr[1] === 'OR') {
                    res = calc(instr[0]) | calc(instr[2]);
                } else if (instr[1] === 'LSHIFT') {
                    res = calc(instr[0]) << calc(instr[2]);
                } else {
                    res = calc(instr[0]) >> calc(instr[2]);
                }
            }
            values[wire] = res;
        }
        return res;
    }
}

/*
--- Part Two ---

Now, take the signal you got on wire a, override wire b to that signal,
and reset the other wires (including wire a). What new signal is ultimately
provided to wire a?

*/




