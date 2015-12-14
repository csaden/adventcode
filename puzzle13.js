/*
--- Day 13: Knights of the Dinner Table ---

In years past, the holiday feast with your family hasn't gone so well.
Not everyone gets along! This year, you resolve, will be different.
You're going to find the optimal seating arrangement and avoid all those
awkward conversations.

You start by writing up a list of everyone invited and the amount their
happiness would increase or decrease if they were to find themselves sitting
next to each other person. You have a circular table that will be just big
enough to fit everyone comfortably, and so each person will have exactly two
neighbors.

For example, suppose you have only four attendees planned, and you calculate
their potential happiness as follows:

Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.
Then, if you seat Alice next to David, Alice would lose 2 happiness units
(because David talks so much), but David would gain 46 happiness units
(because Alice is such a good listener), for a total change of 44.

If you continue around the table, you could then seat Bob next to Alice
(Bob gains 83, Alice gains 54). Finally, seat Carol, who sits next to Bob
(Carol gains 60, Bob loses 7) and David (Carol gains 55, David gains 41).
The arrangement looks like this:

     +41 +46
+55   David    -2
Carol       Alice
+60    Bob    +54
     -7  +83
After trying every other seating arrangement in this hypothetical scenario,
you find that this one is the most optimal, with a total change in happiness
of 330.

What is the total change in happiness for the optimal seating arrangement of
the actual guest list?
*/

/*
--- Part Two ---

In all the commotion, you realize that you forgot to seat yourself.
At this point, you're pretty apathetic toward the whole thing, and your
happiness wouldn't really go up or down regardless of who you sit next to.
You assume everyone else would be just as ambivalent about sitting next to you,
too.

So, add yourself to the list, and give all happiness relationships that involve
you a score of 0.

What is the total change in happiness for the optimal seating arrangement that
actually includes yourself?
 */

const fs = require('fs');

console.log(main());

function main() {
    let happiest = -Infinity, points = makeHappinessMap('puzzle13_datab.txt');
    let orders = makeSeatingOrders(points);
    orders.forEach(function(order) {
        let happiness = calculateHappiness(order, points);
        if (happiness > happiest) {
            happiest = happiness;
        }
    });
    return happiest;
}


function calculateHappiness(array, points) {
    let first, second, total = 0;
    for (let i = 0, l = array.length; i < l; i++) {
        if (i === l-1) {
            first = array[i];
            second = array[0];
            total += points[first][second] + points[second][first];
        } else {
            first = array[i];
            second = array[i+1];
            total += points[first][second] + points[second][first];
        }
    }
    return total;
}

function makeHappinessMap(file) {
    let input, happiness = {};
    input = fs.readFileSync(file).toString();
    input = input.split('\n');
    input.forEach(function(line) {
        line = processLine(line);
        if (!happiness[line[0]]) {
            happiness[line[0]] = {};
        }
        happiness[line[0]][line[1]] = line[2];
    });
    return happiness;
}

function makeSeatingOrders(points) {
    const PEOPLE = Array.from(new Set(Object.keys(points)));
    const pin = PEOPLE.shift();
    let seatings = permutator(PEOPLE);
    seatings.forEach(function(order) {
        order.unshift(pin);
    });
    return seatings;
}

//http://stackoverflow.com/questions/9960908/permutations-in-javascript
function permutator(inputArr) {
    const results = [];
    function permute(arr, memo) {
        let cur; memo = memo || [];
        for (let i = 0; i < arr.length; i++) {
            cur = arr.splice(i, 1);
            if (arr.length === 0) {
                results.push(memo.concat(cur));
            }
            permute(arr.slice(), memo.concat(cur));
            arr.splice(i, 0, cur[0]);
        }
        return results;
    }
    return permute(inputArr);
}

function processLine(line) {
    let parts, firstName, secondName, handlePoints, points;
    handlePoints = line.match(/(gain|lose)/)[0];
    points = parseInt(line.match(/\d+/)[0], 10);
    points = handlePoints === 'lose' ? (-1 * points) : points;
    parts = line.split(' ');
    firstName = parts[0];
    secondName = parts[parts.length-1].slice(0, -1);
    return [firstName, secondName, points];
}