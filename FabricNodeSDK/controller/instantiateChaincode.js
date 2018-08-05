var instantiateChaincode = require('../src/instantiate-chaincode');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');

exports.instantiateChaincodefunc = async function(peers,channelName,chaincodeName,chaincodeVersion,fcn,chaincodeType,args,username,orgname,upgradeChaincode,reqBodyKeyArrayresult) {
	logger.debug('==================== INSTANTIATE CHAINCODE ==================');
	logger.debug('peers  : ' + peers);
	logger.debug('channelName  : ' + channelName);
	logger.debug('chaincodeName : ' + chaincodeName);
	logger.debug('chaincodeVersion  : ' + chaincodeVersion);
	logger.debug('chaincodeType  : ' + chaincodeType);
	logger.debug('args  : ' + args);

	if( typeof(args) == 'undefined' || typeof(channelName) == 'undefined' || typeof(chaincodeName) == 'undefined' || typeof(chaincodeVersion) == 'undefined' || typeof(chaincodeType) == 'undefined') {
		return getErrorMessage.getErrorMessage("compare",["args","channelName","chaincodeName","chaincodeVersion","chaincodeType"],reqBodyKeyArrayresult);
	}
	if (!args && !chaincodeName && !channelName && !chaincodeVersion && !chaincodeType) {
		return getErrorMessage.getErrorMessage('args, channelName , chaincodeName, chaincodeVersion and chaincodeType fields are ');
	}

	if (!chaincodeName) {
		return getErrorMessage.getErrorMessage('\'chaincodeName\'');
	}
	if (!chaincodeVersion) {
		return getErrorMessage.getErrorMessage('\'chaincodeVersion\'');
	}
	if (!channelName) {
		return getErrorMessage.getErrorMessage('\'channelName\'');
	}
	if (!chaincodeType) {
		return getErrorMessage.getErrorMessage('\'chaincodeType\'');
	}
	if (!args) {
		return getErrorMessage.getErrorMessage('\'args\'');
	}

	let result = await instantiateChaincode.instantiateChaincode(peers, channelName, chaincodeName, chaincodeVersion, fcn,chaincodeType, args, username, orgname, upgradeChaincode);
	return result;
};
