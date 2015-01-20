var expect = require('expect.js');
var attackGraph = require('../');

function createAttackNode(cb) {
    var a = attackGraph.attackNode.create({ addr: '192.168.99.102', addrtype: 'ipv4' }, cb);
}

function createAttackNodeAndHttpService(cb) {
    createAttackNode(function (err, aNode) {
        var sNode = attackGraph.serviceNode.new({ port_id: 80, service_name: 'http' });
        aNode.services.create(sNode, function (err, savedSNode) {
            if (err) throw err;
            cb(null, savedSNode);
        });
    });
}

describe('vulnNode', function () {
    beforeEach(function (done) {
        attackGraph.clear(function (err) {
            if (err) throw err;
            attackGraph.createSession(function (err, sessId) {
                if (err) throw err;
                attackGraph.sessionId = sessId;
                done();
            });
        });
    });

    describe('#create()', function () {
        it('should save a new attack node', function (done) {
            createAttackNodeAndHttpService(function (err, sNode) {
                sNode.vulnerabilities.create({ name: 'xss', severity: 7 }, function () {
                    expect(sNode.vulnerabilities.count).to.be(1);
                    done();
                });
            });
        });
    });
});

