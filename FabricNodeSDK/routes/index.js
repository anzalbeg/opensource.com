var express = require('express');
var router = express.Router();
var getErrorMessage = require('./error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('indexLogger');
var bodyParser = require('body-parser');
router.use(bodyParser.json());
router.use(bodyParser.urlencoded({ extended: false }));
var jwt = require('./expressJwt/jwt').jwt;
var app = require('./expressJwt/jwt').app;
var bearerToken = require('express-bearer-token');
var util = require('util');
//require('./expressJwt/jwt').router;

var createUser = require('../controller/users.js');
var createChannel = require('../controller/createChannel.js');
var joinChannel = require('../controller/joinChannel.js');
var installChaincode = require('../controller/installChaincode.js');
var instantiateChaincode = require('../controller/instantiateChaincode.js');
var invoke = require('../controller/invokeChaincode.js');
var query = require('../controller/query.js');
var queryBlock = require('../controller/queryBlock.js');
var queryTransaction = require('../controller/queryTransaction.js');
var queryHash = require('../controller/queryHash.js');
var queryChannel = require('../controller/queryChannel.js');
var queryInstantiateChaincode = require('../controller/queryInstantiateChaincode.js');
var queryAllChaincode = require('../controller/queryAllChaincode.js');
var queryAllChannel = require('../controller/queryAllChannel.js');

router.use(bearerToken());

router.use(function(req, res, next) {
	logger.debug(' ------>>>>>> new request for %s',req.originalUrl);
	if (req.originalUrl.indexOf('/users') >= 0) {
		return next();
	}

	var token = req.token;
	logger.debug("------------------------------------------token-----------------------------------------------", req.token)
	jwt.verify(token, app.get('secret'), function(err, decoded) {
		if (err) {
			res.send({
				success: false,
				message: 'Failed to authenticate token. Make sure to include the ' +
					'token returned from /users call in the authorization header ' +
					' as a Bearer token'
			});
			return;
		} else {
			// add the decoded user name and org name to the request object
			// for the downstream code to use
			req.username = decoded.username;
			req.orgname = decoded.orgname;
			logger.debug(util.format('Decoded from JWT token: username - %s, orgname - %s', decoded.username, decoded.orgname));
			return next();
		}
	});
});

router.post('/users', async function(req, res) {
	//get all post request payload keys
	let reqBodyKeyArrayresult = reqBodyKeyFunc(req.body);
	console.log('reqBodyKeyArray---'+reqBodyKeyArrayresult)
	var username = req.body.username;
	var orgname = req.body.orgname;
	let result = await createUser.createUserfunc(username,orgname,reqBodyKeyArrayresult);
	res.send(result);
});

// create channel
router.post('/channels',async (req,res,next) => {
  let reqBodyKeyArrayresult = reqBodyKeyFunc(req.body);
  console.log("req.body.channelName----"+req.body.channelName);
  console.log("req.body.channelConfigPath----"+req.body.channelConfigPath);
  console.log("req.username----"+req.username);
  console.log("req.orgname----"+req.orgname);
  let result = await createChannel.createChannelfunc(req.body.channelName,req.body.channelConfigPath,req.body.configUpdate,req.username,req.orgname,reqBodyKeyArrayresult);
  res.send(result);
});

//join channel
router.post('/channels/:channelName/peers',async (req,res,next) => {
	let reqBodyKeyArrayresult = reqBodyKeyFunc(req.body);
	console.log('joining the channel -----'+reqBodyKeyArrayresult);
	var channelName = req.params.channelName;
	var peers = req.body.peers;
	logger.debug('channelName : ' + channelName);
	logger.debug('peers : ' + peers);
	logger.debug('username :' + req.username);
	logger.debug('orgname:' + req.orgname);
  let result = await joinChannel.joinChannelfunc(channelName, peers, req.username, req.orgname,reqBodyKeyArrayresult);
  res.send(result);
});

//install chaincode
router.post('/chaincodes', async (req, res,next) => {
	let reqBodyKeyArrayresult = reqBodyKeyFunc(req.body);
	var peers = req.body.peers;
	var chaincodeName = req.body.chaincodeName;
	var chaincodePath = req.body.chaincodePath;
	var chaincodeVersion = req.body.chaincodeVersion;
	var chaincodeType = req.body.chaincodeType;
	let result = await installChaincode.installChaincodefunc(peers, chaincodeName, chaincodePath,chaincodeVersion,chaincodeType,req.username,req.orgname,reqBodyKeyArrayresult);
  res.send(result);
});

// Instantiate chaincode on target peers
router.post('/channels/:channelName/chaincodes', async function(req, res) {
	let reqBodyKeyArrayresult = reqBodyKeyFunc(req.body);
	var peers = req.body.peers;
	var fcn = req.body.fcn;
	var chaincodeName = req.body.chaincodeName;
	var chaincodeVersion = req.body.chaincodeVersion;
	var channelName = req.params.channelName;
	var chaincodeType = req.body.chaincodeType;
	var args = req.body.args;
	let result = await instantiateChaincode.instantiateChaincodefunc(peers, channelName,chaincodeName,chaincodeVersion,fcn,chaincodeType,args,req.username,req.orgname,false,reqBodyKeyArrayresult);
  res.send(result);
});


// upgrade chaincode on target peers
router.post('/channels/:channelName/upgradeChaincodes', async function(req, res) {
	let reqBodyKeyArrayresult = reqBodyKeyFunc(req.body);
	var chaincodeName = req.body.chaincodeName;
	var peers = req.body.peers;
	var fcn = req.body.fcn;
	var chaincodeVersion = req.body.chaincodeVersion;
	var channelName = req.params.channelName;
	var chaincodePath = req.body.chaincodePath;
	var chaincodeType = req.body.chaincodeType;
	var args = req.body.args;
	var result = await instantiateChaincode.instantiateChaincodefunc(peers,channelName,chaincodeName,chaincodeVersion,fcn,chaincodeType,args,req.username,req.orgname,true,reqBodyKeyArrayresult);
	res.send(result);
});

// Invoke transaction on chaincode on target peers
router.post('/channels/:channelName/chaincodes/:chaincodeName', async function(req, res) {
	let reqBodyKeyArrayresult = reqBodyKeyFunc(req.body);
	var chaincodeName = req.params.chaincodeName;
	var channelName = req.params.channelName;
	var fcn = req.body.fcn;
	var peers = req.body.peers;
	console.log("peers---------------------------------------------"+peers);
	var args = req.body.args;
	let result = await invoke.invokefunc(peers,channelName,chaincodeName,fcn,args,req.username,req.orgname,reqBodyKeyArrayresult);
  res.send(result);
});


// Query on chaincode on target peers
router.get('/channels/:channelName/chaincodes/:chaincodeName', async function(req, res) {
	let reqBodyKeyArrayresult = reqBodyKeyFunc(req.query);
	var channelName = req.params.channelName;
	var chaincodeName = req.params.chaincodeName;
	let fcn = req.query.fcn;
	let peer = req.query.peer;
	let args = req.query.args.toString();
	console.log('-------------------args---------------------------------------------'+args);
	let result = await query.queryfunc(peer, channelName,chaincodeName,fcn,args,req.username,req.orgname,reqBodyKeyArrayresult);
	res.send(result);
});

//  Query Get Block by BlockNumber
router.get('/channels/:channelName/blocks/:blockId', async function(req, res) {
	let blockId = req.params.blockId;
	let peer = req.query.peer;
	logger.debug('channelName : ' + req.params.channelName);
	logger.debug('BlockID : ' + blockId);
	logger.debug('Peer : ' + peer);
	if (!blockId) {
		res.json(getErrorMessage('\'blockId\''));
		return;
	}

	let result = await queryBlock.queryBlockfunc(peer, req.params.channelName, blockId, req.username, req.orgname);
	res.send(result);
});

// Query Get Transaction by Transaction ID
router.get('/channels/:channelName/transactions/:trxnId', async function(req, res) {
	logger.debug('================ GET TRANSACTION BY TRANSACTION_ID ======================');
	logger.debug('channelName : ' + req.params.channelName);
	let trxnId = req.params.trxnId;
	let peer = req.query.peer;
	console.log('peer info is '+peer);
	if (!trxnId) {
		res.json(getErrorMessage('\'trxnId\''));
		return;
	}

	let result = await queryTransaction.queryTransactionfunc(peer, req.params.channelName, trxnId, req.username, req.orgname);
	res.send(result);
});

// Query Get Block by Hash
router.get('/channels/:channelName/blocks', async function(req, res) {
	logger.debug('================ GET BLOCK BY HASH ======================');
	logger.debug('channelName : ' + req.params.channelName);
	let hash = req.query.hash;
	let peer = req.query.peer;
	if (!hash) {
		res.json(getErrorMessage('\'hash\''));
		return;
	}

	let result = await queryHash.queryHashfunc(peer, req.params.channelName, hash, req.username, req.orgname);
	res.send(message);
});


//Query for Channel Information
router.get('/channels/:channelName', async function(req, res) {
	logger.debug('================ GET CHANNEL INFORMATION ======================');
	logger.debug('channelName : ' + req.params.channelName);
	let peer = req.query.peer;

	let result = await queryChannel.queryChannelfunc(peer, req.params.channelName, req.username, req.orgname);
	res.send(result);
});

//Query for Channel instantiated chaincodes
router.get('/channels/:channelName/chaincodes', async function(req, res) {
	logger.debug('================ GET INSTANTIATED CHAINCODES ======================');
	logger.debug('channelName : ' + req.params.channelName);
	let peer = req.query.peer;

	let result = await queryInstantiateChaincode.queryInstantiateChaincodefunc(peer, req.params.channelName, 'instantiated', req.username, req.orgname);
	res.send(result);
});

// Query to fetch all Installed/instantiated chaincodes
router.get('/chaincodes', async function(req, res) {
	var peer = req.query.peer;
	var installType = req.query.type;

	logger.debug('================ GET INSTALLED CHAINCODES ======================'+req.username+"-------"+req.orgname);

	let result = await queryAllChaincode.queryAllChaincodefunc(peer, null, 'installed', req.username, req.orgname)
	res.send(result);
});

// Query to fetch channels
router.get('/channels', async function(req, res) {
	logger.debug('================ GET CHANNELS ======================');
	logger.debug('peer: ' + req.query.peer);
	var peer = req.query.peer;
	if (!peer) {
		res.json(getErrorMessage('\'peer\''));
		return;
	}

	let result = await queryAllChannel.queryAllChannelfunc(peer, req.username, req.orgname);
	res.send(result);
});
function isJson(str) {
	try {
		JSON.parse(str);
	} catch (e) {
		return false;
	}
	return true;
  }

  function reqBodyKeyFunc(body){
	var reqBodyKeyArray = [];
	Object.keys(body).forEach(function(key){
		reqBodyKeyArray.push(key);
	});
	return reqBodyKeyArray;
  }
module.exports = router;
