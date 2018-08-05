var installChaincode = require('../src/install-chaincode');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');
// Install chaincode on target peers
exports.installChaincodefunc =  async function(peers,chaincodeName,chaincodePath,chaincodeVersion,chaincodeType,username,orgname,reqBodyKeyArrayresult) {
	logger.debug('==================== INSTALL CHAINCODE ==================');
	logger.debug('peers : ' + peers); // target peers list
	logger.debug('chaincodeName : ' + chaincodeName);
	logger.debug('chaincodePath  : ' + chaincodePath);
	logger.debug('chaincodeVersion  : ' + chaincodeVersion);
	logger.debug('chaincodeType  : ' + chaincodeType);
	logger.debug('usrname  : ' + username);
	logger.debug('orgname  : ' + orgname);


	if( typeof(peers) == 'undefined' || typeof(chaincodeName) == 'undefined' || typeof(chaincodePath) == 'undefined' || typeof(chaincodeVersion) == 'undefined' || typeof(chaincodeType) == 'undefined') {
		return getErrorMessage.getErrorMessage("compare",["peers","chaincodeName","chaincodePath","chaincodeVersion","chaincodeType"],reqBodyKeyArrayresult);
	}
	if (!peers && !chaincodeName && !chaincodePath && !chaincodeVersion && !chaincodeType) {
		return getErrorMessage.getErrorMessage('peers, chaincodeName , chaincodePath, chaincodeVersion and chaincodeType fields are ');
	}

	if (!peers || peers.length == 0) {
		return getErrorMessage.getErrorMessage('peers');
	}
	if (!chaincodeName) {
		return getErrorMessage.getErrorMessage('chaincodeName');
	}
	if (!chaincodePath) {
		return getErrorMessage.getErrorMessage('chaincodePath');
	}
	if (!chaincodeVersion) {
		return getErrorMessage.getErrorMessage('chaincodeVersion');
	}
	if (!chaincodeType) {
		return getErrorMessage.getErrorMessage('chaincodeType');
	}
	let message = await installChaincode.installChaincode(peers, chaincodeName, chaincodePath, chaincodeVersion, chaincodeType, username, orgname)
	return message;

};
