var queryAllChannel = require('../src/queryAllChannel.js');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');
// Query to fetch channels
exports.queryAllChannelfunc = async function(peer,username,orgname) {
	logger.debug('peer: ' + req.query.peer);
	if (!peer) {
		res.json(getErrorMessage('\'peer\''));
		return;
	}
	let result = await queryAllChannel.getChannels(peer, username, orgname);
    result;
};
