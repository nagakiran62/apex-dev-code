({
	queryEpisodes : function(component, helper) {
		var queryString = 'SELECT Id, ActivityDate, Subject, Episode__c, Episode_Type__c FROM Event WHERE Episode__c != null ';
		queryString += ' AND WhatId = \'' + component.get('v.recordId') + '\' ';		
		queryString += ' ORDER BY Episode__c ASC '
		component.find('util').query(queryString, function(data){
        
			console.log('the actual event data in helper--> '+ data);
			var episodes = [];
			//console.log('--data--', data);
				for(var i = 0; i < component.get('v.numberOfEpisodes'); i++){
					episodes.push({
						air: helper.createEvent(component, i+1, 'Air Date'),
						premiere: helper.createEvent(component, i+1, 'Premiere Date'),
						delivery: helper.createEvent(component, i+1, 'Delivery Date'),
						airDate : null,
						premierDate:null,
						deliveryDate:null,
						reair: []
					});
				}


			if(!$A.util.isEmpty(data)){
				data.forEach(function(episode){
					 console.log(episode);
					if(episode.Episode_Type__c == 'Air Date'){
						episodes[episode.Episode__c-1].air = episode;
						episodes[episode.Episode__c-1].airDate = episode.ActivityDate;
					}else if(episode.Episode_Type__c == 'Premiere Date'){
						episodes[episode.Episode__c-1].premiere = episode;
						episodes[episode.Episode__c-1].premiereDate = episode.ActivityDate;
					}else if(episode.Episode_Type__c == 'Delivery Date'){
						episodes[episode.Episode__c-1].delivery = episode;
						episodes[episode.Episode__c-1].deliveryDate = episode.ActivityDate;
					}else if(episode.Episode_Type__c == 'Reair Date'){

						console.log('inside reair date');
						episodes[episode.Episode__c-1].reair.push({reair: episode, reairDate: episode.ActivityDate});
					}
				});

			}

			console.log(episodes);

			// episodes[0].reair.push({date: null});
			// episodes[0].reair.push({date: null});
			// episodes[0].reair.push({date: null});

			component.set('v.episodes', episodes);
		});
	},

	createEvent : function(component, episodeNumber, type){
		return {
			sobjectType: 'Event',
			WhatId: component.get('v.recordId'),
			Episode__c: episodeNumber,
			Subject: 'Episode ' + episodeNumber + ': ' + type,
			IsAllDayEvent: true,
			Episode_Type__c: type
		}
	},
    toggleVis : function(){
    var x = document.getElementById("air_dates_div");
    if (x.style.display === "none") {
        x.style.display = "block";
    } else {
        x.style.display = "none";
    }        
        
    }
    

})