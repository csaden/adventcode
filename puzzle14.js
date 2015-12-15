/*
--- Day 14: Reindeer Olympics ---

This year is the Reindeer Olympics! Reindeer can fly at high speeds, but must
rest occasionally to recover their energy. Santa would like to know which of his
reindeer is fastest, and so he has them race.

Reindeer can only either be flying (always at their top speed) or resting
(not moving at all), and always spend whole seconds in either state.

For example, suppose you have the following Reindeer:

Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
After one second, Comet has gone 14 km, while Dancer has gone 16 km. After ten
seconds, Comet has gone 140 km, while Dancer has gone 160 km. On the eleventh
second, Comet begins resting (staying at 140 km), and Dancer continues on for a
total distance of 176 km. On the 12th second, both reindeer are resting.
They continue to rest until the 138th second, when Comet flies for another ten
seconds. On the 174th second, Dancer flies for another 11 seconds.

In this example, after the 1000th second, both reindeer are resting, and Comet
is in the lead at 1120 km (poor Dancer has only gotten 1056 km by that point).
So, in this situation, Comet would win (if the race ended at 1000 seconds).

Given the descriptions of each reindeer (in your puzzle input), after exactly
2503 seconds, what distance has the winning reindeer traveled?
*/

const fs = require('fs');

var main = function(time) {
    let reindeer = processData('puzzle14_data.txt');
    let distances = reindeer.map(function(r) {
        return r.calcDistance(time);
    });
    return Math.max.apply(null, distances);
};

var processData = function(file) {
    let input = fs.readFileSync(file).toString(), reindeer = [];
    input = input.split('\n');
    input.forEach(function(line) {
        let args = line.match(/\d+/g);
        args.unshift(line.split(' ')[0]);
        reindeer.push(new Reindeer(...args));
    });
    return reindeer;
};

var Reindeer = function(name, speed, travelTime, restTime) {
    this.name = name;
    this.speed = parseInt(speed, 10);
    this.travelTime = parseInt(travelTime, 10);
    this.restTime = parseInt(restTime, 10);
    this.points = 0;
};

Reindeer.prototype.calcDistance = function(time) {
    let cycle = this.travelTime + this.restTime;
    return (this.speed * this.travelTime * Math.floor((time / cycle))) + (this.speed * Math.min(this.travelTime, time % cycle));
};

console.log(main(2503));

/*
--- Part Two ---

Seeing how reindeer move in bursts, Santa decides he's not pleased with the old
scoring system.

Instead, at the end of each second, he awards one point to the reindeer
currently in the lead. (If there are multiple reindeer tied for the lead,
they each get one point.) He keeps the traditional 2503 second time limit,
of course, as doing otherwise would be entirely ridiculous.

Given the example reindeer from above, after the first second, Dancer is in the
lead and gets one point. He stays in the lead until several seconds into Comet's
second burst: after the 140th second, Comet pulls into the lead and gets his
first point. Of course, since Dancer had been in the lead for the 139 seconds
before that, he has accumulated 139 points by the 140th second.

After the 1000th second, Dancer has accumulated 689 points, while poor Comet,
our old champion, only has 312. So, with the new scoring system, Dancer would
win (if the race ended at 1000 seconds).

Again given the descriptions of each reindeer (in your puzzle input), after
exactly 2503 seconds, how many points does the winning reindeer have?
 */
var getWinningReindeer = function(reindeer) {
    let maxPoints = -Infinity;
    reindeer.forEach(function(r) {
        if (r.points > maxPoints) {
            maxPoints = r.points;
        }
    });
    return maxPoints;
};

var getAllIndices = function(array, element) {
    let indices = [];
    let i = array.indexOf(element);
    while (i != -1) {
        indices.push(i);
        i = array.indexOf(element, i + 1);
    }
    return indices;
};

var addPoints = function(reindeer, time) {
    let currMaxDistance, distances;
    distances = reindeer.map(function(r) {
        return r.calcDistance(time);
    });
    currMaxDistance = Math.max.apply(null, distances);
    // find indices (i) in distance array that have currMaxDistance
    getAllIndices(distances, currMaxDistance).forEach(function(curr) {
        // add one point to each reindeer at index i
        reindeer[curr].points += 1;
    });
};

var main2 = function(time) {
    let reindeer = processData('puzzle14_data.txt'), curr = 0;
    while (curr < time) {
        curr++;
        addPoints(reindeer, curr);
    }
    return getWinningReindeer(reindeer);
};

console.log(main2(2503));
