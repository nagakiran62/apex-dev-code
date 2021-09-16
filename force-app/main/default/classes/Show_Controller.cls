public with sharing class Show_Controller {

	public String showId {get; set{
			//system.debug(showId);
			showId = value;
			queryShow();

			queryContacts();

		}}
	public String formName {get; set;}


	public Show__c show {get; set;}

	public List<Deal_Summary__c> contracts {get; set;}
	public List<Restriction> restrictions{get; set;}


	public Show_Controller() {
		system.debug(showId);
		
	}

	public String director {get; set;}
	public String upm {get;set;}
	public String firstAssitantDirector {get;set;}
	public String keySecondAssitDirector {get;set;}
	public String associateDirTech {get;set;}
	public String associateDirLineCut {get; set;}
	public String associateDirector {get; set;}
	public String stageManager {get; set;}
	public String secondStageManager{get;set;}
	public String thirdStageManager{get;set;}
	public String other{get;set;}




	public void queryShow(){
		this.show =  [SELECT Name, AFTRA__c, NumberofEps__c, Title_Clearance__c, IP_Lit_Contact__c, Location_Name__c, Production_Contact__c,
                                WBS_Element__c, Production_Exec__c, Travel_Booker__c, Travel_Approver__c,
                                Project_Type__c, Budget_Approver__c, Budget_Approver_VIN__c, Project_Manager__c, Project_Mgr_VIN__c,
                                CompanyCode__c, Finance_Content_Code__c, Season__c, Lengthofshow__c, ContentType__c, centralproductions__c,
                                ProductionType__c, Incentive_State__c, Budget_Incentive__c, Package_Fee_Type__c, Package_Fee_Amount__c,Guilds__c,
                                Vendor_Name__c, Package_Fee__c, Vendor_Id__c, Proposed_title__c, Owner.Name, Content_Types__c, BudgetEstimate__c,Production_Accounting_Systems__c,
                                MMl_Contact__c, Multiplatform_Contact__c,Concept__c,Production_Budget_Total__c,Pre_Production_Start_Date__c,Production_Complete_Date__c,
                                Production_Start_Date__c, CameraUsageType__c, Post_Production_Start_Date__c, Production_Company_Account__c, Production_Company_Account__r.Name,
                                Production_Company_Account__r.BillingStreet, Production_Company_Account__r.BillingState, Production_Company_Account__r.BillingCity,
                                Production_Company_Account__r.BillingPostalCode, Production_Company_Account__r.BillingCountry, Production_Company_Account__r.Phone


                    FROM Show__c 
                    WHERE Id = : showId LIMIT 1];
	}


	public void queryContacts(){
		if(formName == 'dga'){
			queryDGAContacts();
		}else if(formName == 'talent list'){
			queryTalentListContacts();
		}else if(formName == 'sagaftra'){
			querySAGAFTRAContacts();
		}
	}

	public void queryDGAContacts(){

		for(Deal_Summary__c deal : [SELECT Id, Show_Contact__c, Show__c, Role__c, Type__c, Contact_Name__c FROM Deal_Summary__c WHERE Show_Contact__r.Show__c =: showId]){
			String role = deal.Role__c;

			if(role == 'Director'){
				director = deal.Contact_Name__c;
			}else if(role == 'UPM'){
				upm = deal.Contact_Name__c;
			}else if(role == '1st Assistant Director'){
				firstAssitantDirector = deal.Contact_Name__c;
			}else if(role == 'Key 2nd Assistant Director'){
				keySecondAssitDirector = deal.Contact_Name__c;
			}else if(role == 'Associate Director/Technical Coordinator'){
				associateDirTech = deal.Contact_Name__c;
			}else if(role == 'Associate Director(line cut)'){
				associateDirLineCut = deal.Contact_Name__c;
			}else if(role == 'Associate Director'){
				associateDirector = deal.Contact_Name__c;
			}else if(role == 'Stage Manager'){
				stageManager = deal.Contact_Name__c;
			}else if(role == '2nd Stage Manager'){
				secondStageManager = deal.Contact_Name__c;
			}else if(role == '3rd Stage Manager'){
				thirdStageManager = deal.Contact_Name__c;
			}


		}

	}

	public void queryTalentListContacts(){
		contracts = [SELECT Id, Contact_Name__c FROM Deal_Summary__c WHERE Id =: showId AND Type__c = 'Contract'];
		restrictions = new List<Restriction>();
		contracts = new List<Deal_Summary__c>();
		for(Deal_Summary__c contract : [SELECT Id, Contact_Name__c, Type__c, Character_Name__c, SSN__c, Amount_Paid__c,Days__c, Weeks__c, Talent_Contract_Type__c,
										Performer_Type__c, Total_Gross_SUmmary__c, Base_Salary__c, Time_Units__c, Salary_Units__c, Total_Units__c, Loanout_Company_Name__c,
										Loanout_Company__c, To_Date__c, From_Date__c, Talent_Restrictions__c
										FROM Deal_Summary__c WHERE Show_Contact__r.Show__c =: showId AND Type__c = 'Contract'
										AND Show_Contact__r.Type__c IN ('Dayplayer', 'Dayplayer Minor', 'Extra', 'Extra Minor')
			]){

			if(contract.Talent_Restrictions__c != null){
				List<Restriction> talent_restrictions = (List<Restriction>)JSON.deserialize(contract.Talent_Restrictions__c, List<Restriction>.class);

				for(Restriction restriction : talent_restrictions){
					if(restriction.photo_actual_likeness || restriction.excerpt_of_performance_digital || restriction.Excerpt_of_Performance_On_Air || 
							restriction.BTS_Footage || restriction.bloopers || String.isNotBlank(restriction.info) || String.isNotBlank(restriction.notes) ){
						restriction.actorName = contract.Contact_Name__c;
						restrictions.add(restriction);
					}
				}

			}

			contracts.add(contract);
		}



	}

	public void querySAGAFTRAContacts(){
		//contracts = [SELECT Id, Contact_Name__c FROM Deal_Summary__c WHERE Id =: showId AND Type__c = 'Contract'];
		contracts = new List<Deal_Summary__c>();
		for(Deal_Summary__c contract : [SELECT Id, Contact_Name__c, Type__c, Character_Name__c, SSN__c, Amount_Paid__c, Show_Contact__r.Type__c,
											Days__c, Weeks__c, Talent_Contract_Type__c,
											Performer_Type__c, Total_Gross_SUmmary__c, Base_Salary__c, Time_Units__c, Salary_Units__c, Total_Units__c
				 FROM Deal_Summary__c 
				WHERE Show_Contact__r.Show__c =: showId AND Type__c = 'Contract'
				AND Show_Contact__r.Type__c IN ('Dayplayer', 'Dayplayer Minor', 'Extra', 'Extra Minor')]){

			if(contract.Show_Contact__r.Type__c.contains('Dayplayer')){
				contract.Type__c = 'Dayplayer';
			}else if(contract.Show_Contact__r.Type__c.contains('Extra')){
				contract.Type__c = 'Extra';
			}

			contracts.add(contract);
		}

	}

	public class restriction{
		public String actorName {get; set;}
		public Boolean useOfName {get; set;}
		public Integer episode {get; set;}
		public boolean Photo_Actual_Likeness {get; set;}
		public boolean Excerpt_of_Performance_Digital {get; set;}
		public boolean Excerpt_of_Performance_On_Air {get; set;}
		public boolean BTS_Footage {get; set;}
		public boolean Bloopers {get; set;}
		public String info {get; set;}
		public String notes {get; set;}

		public restriction(){
			
		}

	}


}