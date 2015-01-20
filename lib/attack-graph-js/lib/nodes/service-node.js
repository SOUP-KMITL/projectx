const attackGraph = require('../../'),
      vulnNode = require('./vulnerability-node.js');

var serviceNode = Object.create(attackGraph.base);
serviceNode.primaryKey('port_id');
serviceNode.baseInstance = Object.create(attackGraph.baseInstance);
serviceNode.basePath('/services');
serviceNode.hasMany('vulnerabilities', vulnNode);

module.exports = serviceNode;
