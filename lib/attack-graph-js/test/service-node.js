var expect = require('expect.js');
var attackGraph = require('../');

function createAttackNode(cb) {
    var a = attackGraph.attackNode.create({ addr: '192.168.99.102', addrtype: 'ipv4' }, cb);
}

describe('serviceNode', function () {
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
        it('should craete a new service node', function (done) {
            createAttackNode(function (err, aNode) {
                aNode.services.create({ port_id: 80, service_name: 'http' }, function () {
                    expect(aNode.services.count).to.be(1);
                    done();
                });
            });
        });
    });

    describe('#find() [Association]', function () {
        it('should craete a new service node', function (done) {
            createAttackNode(function (err, aNode) {
                aNode.services.create({ port_id: 80, service_name: 'http' }, function () {
                    aNode.services.find(80, function (err, sNode) {
                        if (err) throw err;
                        expect(sNode.port_id).to.be('80');
                        expect(sNode.service_name).to.be('http');
                        done();
                    });
                });
            });
        });
    });
});
