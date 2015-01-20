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

    describe('#save()', function () {
        it('should save a new attack node', function (done) {
            var a = attackGraph.attackNode.new({ addr: '192.168.99.102', addrtype: 'ipv4' });
            a.save(function (err) {
                attackGraph.attackNode.count(function (err, count) {
                    expect(count).to.be(1);
                    done();
                });
            });
        });
    });

    describe('#create()', function () {
        it('should create a new attack node', function (done) {
            var a = attackGraph.attackNode.create({ addr: '192.168.99.102', addrtype: 'ipv4' }, function () {
                attackGraph.attackNode.count(function (err, count) {
                    expect(count).to.be(1);
                    done();
                });
            });
        });
    });

    describe('#find()', function () {
        it('should find a correct attack node', function (done) {
            var a = attackGraph.attackNode.create({ addr: '192.168.99.102', addrtype: 'ipv4' }, function () {
                attackGraph.attackNode.count(function (err, count) {
                    expect(count).to.be(1);
                    attackGraph.attackNode.find('192.168.99.102', function (err, aNode) {
                        if (err) throw err;
                        expect(aNode.addr).to.be('192.168.99.102');
                        expect(aNode.addrtype).to.be('ipv4');
                    });
                    done();
                });
            });
        });
    });
});
