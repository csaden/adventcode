/*
--- Day 18: Like a GIF For Your Yard ---

After the million lights incident, the fire code has gotten stricter:
now, at most ten thousand lights are allowed. You arrange them in a 100x100
grid.

Never one to let you down, Santa again mails you instructions on the ideal
lighting configuration. With so few lights, he says, you'll have to resort to
animation.

Start by setting your lights to the included initial configuration
(your puzzle input). A # means "on", and a . means "off".

Then, animate your grid in steps, where each step decides the next configuration
based on the current one. Each light's next state (either on or off) depends on
its current state and the current states of the eight lights adjacent to it
(including diagonals). Lights on the edge of the grid might have fewer than
eight neighbors; the missing ones always count as "off".

For example, in a simplified 6x6 grid, the light marked A has the neighbors
numbered 1 through 8, and the light marked B, which is on an edge, only has the
neighbors marked 1 through 5:

1B5...
234...
......
..123.
..8A4.
..765.
The state a light should have next is based on its current state (on or off)
plus the number of neighbors that are on:

A light which is on stays on when 2 or 3 neighbors are on, and turns off
otherwise.
A light which is off turns on if exactly 3 neighbors are on, and stays off
otherwise.
All of the lights update simultaneously; they all consider the same current
state before moving to the next.

Here's a few steps from an example configuration of another 6x6 grid:

Initial state:
.#.#.#
...##.
#....#
..#...
#.#..#
####..

After 1 step:
..##..
..##.#
...##.
......
#.....
#.##..

After 2 steps:
..###.
......
..###.
......
.#....
.#....

After 3 steps:
...#..
......
...#..
..##..
......
......

After 4 steps:
......
......
..##..
..##..
......
......
After 4 steps, this example has four lights on.

In your grid of 100x100 lights, given your initial configuration, how many
lights are on after 100 steps?
*/
const fs = require('fs');
const lights = processData("puzzle18_data.txt");
console.log(countOnLights(animateLights(lights, false)));
console.log(countOnLights(animateLights(lightCorners(lights), true)));

function processData(file) {
  let input = fs.readFileSync(file).toString();
  input = input.split('\n');
  input = input.map(function(row) {
    return processLights(row);
  });
  return input;
}

function processLights(row) {
  row = row.split('');
  return row.map(function(chr) {
    if (chr === '.') {
      return false;
    }
    else {
      return true;
    }
  });
}

function animateLights(grid, isConwayGame) {
  for (let i = 0; i < 100; i++) {
    grid = updateLightGrid(grid, isConwayGame);
  }
  return grid;
}

function countOnLights(grid) {
  let onCount = 0;
  for (var i = 0; i < grid.length; i++) {
    for (var j = 0; j < grid.length; j++) {
      if (grid[i][j]) {
        onCount++;
      }
    }
  }
  return onCount;
}

function lightCorners(grid) {
  const i = grid.length-1;
  grid[0][0] = true;
  grid[0][i] = true;
  grid[i][0] = true;
  grid[i][i] = true;
  return grid;
}

function updateLightGrid(grid, isConwayGame) {
  var newGrid = [];
  for (let i = 0; i < 100; i++) {
    let row = [];
    for (let j = 0; j < 100; j++) {
      row.push(getNextLightState(i, j, grid));
    }
    newGrid.push(row);
  };
  if (isConwayGame) {
    newGrid = lightCorners(newGrid);
  }
  return newGrid;
}

function getNextLightState(i, j, grid) {
  let nextLightState = null;
  const onCount = getOnNeighborCount(i, j, grid);
  if (grid[i][j] && (onCount === 2 || onCount === 3)) {
    nextLightState = true;
  } else if (!grid[i][j] && onCount === 3) {
    nextLightState = true;
  } else {
    nextLightState = false;
  }
  return nextLightState;
}

function getOnNeighborCount(i, j, grid) {
  let onLightCount = 0;
  const neighbors = [
    [i-1, j],
    [i-1, j-1],
    [i, j-1],
    [i+1, j-1],
    [i+1, j],
    [i+1, j+1],
    [i, j+1],
    [i-1, j+1]
  ];
  for (let idx = 0, l = neighbors.length; idx < l; idx++) {
    let x = neighbors[idx][0], y = neighbors[idx][1];
    if (isValidIndex(neighbors[idx]) && grid[x][y]) {
      onLightCount++;
    }
  }
  return onLightCount;
}

function isValidIndex(pos) {
  return pos[0] >= 0 && pos[0] < 100 && pos[1] >= 0 && pos[1] < 100;
}

/*
--- Part Two ---

You flip the instructions over; Santa goes on to point out that this is all
just an implementation of Conway's Game of Life. At least, it was, until you
notice that something's wrong with the grid of lights you bought: four lights,
one in each corner, are stuck on and can't be turned off. The example above
will actually run like this:

Initial state:
##.#.#
...##.
#....#
..#...
#.#..#
####.#

After 1 step:
#.##.#
####.#
...##.
......
#...#.
#.####

After 2 steps:
#..#.#
#....#
.#.##.
...##.
.#..##
##.###

After 3 steps:
#...##
####.#
..##.#
......
##....
####.#

After 4 steps:
#.####
#....#
...#..
.##...
#.....
#.#..#

After 5 steps:
##.###
.##..#
.##...
.##...
#.#...
##...#
After 5 steps, this example now has 17 lights on.

In your grid of 100x100 lights, given your initial configuration, but with the
four corners always in the on state, how many lights are on after 100 steps?
 */