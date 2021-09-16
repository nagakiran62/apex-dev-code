({
	init : function(component, event, helper) {
		


		var queryString = ' SELECT Id, NumberofEps__c FROM Show__c WHERE Id =\'' + component.get('v.recordId') + '\'';
		console.log('init--->'+ component.get('v.recordId'));
        component.find('util').query(queryString, function(data){
			var show = data[0];
            console.log('this is hereeeeeii--->'+JSON.stringify(show));
			component.set('v.numberOfEpisodes', data[0].NumberofEps__c);

			if(!$A.util.isEmpty(component.get('v.numberOfEpisodes'))){
                console.log('hiiiiiiii--->');
				helper.queryEpisodes(component, helper);
			}
		})


	},
    
    toggleVis : function(cmp, evt, hlp){
        hlp.toggleVis();
    },

	save : function(component, event, helper){
		console.log('save');

		console.log(component.get('v.episodes'));

		var toUpsert = [];
		var toDelete = [];


		component.get('v.episodes').forEach(function(episode){

			if(!$A.util.isEmpty(episode.airDate)){
				episode.air.ActivityDate = episode.airDate;
				toUpsert.push(episode.air);
			}else if(!$A.util.isEmpty(episode.air.Id) ){
				toDelete.push(episode.air);
			}

			if(!$A.util.isEmpty(episode.premiereDate)){
				episode.premiere.ActivityDate = episode.premiereDate;
				toUpsert.push(episode.premiere);
			}else if(!$A.util.isEmpty(episode.premiere.Id) ){
				toDelete.push(episode.premiere);
			}

			if(!$A.util.isEmpty(episode.deliveryDate)){
				episode.delivery.ActivityDate = episode.deliveryDate;
				toUpsert.push(episode.delivery);
			}else if(!$A.util.isEmpty(episode.delivery.Id) ){
				toDelete.push(episode.delivery);
			}

			if(!$A.util.isEmpty(episode.reair)){
				episode.reair.forEach(function(reair){

					if(!$A.util.isEmpty(reair.reairDate)){
						reair.reair.ActivityDate = reair.reairDate;
						toUpsert.push(reair.reair);
					}else if(!$A.util.isEmpty(reair.reair.Id) ){
						toDelete.push(reair.reair);
					}

				});
			}

		});


		

		if(!$A.util.isEmpty(toDelete)){
			component.find('util').delete(toDelete, function(data){
				if(!$A.util.isEmpty(toUpsert)){
					console.log(toUpsert);
					component.find('util').upsert(toUpsert, function(data){
						helper.queryEpisodes(component, helper);
					});
				}
			})
		}else if(!$A.util.isEmpty(toUpsert)){
			console.log(toUpsert);
			component.find('util').upsert(toUpsert, function(data){
				helper.queryEpisodes(component, helper);
			});
		}
		

	},

	addReair : function(component, event, helper){
		console.log('add');
		//console.log(event.getSource());
		//console.log(event.getSource().get('v.title'));
		var i = event.getSource().get('v.title');
		var episodes = component.get('v.episodes');

		episodes[i].reair.push({
			reair: helper.createEvent(component, i+1, 'Reair Date'),
			reairDate: null
		});

		component.set('v.episodes', episodes);

	},

	goToReport : function(component, event, helper){
		var url = 'https://comedycentral1.lightning.force.com/one/one.app#/sObject/00O6A0000027lEcUAI/view?fv2=' + component.get('v.recordId');
	}
})