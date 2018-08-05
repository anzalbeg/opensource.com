var queryAllChaincode = require('../src/queryAllChaincode.js');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');

// Query to fetch all Installed/instantiated chaincodes
exports.queryAllChaincodefunc =  async function(peer,type,username,orgname) {
	let message = await queryAllChaincode.getInstalledChaincodes(peer, null, 'installed',username,orgname)
	return message;
};
