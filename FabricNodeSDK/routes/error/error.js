function getErrorMessage(fields,predefinedKeys,reqBodyKeyArray) {
	var response,message;
	if(fields =='compare') {
		var incorrectfelids = diff(reqBodyKeyArray,predefinedKeys);
		console.log()
		if(incorrectfelids.length > 1) { 
			 message = incorrectfelids + ' keys are Invalid in the request.'
		}else {
			message = incorrectfelids + ' key is Invalid in the request.'
		}
		response = {
			success: false,
			message: message
		};
	}else{
		response = {
			success: false,
			message: fields + ' missing or Invalid in the request'
		};
	}
	return response;
}

function diff(arr1,arr2) {
    var ret = [];
	arr1.sort();
    arr2.sort();
    for(var i = 0; i < arr1.length; i += 1) {
        if(arr2.indexOf(arr1[i]) == -1){
            ret.push(arr1[i]);
        }
    }
    return ret;
};


module.exports = {
    getErrorMessage : getErrorMessage
}
