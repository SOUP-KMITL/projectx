const attackGraph = require('../../');

var serviceNode = Object.create(attackGraph.base);
serviceNode.baseInstance = Object.create(attackGraph.baseInstance);
serviceNode.basePath('/services');
serviceNode.hasMany('vulnerabilities');

module.exports = serviceNode;
