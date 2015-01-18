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
        it('should save a new attack node', function (done) {
            createAttackNode(function (err, aNode) {
                aNode.services.create({ port_id: 80, service_name: 'http' }, function () {
                    expect(aNode.services.count).to.be(1);
                    done();
                });
            });
        });
    });
});
