var queryBlock = require('../src/queryBlock.js');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');
//  Query Get Block by BlockNumber
exports.queryBlockfunc = async function(peer,blockId,channelName,username,orgname) {
	logger.debug('channelName : ' + channelName);
	logger.debug('BlockID : ' + blockId);
	logger.debug('Peer : ' + peer);
	if (!blockId) {
		res.json(getErrorMessage('\'blockId\''));
		return;
	}
	let result = await queryBlock.getBlockByNumber(peer,channelName, blockId, username,orgname);
	return result;
};
