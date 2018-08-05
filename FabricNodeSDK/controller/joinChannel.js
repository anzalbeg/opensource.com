var joinChannel = require('../src/join-channel');
var getErrorMessage = require('../routes/error/error');
var log4js = require('log4js');
var logger = log4js.getLogger('joinChannelLogger');

//app.post('/channels', async function(req, res) {

    exports.joinChannelfunc = async function (channelName,peers,username,orgname,reqBodyKeyArray){

        if( typeof(peers) == 'undefined') {
            return getErrorMessage.getErrorMessage("compare",["peers"],reqBodyKeyArray);
        }
        if (!channelName) {
            return getErrorMessage.getErrorMessage('channelName');
        }
        if (!peers || peers.length == 0) {
            return getErrorMessage.getErrorMessage('peers');
        }
        let message = await joinChannel.joinChannel(channelName,peers,username,orgname);
        return message;
    };
//});