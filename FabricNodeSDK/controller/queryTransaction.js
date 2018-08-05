var queryTransaction = require('../src/queryTransaction.js');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');

exports.queryTransactionfunc =  async function(peer, channelName, trxnId,username,orgname) {
	logger.debug('channelName : ' +channelName);
	if (!trxnId) {
		res.json(getErrorMessage('\'trxnId\''));
		return;
	}

	let message = await queryTransaction.getTransactionByID(peer, channelName, trxnId,username,orgname);
	//res.send(message);
	return message;
};