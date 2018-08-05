var express = require('express');
var log4js = require('log4js');
var logger = log4js.getLogger('usersLogger');
var hfc = require('fabric-client');
var router = express.Router();

//importing custom modules
var getErrorMessage = require('../routes/error/error.js');
var routerJwt = require('../routes/expressJwt/jwt');
logger.debug('app.get-------------------------------------'+routerJwt.app.get('secret'));
var helper = require('../src/helper.js');
/* GET users listing. */
exports.createUserfunc = async function(username, orgname, reqBodyKeyArray) {
    let result = {};
    logger.debug('End point : /users');
    logger.debug('User name : ' + username);
    logger.debug('Org name  : ' + orgname);
    
    if( typeof(username) == 'undefined' || typeof(orgname) == 'undefined') {
        return getErrorMessage.getErrorMessage("compare",["username","orgname"],reqBodyKeyArray);
    }
    if (!username && !orgname) {
        return getErrorMessage.getErrorMessage('usernname and orgname both fields are ');
    }
    if (!username) {
        return getErrorMessage.getErrorMessage('username field is ');
    }
    if (!orgname) {
        return getErrorMessage.getErrorMessage('orgname field is ');
    }
   
    var token = routerJwt.jwt.sign({
        exp: Math.floor(Date.now() / 1000) + parseInt(hfc.getConfigSetting('jwt_expiretime')),
        username: username,
        orgname: orgname
    }, routerJwt.app.get('secret'));
    logger.debug('token ------------------------------------'+token);
    let response = await helper.getRegisteredUser(username, orgname, true);
    logger.debug('-- returned from registering the username %s for organization %s', username, orgname);
    if (response && typeof response !== 'string') {
        logger.debug('Successfully registered the username %s for organization %s', username, orgname);
        response.token = token;
        return response;
    } else {
        logger.debug('Failed to register the username %s for organization %s with::%s', username, orgname, response);
         result.success = false;
         result.message = response;
         return result;
    }
};

