/*
--- Day 9: All in a Single Night ---

Every year, Santa manages to deliver all of his presents in a single night.

This year, however, he has some new locations to visit; his elves have provided
him the distances between every pair of locations. He can start and end at any
two (different) locations he wants, but he must visit each location exactly
once. What is the shortest distance he can travel to achieve this?

For example, given the following distances:

London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141
The possible routes are therefore:

Dublin -> London -> Belfast = 982
London -> Dublin -> Belfast = 605
London -> Belfast -> Dublin = 659
Dublin -> Belfast -> London = 659
Belfast -> Dublin -> London = 605
Belfast -> London -> Dublin = 982
The shortest of these is London -> Dublin -> Belfast = 605, and so the answer
is 605 in this example.

What is the distance of the shortest route?

*/
let fs = require('fs');

let Graph = function() {
    this.graph = {};
};

Graph.prototype.hasNode = function(node) {
    return this.graph.hasOwnProperty(node);
};

Graph.prototype.addNode = function(node) {
    if (!this.hasNode(node)) {
        this.graph[node] = [];
    }
};

Graph.prototype.makeEdge = function(toNode, fromNode, distance) {
    return {
        'to': toNode,
        'from': fromNode,
        'd': parseInt(distance, 10)
    };
};

Graph.prototype.addEdge = function(toNode, fromNode, distance) {
    this.addNode(toNode);
    this.addNode(fromNode);
    this.graph[fromNode].push(this.makeEdge(toNode, fromNode, distance));
    this.graph[toNode].push(this.makeEdge(fromNode, toNode, distance));
};

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

const CITIES = [
    'AlphaCentauri',
    'Snowdin',
    'Tambi',
    'Faerun',
    'Norrath',
    'Straylight',
    'Tristram',
    'Arbre'
];

let routes = permutator(CITIES);
let g = new Graph();

let input = fs.readFileSync('puzzle9_data.txt').toString();
input.split('\n').map(function(edge) {
    let path;
    edge = edge.replace(/to /, '');
    edge = edge.replace(/= /, '');
    path = edge.split(' ');
    g.addEdge(path[0], path[1], path[2]);
});

console.log(Math.min.apply(null, routes.map(getRouteDistance)));
console.log(Math.max.apply(null, routes.map(getRouteDistance)));

function getRouteDistance(route) {
    let dist = 0, edges;
    for (let i = 0, l = route.length; i < l - 1; i++) {
        edges = g.graph[route[i]];
        edges.forEach(function(edge) {
            if (edge.to === route[i + 1]) {
                dist += edge.d;
            }
        });
    }
    return dist;
}