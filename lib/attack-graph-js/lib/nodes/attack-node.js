const attackGraph = require('../../');

var attackNode = Object.create(attackGraph.base);
attackNode.baseInstance = Object.create(attackGraph.baseInstance);
attackNode.basePath('/nodes');
attackNode.hasMany('services');

module.exports = attackNode;
