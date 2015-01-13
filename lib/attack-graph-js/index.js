const request = require('request');

var attackGraph = {
    sessionId = null;
};

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

module.exports = attackGraph;
