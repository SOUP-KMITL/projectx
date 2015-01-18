const attackGraph = require('../../');

var serviceNode = Object.create(attackGraph.base);
serviceNode.primaryKey('port_id');
serviceNode.baseInstance = Object.create(attackGraph.baseInstance);
serviceNode.basePath('/services');
serviceNode.hasMany('vulnerabilities', 'vulns');

module.exports = serviceNode;
