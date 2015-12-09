/*
--- Part Two ---

You just finish implementing your winning light pattern when you realize you
mistranslated Santa's message from Ancient Nordic Elvish.

The light grid you bought actually has individual brightness controls; each
light can have a brightness of zero or more. The lights all start at zero.

The phrase turn on actually means that you should increase the brightness of
those lights by 1.

The phrase turn off actually means that you should decrease the brightness of
those lights by 1, to a minimum of zero.

The phrase toggle actually means that you should increase the brightness of
those lights by 2.

What is the total brightness of all lights combined after following
Santa's instructions?

For example:

turn on 0,0 through 0,0 would increase the total brightness by 1.
toggle 0,0 through 999,999 would increase the total brightness by 2000000.
 */

var fs = require("fs");
var input = fs.readFileSync("puzzle6_data.txt").toString();
input = input.split("\n");
input.pop();
input = input.map(function(line) {
	return line.split(" ").filter(function(item) {
		return !(item === "turn" || item === "through");
	});
});

var grid = createSquareGrid(1000);
lightGrid(input, grid);
console.log(countLightsOn(grid));

function countLightsOn(grid) {
	return grid.reduce(function(prev, curr) {
		prev += curr.reduce(function(count, brightness) {
			count += brightness;
			return count;
		}, 0);
		return prev;
	}, 0);
}

function lightGrid(input, grid) {
	input.forEach(function(move) {
		var lower = getCoord(move[1]), upper = getCoord(move[2]);
		if (move[0] === "off") {
			switchOffRect(grid, lower, upper);
		} else if (move[0] === "on") {
			switchOnRect(grid, lower, upper);
		} else {
			toggleRect(grid, lower, upper);
		}
	});
}

function getCoord(str) {
	return str.split(",").map(function(num) {
		return parseInt(num, 10);
	});
}

function switchOffRect(grid, lower, upper) {
	for (var i = lower[0]; i <= upper[0]; i++) {
		for (var j = lower[1]; j <= upper[1]; j++) {
			if (grid[i][j]) {
				grid[i][j] -= 1;
			}
		}
	};
}

function switchOnRect(grid, lower, upper) {
	for (var i = lower[0]; i <= upper[0]; i++) {
		for (var j = lower[1]; j <= upper[1]; j++) {
			grid[i][j] += 1;
		}
	};
}

function toggleRect(grid, lower, upper) {
	for (var i = lower[0]; i <= upper[0]; i++) {
		for (var j = lower[1]; j <= upper[1]; j++) {
			grid[i][j] += 2;
		}
	};
}

function createRow(n) {
	var row = [];
	for (var i = 0; i < n; i++) {
		row.push(0);
	};
	return row;
}

function createSquareGrid(n) {
	var arr = [];
	for (var i = 0; i < n; i++) {
		arr[i] = createRow(n);
	}
	return arr;
}
