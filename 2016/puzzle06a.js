/*
--- Day 6: Probably a Fire Hazard ---

Because your neighbors keep defeating you in the holiday house decorating
contest year after year, you've decided to deploy one million lights in a
1000x1000 grid.

Furthermore, because you've been especially nice this year, Santa has mailed
you instructions on how to display the ideal lighting configuration.

Lights in your grid are numbered from 0 to 999 in each direction; the lights at
each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions include
whether to turn on, turn off, or toggle various inclusive ranges given as
coordinate pairs. Each coordinate pair represents opposite corners of a
rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore refers
to 9 lights in a 3x3 square. The lights all start turned off.

To defeat your neighbors this year, all you have to do is set up your lights
by doing the instructions Santa sent you in order.

For example:

turn on 0,0 through 999,999 would turn on (or leave on) every light.
toggle 0,0 through 999,0 would toggle the first line of 1000 lights,
turning off the ones that were on, and turning on the ones that were off.
turn off 499,499 through 500,500 would turn off (or leave off) the middle
four lights.
After following the instructions, how many lights are lit?
*/

var fs = require('fs');
var input = fs.readFileSync('puzzle6_data.txt').toString();
input = input.split('\n');

input = input.map(function(line) {
    return line.split(' ').filter(function(item) {
        return !(item === 'turn' || item === 'through');
    });
});

var grid = createSquareGrid(1000);
lightGrid(input, grid);
console.log(countLightsOn(grid));

function countLightsOn(grid) {
    return grid.reduce(function(prev, curr) {
        prev += curr.reduce(function(count, light) {
            if (light) {
                count++;
            }
            return count;
        }, 0);
        return prev;
    }, 0);
}

function lightGrid(input, grid) {
    input.forEach(function(move) {
        var lower = getCoord(move[1]), upper = getCoord(move[2]);
        if (move[0] === 'off') {
            switchOffRect(grid, lower, upper);
        } else if (move[0] === 'on') {
            switchOnRect(grid, lower, upper);
        } else {
            toggleRect(grid, lower, upper);
        }
    });
}

function getCoord(str) {
    return str.split(',').map(function(num) {
        return parseInt(num, 10);
    });
}

function switchOffRect(grid, lower, upper) {
    for (var i = lower[0]; i <= upper[0]; i++) {
        for (var j = lower[1]; j <= upper[1]; j++) {
            grid[i][j] = false;
        }
    }
}

function switchOnRect(grid, lower, upper) {
    for (var i = lower[0]; i <= upper[0]; i++) {
        for (var j = lower[1]; j <= upper[1]; j++) {
            grid[i][j] = true;
        }
    }
}

function toggleRect(grid, lower, upper) {
    for (var i = lower[0]; i <= upper[0]; i++) {
        for (var j = lower[1]; j <= upper[1]; j++) {
            grid[i][j] = !grid[i][j];
        }
    }
}

function createRow(n) {
    var row = [];
    for (var i = 0; i < n; i++) {
        row.push(false);
    }
    return row;
}

function createSquareGrid(n) {
    var arr = [];
    for (var i = 0; i < n; i++) {
        arr[i] = createRow(n);
    }
    return arr;
}
