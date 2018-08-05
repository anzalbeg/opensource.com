var invokeChaincode = require('../src/invoke-transaction.js');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');

// Invoke transaction on chaincode on target peers
exports.invokefunc = async function(peers,channelName,chaincodeName,fcn,args,username,orgname,reqBodyKeyArrayresult) {
	logger.debug('==================== INVOKE ON CHAINCODE ==================');
	logger.debug('channelName  : ' + channelName);
	logger.debug('chaincodeName : ' + chaincodeName);
	logger.debug('fcn  : ' + fcn);
	logger.debug('args  : ' + args);

	let validJson;
	if( typeof(args) == 'undefined' || typeof(fcn) == 'undefined') {
		return getErrorMessage.getErrorMessage("compare",["args","fcn"],reqBodyKeyArrayresult);
	}
	if (!args && !fcn) {
		return getErrorMessage.getErrorMessage('args, fcn fields are ');
	}
	if (!fcn) {
		return getErrorMessage.getErrorMessage('fcn');
	}
	try {
		JSON.parse(args[0]);
		validJson = true;
	} catch (e) {
		validJson =  false;
	}
	if (!validJson) {
		return "args is not in valid json format";
	}

	let result = await invokeChaincode.invokeChaincode(peers,channelName, chaincodeName, fcn, args, username, orgname);
	return result;
};


function isJson(str) {
	try {
		JSON.parse(str);
	} catch (e) {
		return false;
	}
	return true;
  }