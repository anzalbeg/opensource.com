var queryChannel = require('../src/queryChannel.js');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');
//Query for Channel Information
exports.queryChannelfunc =  async function(channelName,peer,username,orgname) {
	logger.debug('================ GET CHANNEL INFORMATION ======================');
	logger.debug('channelName : ' +channelName);
	let result = await queryChannel.getChainInfo(peer, channelName, username,orgname);
	return result;
};
