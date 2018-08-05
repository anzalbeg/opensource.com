var createChannel = require('../src/create-channel');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('channelLogger');

//app.post('/channels', async function(req, res) {

    exports.createChannelfunc = async function (channelName,channelConfigPath,configUpdate,username,orgname){
        logger.info('<<<<<<<<<<<<<<<<< C R E A T E  C H A N N E L >>>>>>>>>>>>>>>>>');
        logger.debug('End point : /channels');
        // var channelName = req.body.channelName;
        // var channelConfigPath = req.body.channelConfigPath;
        logger.debug('Channel name : ' + channelName);
        logger.debug('channelConfigPath : ' + channelConfigPath); //../artifacts/channel/mychannel.tx

        if( typeof(channelName) == 'undefined' || typeof(channelConfigPath) == 'undefined') {
            return getErrorMessage.getErrorMessage("compare",["channelName","channelConfigPath"],reqBodyKeyArray);
        }
        if (!channelName && !channelConfigPath) {
            return getErrorMessage.getErrorMessage('channelName and channelConfigPath both fields are ');
        }
        if (!channelName) {
            return getErrorMessage('channelName')
        }
        if (!channelConfigPath) {
            return getErrorMessage('channelConfigPath');
        }
    
        let message = await createChannel.createChannel(channelName, channelConfigPath,configUpdate,username,orgname);
        return message;
    };
//});