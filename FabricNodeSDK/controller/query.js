var query = require('../src/query.js');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');

// Query on chaincode on target peer
exports.queryfunc = async function(peer,channelName,chaincodeName,fcn,args,username,orgname,reqBodyKeyArrayresult) {
	logger.debug('==================== QUERY BY CHAINCODE ==================');
	logger.debug('peer : ' + peer);
	logger.debug('channelName : ' + channelName);
	logger.debug('chaincodeName : ' + chaincodeName);
	logger.debug('fcn : ' + fcn);
	logger.debug('args : ' + args);

	if( typeof(peer) == 'undefined' || typeof(chaincodeName) == 'undefined' || typeof(channelName) == 'undefined' || typeof(fcn) == 'undefined' || typeof(args) == 'undefined') {
		return getErrorMessage.getErrorMessage("compare",["peer","chaincodeName","channelName","fcn","args"],reqBodyKeyArrayresult);
	}
	if (!peer && !channelName && !chaincodeName && !fcn && !args) {
		return getErrorMessage.getErrorMessage('peer, channelName , chaincodeName, fcn and args fields are ');
	}

	if (!peer) {
		return getErrorMessage.getErrorMessage('peer');
	}

	if (!chaincodeName) {
		return getErrorMessage.getErrorMessage('chaincodeName');
	}
	if (!channelName) {
		return getErrorMessage.getErrorMessage('channelName');
	}
	if (!fcn) {
		return getErrorMessage.getErrorMessage('fcn');
	}
	if (!args) {
		return getErrorMessage.getErrorMessage('args');
	}
	args = args.replace(/'/g, '"');
	args = JSON.parse(args);
	logger.debug(args);

	let result = await query.queryChaincode(peer, channelName, chaincodeName, args, fcn,username,orgname);
	return result;
};
