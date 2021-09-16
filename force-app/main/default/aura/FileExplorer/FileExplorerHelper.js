({  
    queryFiles : function(component){
        var queryEventString = 'SELECT Id FROM Event WHERE WhatId = \'' + component.get('v.recordId') +'\'';
        var ids = [component.get('v.recordId')];
        component.find('util').query(queryEventString, function(response){
            response.forEach(function(event){
                ids.push(event.Id);
            });

            var queryFileString = 'SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN (';
            ids.forEach(function(id){
                queryFileString += '\''+ id +'\',';
            });
			
            queryFileString = queryFileString.substring(0, queryFileString.lastIndexOf(','));
            queryFileString += ')';
           // queryFileString += ' ORDER BY Name DESC';
            

            component.find('util').query(queryFileString,  function(contentDocLinks){
                var contentDocIds = [];
                contentDocLinks.forEach(function(link){
                    contentDocIds.push(link.ContentDocumentId);
                });

                if(!$A.util.isEmpty(contentDocIds)){
                    var contentVersionQueryString = 'SELECT Id, Type__c, Title, ContentSize, FileExtension, ContentDocumentId, Createddate FROM ContentVersion WHERE ';
                    contentVersionQueryString += ' ContentDocumentId IN (';
                    contentDocIds.forEach(function(id){
                        contentVersionQueryString += '\'' + id + '\','
                    });

                    contentVersionQueryString = contentVersionQueryString.substring(0, contentVersionQueryString.lastIndexOf(','));
                    contentVersionQueryString += ')';
                   // contentVersionQueryString += ' ORDER BY Title';
                   // alert('the value' +contentVersionQueryString);

                    component.find('util').query(contentVersionQueryString, function(contentVersion){
                        var folderList = [
                            'Cost Report',
                            'DGA PIF',
                            'AFTRA NSIS',
                            'Schedule',
                            'Production Report',
                            'DOOD',
                            'WGA Weekly',
                            'Other',
                        ];

                        var folders = [];

                        folderList.forEach(function(folder){
                            var f = {};
                            f[folder] = [];

                            folders.push(f);
                        });
						console.log("Showme contentVersion ", contentVersion);
                        contentVersion.forEach(function(version){
                            var file = {
                                    RelatedRecordId: version.ContentDocumentId,
                                    Title: version.Title,
                                    LastModifiedDate: version.CreatedDate
                                }
                          //  alert('the file' +JSON.stringify(file));
							/*
                            
                            folders.forEach(function(f){
                                
                                if(f.hasOwnProperty(version.Type__c)){
                                    f[version.Type__c].push(file);
                                }else{
                                    f['Other'].push(file);
                                }
                            })*/

                        });
                       

                    });

                }

            });

        });
    },

    getFiles : function(component, event, helper){
        var showId = component.get("v.recordId");
        var action = component.get("c.queryFiles");
        action.setParams({showId:showId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if ( state === "SUCCESS" ){
                var res = response.getReturnValue();
				console.log("Form files are -> ", res)
                var folders = [];

                for ( var key in res ) {
                    folders.push( {isExpanded:true, Name:key, Files:res[key], checked: true});
                }

                folders.forEach(function(folder){
                    folder.Files.forEach(function(file){
                        file.checked = true;
                    });
                });
                console.log("walter folders ", folders);
                component.set("v.folders",folders);
                helper.onload(component);
            }
        });
        $A.enqueueAction(action);
    },
    onload : function(component){
        console.log("onload");
        var li_ul = document.querySelectorAll(".col_ul li  ul");
        for (var i = 0; i < li_ul.length; i++) {
            li_ul[i].style.display = "none"
        };

        var exp_li = document.querySelectorAll(".col_ul li > span");
        for (var i = 0; i < exp_li.length; i++) {
            exp_li[i].style.cursor = "pointer";
            exp_li[i].onclick = showul;
        };
        function showul () {
            nextul = this.nextElementSibling;
            if(nextul.style.display == "block")
                nextul.style.display = "none";
            else
                nextul.style.display = "block";
        }
    },
    openModal : function(component, event) {
		console.log("openModal");
		var modal = component.find('modal');
		$A.util.addClass(modal, 'slds-fade-in-open');
		var backdrop = component.find('backdrop');
		$A.util.addClass(backdrop, 'slds-backdrop--open');
	},
	closeModal : function(component, event) {
		console.log("closeModal");
        component.set("v.uploadedFiles",[]);
        component.set("v.uploadDate",null);
		var modal = component.find('modal');
		$A.util.removeClass(modal, 'slds-fade-in-open');
		var backdrop = component.find('backdrop');
		$A.util.removeClass(backdrop, 'slds-backdrop--open');
	}
})