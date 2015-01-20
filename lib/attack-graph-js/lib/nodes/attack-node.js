const attackGraph = require('../../'),
      serviceNode = require('./service-node.js');

var attackNode = Object.create(attackGraph.base);
attackNode.primaryKey('addr');
attackNode.baseInstance = Object.create(attackGraph.baseInstance);
attackNode.basePath('/nodes');

attackNode.hasMany('services', serviceNode);

module.exports = attackNode;
