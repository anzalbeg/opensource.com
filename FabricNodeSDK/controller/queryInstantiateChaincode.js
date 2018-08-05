var queryInstantiateChaincode = require('../src/queryInstantiateChaincode.js');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');

//Query for Channel instantiated chaincodes
exports.queryInstantiateChaincodefunc =  async function(peer,channelName,username,orgname) {
	logger.debug('================ GET INSTANTIATED CHAINCODES ======================');
	logger.debug('channelName : ' +channelName);
	let result = await queryInstantiateChaincode.getInstalledChaincodes(peer, channelName, 'instantiated',username,orgname);
	return result;
};
