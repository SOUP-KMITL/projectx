var expect = require('expect.js');
var attackGraph = require('../');

describe('attackNode', function () {
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
        it('should create a new attack node', function (done) {
            var a = attackGraph.attackNode.new({ addr: '192.168.99.102', addrtype: 'ipv4' });
            a.save(function (err) {
                attackGraph.attackNode.count(function (err, count) {
                    expect(count).to.be(1);
                    done();
                });
            });
        });
    });
});
