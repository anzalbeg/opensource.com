var queryHash = require('../src/queryHash.js');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');
// Query Get Block by Hash
exports.queryHashfunc =  async function(channelName,hash,peer,username,orgname) {
	logger.debug('channelName : ' +channelName);
	if (!hash) {
		res.json(getErrorMessage('\'hash\''));
		return;
	}
	let result = await queryHash.getBlockByHash(peer,channelName, hash, username, orgname);
	return result;
};
