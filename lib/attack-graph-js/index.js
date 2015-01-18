const request = require('request');

var attackGraph = {
    sessionId: null
};

attackGraph.clear = function (cb) {
    request.del('http://localhost:9292/', function (err, res, body) {
        if (!err && res.statusCode == 200) {
            cb(null);
        } else {
            cb(new Error('Something went wrong when clear attack graph db'));
        }
    });
}

attackGraph.createSession = function (cb) {
    request.post('http://localhost:9292/sessions/', function (err, res, body) {
        if (!err && res.statusCode == 200) {
            cb(null, JSON.parse(body).id);
        } else {
            cb(new Error('Something went wrong when creating new session'));
        }
    })
}

attackGraph.withSession = function (sessionId, cb) {
    var oldSessionId = attackGraph.sessionId;
    attackGraph.sessionId = sessionId;
    cb();
    attackGraph.sessionId = oldSessionId;
}

attackGraph.base = {
    count: function (cb) {
        request.get('http://localhost:9292/sessions/' + attackGraph.sessionId + this._basePath, function (err, res, body) {
            if (!err && res.statusCode == 200) {
                cb(null, JSON.parse(body).length);
            } else {
                cb(new Error('Something went wrong: count'));
            }
        });
    },
    _primaryKey: null,
    _parent: null,
    _basePath: null,
    create: function (o, cb) {
        var node = this.new(o);
        node.save(cb);
    },
    all: function () {
        request.get('http://localhost:9292/sessions/', function (err, res, body) {
            if (!er && res.statusCode == 200) {
                cb(null, JSON.parse(body));
            } else {
                cb(new Error('Something went wrong when getting all attack nodes'));
            }
        });
    },
    basePath: function (path) {
        this._basePath = path;
        this.baseInstance._basePath = path;
    },
    primaryKey: function (keyName) {
        this._primaryKey = keyName;
    },
    hasMany: function (nodes, nodesPath) {
        Object.defineProperty(
            this.baseInstance,
            nodes,
            {
                get: function () {
                    var node = this;

                    if (this._has_nodes === undefined) {
                        this._has_nodes = []; // FIXME load from server first

                        // alias to length
                        Object.defineProperty(
                            this._has_nodes,
                            'count',
                            {
                                get: function () { return this.length },
                                enumerable: true
                            }
                        );

                        this._has_nodes.create = function (o, cb) {
                            var newNode = o;
                            request.post({ url: 'http://localhost:9292/sessions/' + attackGraph.sessionId + node._baseSingularPath() + '/' + (nodesPath || nodes),
                                form: { properties: o }}, function (err, res, body) {
                                    if (!err && res.statusCode === 200) {
                                        newNode._parent = node;
                                        node._has_nodes.push(newNode);
                                        cb(null, newNode);
                                    }
                                    else
                                        cb(new Error('Something went wrong: creating new association'));
                            });
                        };
                    }

                    this._has_nodes.forEach(function (n) {
                        n._parent = this;
                    }, this);

                    return this._has_nodes;
                }
            }
        );
    }
};

attackGraph.base['new'] = function (o) {
    var oo = Object.create(this.baseInstance);
    for (var attr in o) {
        if (o.hasOwnProperty(attr))
            oo[attr] = o[attr];
    }

    var base = this;
    Object.defineProperty(oo, '_base', { value: base });

    return oo;
};

attackGraph.baseInstance = {
    _parent: null,
    _basePath: null,
    _baseCollectionPath: function () {
        if (!this._parent) {
            return this._basePath;
        } else {
            return this._parent._baseSingularPath() + this._basePath;
        }
    },
    _baseSingularPath: function () {
        return this._baseCollectionPath() + '/' + this[this._base._primaryKey];
    },
    save: function (cb) {
        var node = this;
        request.post({ url: 'http://localhost:9292/sessions/' + attackGraph.sessionId + this._baseCollectionPath(), form: { properties: this }}, function (err, res, body) {
            if (!err && res.statusCode == 200)
                cb(null, node);
            else
                cb(new Error('Something went wrong: save()'));
        });
    },
    destroy: function () {
        return "destroy path is blah blah : " + this._baseCollectionPath();
    }
};

module.exports = attackGraph;

attackGraph.attackNode  = require('./lib/nodes/attack-node');
attackGraph.serviceNode = require('./lib/nodes/service-node');
attackGraph.vulnNode    = require('./lib/nodes/vulnerability-node');
