/*
--- Day 3: Perfectly Spherical Houses in a Vacuum ---

Santa is delivering presents to an infinite two-dimensional grid of houses.

He begins by delivering a present to the house at his starting location,
and then an elf at the North Pole calls him via radio and tells him where to
move next. Moves are always exactly one house to the north (^), south (v),
east (>), or west (<). After each move, he delivers another present to the
house at his new location.

However, the elf back at the north pole has had a little too much eggnog,
and so his directions are a little off, and Santa ends up visiting some
houses more than once. How many houses receive at least one present?

For example:

> delivers presents to 2 houses: one at the starting location
    and one to the east.
^>v< delivers presents to 4 houses in a square, including twice to the
    house at his starting/ending location.
^v^v^v^v^v delivers a bunch of presents to some very lucky children at only
    2 houses.
*/
var fs = require('fs');
var input = fs.readFileSync('puzzle3_data.txt').toString();

console.log(givePresents(input));


function givePresents(directions) {
    //takes a string of directions and returns a direct route with no backtracks
    var moves = [], place = [0, 0], presents = 1;
    moves.push(place);

    for (var i = 0, l = directions.length; i < l; i++) {
        place = travel(place, directions[i]);
        if (indexOf(moves, place, isArrayCopy) === -1) {
            presents++;
        }
        moves.push(place);
    }

    return presents;

    function isArrayCopy(arr1, arr2) {
        var i = arr1.length;
        if (i !== arr2.length) {
            return false;
        }
        while (i--) {
            if (arr1[i] !== arr2[i]) {
                return false;
            }
        }
        return true;
    }

    function indexOf(arr, val, comparer) {
        for (var i = 0, l = arr.length; i < l; i++) {
            if (i in arr && comparer(arr[i], val)) {
                return i;
            }
        }
        return -1;
    }

    function travel(current, dir) {
        var curr = current.slice();
        if (dir === '^') {
            curr[1]++;
        } else if (dir === 'v') {
            curr[1]--;
        } else if (dir === '<') {
            curr[0]--;
        } else {
            curr[0]++;
        }
        return curr;
    }
}

/*
--- Part Two ---

The next year, to speed up the process, Santa creates a robot version of
himself, Robo-Santa, to deliver presents with him.

Santa and Robo-Santa start at the same location (delivering two presents to the
same starting house), then take turns moving based on instructions from the
elf, who is eggnoggedly reading from the same script as the previous year.

This year, how many houses receive at least one present?

For example:

^v delivers presents to 3 houses, because Santa goes north, and then
    Robo-Santa goes south.
^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end up
    back where they started.
^v^v^v^v^v now delivers presents to 11 houses, with Santa going one direction
and Robo-Santa going the other.

*/

console.log(givePresentsWithRobot(input));

function givePresentsWithRobot(directions) {
    //takes a string of directions and returns a direct route with no backtracks
    var moves = [], santa = [0, 0], robot = [0, 0], presents = 1;
    moves.push([0, 0]);

    for (var i = 0, l = directions.length; i < l; i++) {
        if (i % 2 === 0) {
            santa = travel(santa, directions[i]);
            if (!hasVisited(santa)) {
                presents++;
            }
            moves.push(santa);
        } else {
            robot = travel(robot, directions[i]);
            if (!hasVisited(robot)) {
                presents++;
            }
            moves.push(robot);
        }
    }

    return presents;

    function hasVisited(traveler) {
        return indexOf(moves, traveler, isArrayCopy) > -1;
    }

    function isArrayCopy(arr1, arr2) {
        var i = arr1.length;
        if (i !== arr2.length) {
            return false;
        }
        while (i--) {
            if (arr1[i] !== arr2[i]) {
                return false;
            }
        }
        return true;
    }

    function indexOf(arr, val, comparer) {
        for (var i = 0, l = arr.length; i < l; i++) {
            if (i in arr && comparer(arr[i], val)) {
                return i;
            }
        }
        return -1;
    }

    function travel(current, dir) {
        var curr = current.slice();
        if (dir === '^') {
            curr[1]++;
        } else if (dir === 'v') {
            curr[1]--;
        } else if (dir === '<') {
            curr[0]--;
        } else {
            curr[0]++;
        }
        return curr;
    }
}
