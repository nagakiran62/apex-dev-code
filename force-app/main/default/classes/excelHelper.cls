public class excelHelper {

    public class row {
		public List<cell> cells;
        public Map<String,Object> style;
        public row(){}
        public row(List<cell> cells){
            this.cells = cells;
        }
        public row(List<cell> cells, Map<String,Object> style){
            this.cells = cells;
            this.style = style;
        }
    }
    public class cell {
        public object value;
        public Map<String,Object> style;
        public cell(){}
        public cell(object value){
            this.value = value;
        }
        public cell(object value, Map<String,object> style){
            this.value = value;
            this.style = style;
        }
    }

    public static Show__c queryShow(Id showId){
        return [
            SELECT Id, Name, NumberofEps__c, Guild_Union_Coverage__c, CentralProductions__c, WBS_Element__c, ProductionType__c,
            	Covered_by_DGA__c, Covered_by_WGA__c, Covered_by_SAGAFTRA__c, Covered_By_IATSE__c, Guilds__c,
                Production_Company_Account__c, Production_Company_Account__r.Name, Production_Company_Account__r.AccountNumber,
                Content_Types__c, Production__c, Location_lookup__r.Name, Season__c, Below_The_Line_Description__c, Concept__c,
                Writing_Period_Start_Date__c, Pre_Production_Start_Date__c, Production_Start_Date__c, Post_Production_Start_Date__c, Delivery__c, Vendor_Name__c,
                Vendor_Id__c,
                (
                    SELECT Id, Full_Name__c, Contact__r.Phone, Contact__r.Email, Contact__r.Title, Type__c
                    FROM Show_Contacts__r
                ),
                (
                    SELECT Id, Name, Signatory__c, Signatory__r.Name
                    FROM Show_Rates__r
                )
            FROM Show__c
            WHERE Id = :showId
            LIMIT 1
        ];
    }

    public static List<Deal_Summary__c> queryDealSummaries(Id showId){
        return [
            SELECT Id, Show_Contact__r.Full_Name__c, Travel__c, Credit__c, Loanout_Company_Name__c, Name, Type__c, Amount_Paid__c, Misc__c, Role__c
            FROM Deal_Summary__c
            WHERE Show_Contact__r.Show__c = :showId and RecordType.Name = 'Deal Summary'
            ORDER BY Show_Contact__r.Full_Name__c
        ];
    }

    public static List<Contact> queryContacts(){
        return [
            SELECT Id, FirstName, LastName
            FROM Contact
            LIMIT 1
        ];
    }

    public static List<row> getAtlBreakdown(Id showId){
        Show__c show = queryShow(showId);
        List<Deal_Summary__c> dealSummaries = queryDealSummaries(showId);
        List<row> results = new List<row>();
        results.add(new row(new List<cell>{new cell('atl breakdown')}));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('DATE:'),new cell(system.today().month()+'/'+system.today().day()+'/'+system.today().year())}));
        results.add(new row(new List<cell>{new cell('SHOW:'),new cell(show.Name)}));
        results.add(new row(new List<cell>{new cell('CYCLE/SEASON:'),new cell(show.Season__c)}));
        results.add(new row(new List<cell>{new cell('EPISODES:'),new cell(show.NumberofEps__c)}));
        results.add(new row(new List<cell>{new cell('BUDGET TYPE:'),new cell('')}));
        results.add(new row(new List<cell>{new cell('UNION/GUILDS:'),new cell(show.Guild_Union_Coverage__c)}));
        results.add(new row(new List<cell>{new cell('PROD. COMPANY:'),new cell(show.CentralProductions__c)}));
        results.add(new row(new List<cell>{new cell('')}));
        for ( Deal_Summary__c ds : dealSummaries ){
            if ( ds.Type__c == 'Deal Summary' ){
                results.add(new row(new List<cell>{new cell('')}));
                results.add(new row(new List<cell>{new cell('LOANOUT COMPANY NAME f/s/o NAME')}));
                results.add(new row(new List<cell>{new cell('')}));
                if ( String.isNotBlank(ds.Loanout_Company_Name__c) ){
                    results.add(new row(new List<cell>{new cell('IND/LOANOUT/CORP:'),new cell(ds.Loanout_Company_Name__c)}));
                } else {
                    results.add(new row(new List<cell>{new cell('IND/LOANOUT/CORP:'),new cell(ds.Show_Contact__r.Full_Name__c)}));
                }
                results.add(new row(new List<cell>{new cell('NY/CA:'),new cell(show.Location_lookup__r.Name)}));
                results.add(new row(new List<cell>{new cell('POSITIONS(S):'),new cell(ds.Role__c)}));
                results.add(new row(new List<cell>{new cell('UNION/GUILD(S):'),new cell('')}));
                results.add(new row(new List<cell>{new cell('FEE ALLOCATION:'),new cell(ds.Amount_Paid__c)}));
                results.add(new row(new List<cell>{new cell('TRAVEL:'),new cell(ds.Travel__c)}));
                results.add(new row(new List<cell>{new cell('CREDIT(S):'),new cell(ds.Credit__c)}));
                results.add(new row(new List<cell>{new cell('MISC:'),new cell(ds.Misc__c)}));
            }
        }
        return results;
    }

    public static List<row> getAtlMemo(Id showId){
        Show__c show = queryShow(showId);

        List<row> results = new List<row>();
        results.add(new row(new List<cell>{new cell('approval to lock memo')}));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('DATE:'),new cell(system.today().month()+'/'+system.today().day()+'/'+system.today().year())}));
        results.add(new row(new List<cell>{new cell('SHOW:'),new cell(show.Name)}));
        results.add(new row(new List<cell>{new cell('CYCLE/SEASON:'),new cell(show.Season__c)}));
        results.add(new row(new List<cell>{new cell('EPISODES:'),new cell(show.NumberofEps__c)}));
        results.add(new row(new List<cell>{new cell('BUDGET TYPE:'),new cell('')}));
        results.add(new row(new List<cell>{new cell('UNION/GUILDS:'),new cell(show.Guild_Union_Coverage__c)}));
        results.add(new row(new List<cell>{new cell('PROD. COMPANY:'),new cell(show.CentralProductions__c)}));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('headlines')}));
        results.add(new row(new List<cell>{new cell('3RD PARTY/CENTRAL ORIGINAL EPS BUDGET'), new cell('') }));
        results.add(new row(new List<cell>{new cell('*ABOVE THE LINE'), new cell('') }));
        results.add(new row(new List<cell>{new cell('*PRODUCTION'), new cell('') }));
        results.add(new row(new List<cell>{new cell('*POST-PRODUCTION'), new cell('') }));
        results.add(new row(new List<cell>{new cell('*PRODUCTION'), new cell('') }));
        results.add(new row(new List<cell>{new cell('*POST TOTAL'), new cell('') }));
        results.add(new row(new List<cell>{new cell('*OTHER'), new cell('') }));
        results.add(new row(new List<cell>{new cell('*<ENTER STATE HERE> TAX CREDIT'), new cell(''), new cell('(less <enter state here> tax credit)') }));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('SERIES PACKAGE FEE'),new cell('(full/half package due to <enter agency here>)')}));
        results.add(new row(new List<cell>{new cell('SERIES PACKAGE FEE PER EPISODE')}));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('ADJUSTED ORIGINAL EPS BUDGET')}));
        results.add(new row(new List<cell>{new cell('COST PER ORIGINAL EPISODE')}));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('PILOT CAPITALIZATION:'), new cell(''), new cell('(pilot capitalization if applicable)')}));
        results.add(new row(new List<cell>{new cell(''), new cell(''), new cell('(plus pilot finishing costs if applicable)')}));
        results.add(new row(new List<cell>{new cell(''), new cell(''), new cell('(plus retor pilot package fee if applicable)')}));
        results.add(new row(new List<cell>{new cell('TOTAL PILOT COSTS'),new cell('')}));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('TOTAL S1 SERIES BUDGET PSUMM:'),new cell('')}));
        results.add(new row(new List<cell>{new cell('COST S1 PER EPISODE FOR PSUMM:'),new cell('')}));
        results.add(new row(new List<cell>{new cell('S2 EPISODIC ESTIMATE FOR PSUMM:'),new cell(''),new cell('(assumes 5% growth on S2s only)')}));
        results.add(new row(new List<cell>{new cell('')}));

        results.add(new row(new List<cell>{new cell('schedule')}));
        results.add( new row(new List<cell>{new cell('WRITING'),new cell(show.Writing_Period_Start_Date__c)}) );
        results.add( new row(new List<cell>{new cell('PRE-PRODUCTION'),new cell(show.Pre_Production_Start_Date__c)}) );
        results.add( new row(new List<cell>{new cell('SHOOT'),new cell(show.Production_Start_Date__c)}) );
        results.add( new row(new List<cell>{new cell('POST'),new cell(show.Post_Production_Start_Date__c)}) );
        results.add( new row(new List<cell>{new cell('MISC'),new cell(show.Delivery__c)}) );
        results.add(new row(new List<cell>{new cell('')}));

        results.add(new row(new List<cell>{new cell('signatory information')}));
        for ( Show_Rate__c r : show.Show_Rates__r ){
            results.add(new row(new List<cell>{new cell(r.Signatory__r.Name)}));
        }
        results.add(new row(new List<cell>{new cell('')}));

        results.add(new row(new List<cell>{new cell('contact')}));
        results.add(new row(new List<cell>{new cell('PRODUCTION COMPANY:'),new cell(show.Production_Company_Account__r.Name)}));
        results.add(new row(new List<cell>{new cell('CONTACT:'),new cell('')}));
        results.add(new row(new List<cell>{new cell('PHONE:'),new cell('')}));

        return results;
    }

    public static List<row> getCashflow(Id showId){
        Show__c show = queryShow(showId);

        List<row> results = new List<row>();
        results.add(new row(new List<cell>{new cell('SHOW:'),new cell(show.Name)}));
        results.add(new row(new List<cell>{new cell('CYCLE SEASON:'),new cell(show.Season__c)}));
        results.add(new row(new List<cell>{new cell('EPISODES:'),new cell(show.NumberofEps__c)}));
        results.add(new row(new List<cell>{new cell('BUDGET TYPE:'),new cell('')}));
        results.add(new row(new List<cell>{new cell('UNION/GUILDS'),new cell(show.Guilds__c)}));
        results.add(new row(new List<cell>{new cell('WBS ELEMENT'),new cell(show.WBS_Element__c)}));
        results.add(new row(new List<cell>{new cell('VENDOR NAME'),new cell(show.Vendor_Name__c)}));
        results.add(new row(new List<cell>{new cell('VENDOR NUMBER:'),new cell(show.Vendor_Id__c)}));
        results.add(new row(new List<cell>{new cell('NET TERMS:'),new cell('')}));
        results.add(new row(new List<cell>{new cell('CHECK/ACH'),new cell('')}));
        results.add(new row(new List<cell>{new cell('PSA STATUS:'),new cell('')}));
        results.add(new row(new List<cell>{new cell('CASH FLOW A/O'),new cell(system.today().format())}));
        results.add(new row(new List<cell>{new cell('SUMMARY OF NETWORK COSTS'),new cell('WBS ELEMENT')}));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('LOCKED EXTERNAL PRODUCTION BUDGET'),new cell(''),new cell(show.WBS_Element__c)}));
        results.add(new row(new List<cell>{new cell('DIGITAL ALLOCATION'),new cell(''),new cell(show.WBS_Element__c)}));
        results.add(new row(new List<cell>{new cell('INTERNAL CHARGE #1'),new cell(''),new cell(show.WBS_Element__c)}));
        results.add(new row(new List<cell>{new cell('INTERNAL CHARGE #2'),new cell(''),new cell(show.WBS_Element__c)}));
        results.add(new row(new List<cell>{new cell('APPROVED PRODUCTION OVERAGES'),new cell(''),new cell(show.WBS_Element__c)}));
        results.add(new row(new List<cell>{new cell('TOTAL TO BE FUNDED'),new cell('')}));
        results.add(new row(new List<cell>{new cell('FUNDED TO DATE:'),new cell('')}));
        results.add(new row(new List<cell>{new cell('LEFT TO PAY'),new cell('PAID'),new cell('MILESTONE NOTES'),new cell('PO #'),new cell('INVOICE #'),new cell('PAYMENT STATUS')}));
        results.add(new row(new List<cell>{new cell(''),new cell(''),new cell(''),new cell(''),new cell(''),new cell('')}));
        results.add(new row(new List<cell>{new cell(''),new cell(''),new cell(''),new cell(''),new cell(''),new cell('')}));
        results.add(new row(new List<cell>{new cell(''),new cell(''),new cell(''),new cell(''),new cell(''),new cell('')}));
        results.add(new row(new List<cell>{new cell(''),new cell(''),new cell(''),new cell(''),new cell(''),new cell('')}));
        results.add(new row(new List<cell>{new cell(''),new cell(''),new cell(''),new cell(''),new cell(''),new cell('')}));
        results.add(new row(new List<cell>{new cell(''),new cell(''),new cell(''),new cell(''),new cell(''),new cell('')}));
        results.add(new row(new List<cell>{new cell(''),new cell(''),new cell(''),new cell(''),new cell(''),new cell('')}));
        results.add(new row(new List<cell>{new cell(''),new cell(''),new cell(''),new cell(''),new cell(''),new cell('')}));
        results.add(new row(new List<cell>{new cell(''),new cell(''),new cell(''),new cell(''),new cell(''),new cell('')}));
        results.add(new row(new List<cell>{new cell(''),new cell(''),new cell(''),new cell(''),new cell(''),new cell('')}));
        results.add(new row(new List<cell>{new cell('')}));
        results.add(new row(new List<cell>{new cell('TOTAL TO BE FUNDED'), new cell('')}));
        return results;
    }

    public static List<row> getGuildUnionForm(Id showId){
        Show__c show = queryShow(showId);
        Map<String, List<Show_Contact__c>> showContactMap = new Map<String, List<Show_Contact__c>>();
        for ( Show_Contact__c sc : show.Show_Contacts__r ){
            List<Show_Contact__c> showContacts = new List<Show_Contact__c>();
            if ( showContactMap.containsKey(sc.Type__c) ){
                showContacts = showContactMap.get(sc.Type__c);
            }
            showContacts.add(sc);
            showContactMap.put(sc.Type__c,showContacts);
        }

        List<row> results = new List<row>();
        results.add( new row(new List<cell>{new cell('DATE:'), new cell(system.today()+''), new cell(''), new cell('PROJECT TYPE:'), new cell(show.ProductionType__c)}) );
        results.add( new row(new List<cell>{new cell('SHOW:'), new cell(show.Name), new cell(''), new cell('PRODUCTION COMPANY TYPE:'), new cell(show.CentralProductions__c)}) );
        results.add( new row(new List<cell>{new cell('CYCLE/SEASON:'), new cell(show.Season__c), new cell(''), new cell('CONTENT TYPE:'), new cell(show.Content_Types__c)}) );
        results.add( new row(new List<cell>{new cell('EPISODES:'), new cell(show.NumberofEps__c), new cell(''), new cell('CONTENT DESCRIPTION:'), new cell('')}) );
        results.add( new row(new List<cell>{new cell('PRODUCTION BUDGET:'), new cell(show.Production__c), new cell(''), new cell('BACKGROUND PERFORMERS:'), new cell(show.Below_The_Line_Description__c)}) );
        results.add( new row(new List<cell>{new cell('WBS ELEMENT:'), new cell(show.WBS_Element__c), new cell(''), new cell('VENUE/LOCATION:'), new cell(show.Location_lookup__r.Name)}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('SUMMARY/LOGLINE:'),new cell(show.Concept__c)}));
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Contacts')}) );
        List<Show_Contact__c> balaExecs = new List<Show_Contact__c>();
        if ( showContactMap.containsKey('BALA') && showContactMap.get('BALA').size() > 0 ){
            for ( Show_Contact__c sc : showContactMap.get('BALA') ){
                results.add( new row(new List<cell>{new cell('CC BALA:'),new cell(sc.Full_Name__c)}) );
            }
        } else {
            results.add( new row(new List<cell>{new cell('CC BALA:'),new cell('')}) );
        }
        results.add( new row(new List<cell>{new cell(''),new cell('')}) );

        if ( showContactMap.containsKey('Production') && showContactMap.get('Production').size() > 0 ){
            for ( Show_Contact__c sc : showContactMap.get('Production') ){
                results.add( new row(new List<cell>{new cell('CC PRODUCTION:'),new cell(sc.Full_Name__c)}) );
            }
        } else {
            results.add( new row(new List<cell>{new cell('CC PRODUCTION:'),new cell('')}) );
        }
        results.add( new row(new List<cell>{new cell(''),new cell('')}) );

        if ( showContactMap.containsKey('Development Executive') && showContactMap.get('Development Executive').size() > 0 ){
            for ( Show_Contact__c sc : showContactMap.get('Development Executive') ){
                results.add( new row(new List<cell>{new cell('CC DEVELOPMENT:'),new cell(sc.Full_Name__c)}) );
            }
        } else {
            results.add( new row(new List<cell>{new cell('CC DEVELOPMENT:'),new cell('')}) );
        }
        results.add( new row(new List<cell>{new cell(''),new cell('')}) );

        results.add( new row(new List<cell>{new cell('CC TALENT:'),new cell('')}) );
        results.add( new row(new List<cell>{new cell(''),new cell('')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('PRODUCTION COMPANY:'),new cell(show.Production_Company_Account__r.Name)}) );

        if ( showContactMap.containsKey('Executive Producer') && showContactMap.get('Executive Producer').size() > 0 ){
            for ( Show_Contact__c sc : showContactMap.get('Line Producer') ){
                results.add( new row(new List<cell>{new cell('EXECUTIVE PRODUCERS:'),new cell(sc.Full_Name__c)}) );
            }
        } else {
            results.add( new row(new List<cell>{new cell('EXECUTIVE PRODUCERS:'),new cell('')}) );
        }


        if ( showContactMap.containsKey('Line Producer') && showContactMap.get('Line Producer').size() > 0 ){
            for ( Show_Contact__c sc : showContactMap.get('Line Producer') ){
                results.add( new row(new List<cell>{new cell('LINE PRODUCER/UPM:'),new cell(sc.Full_Name__c)}) );
                results.add( new row(new List<cell>{new cell('PHONE:'),new cell(sc.Contact__r.Phone)}) );
                results.add( new row(new List<cell>{new cell('EMAIL:'),new cell(sc.Contact__r.Email)}) );
            }
        } else {
            results.add( new row(new List<cell>{new cell('LINE PRODUCER/UPM:'),new cell('')}) );
        }

        if ( showContactMap.containsKey('Executive Producer') && showContactMap.get('Executive Producer').size() > 0 ){
            for ( Show_Contact__c sc : showContactMap.get('Line Producer') ){
                results.add( new row(new List<cell>{new cell('EXECUTIVE PRODUCERS:'),new cell(sc.Full_Name__c)}) );
            }
        } else {
            results.add( new row(new List<cell>{new cell('EXECUTIVE PRODUCERS:'),new cell('')}) );
        }

        results.add( new row(new List<cell>{new cell('PRODUCTION ACCOUNTANT:'),new cell('')}) );
        results.add( new row(new List<cell>{new cell('PAYROLL COMPANY:'),new cell('Cast and Crew')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('schedule')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('WRITING'),new cell(show.Writing_Period_Start_Date__c)}) );
        results.add( new row(new List<cell>{new cell('PRE-PRODUCTION'),new cell(show.Pre_Production_Start_Date__c)}) );
        results.add( new row(new List<cell>{new cell('SHOOT'),new cell(show.Production_Start_Date__c)}) );
        results.add( new row(new List<cell>{new cell('POST'),new cell(show.Post_Production_Start_Date__c)}) );
        results.add( new row(new List<cell>{new cell('MISC'),new cell(show.Delivery__c)}) );

        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('coverage and signatory information')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell(''),new cell('COVERAGE'),new cell('SIGNATORY INFORMATION')}) );
        for ( Show_Rate__c sr : show.Show_Rates__r ){
            results.add( new row(new List<cell>{new cell(''),new cell(''),new cell(sr.Signatory__r.Name)}) );

        }
        return results;
    }

    public static List<row> getNetworkContactList(Id showId){
        Show__c show = queryShow(showId);
        Map<String, List<Show_Contact__c>> showContactMap = new Map<String, List<Show_Contact__c>>();
        for ( Show_Contact__c sc : show.Show_Contacts__r ){
            List<Show_Contact__c> showContacts = new List<Show_Contact__c>();
            if ( showContactMap.containsKey(sc.Type__c) ){
                showContacts = showContactMap.get(sc.Type__c);
            }
            showContacts.add(sc);
            showContactMap.put(sc.Type__c,showContacts);
        }

        List<row> results = new List<row>();
        results.add( new row(new List<cell>{new cell('Comedy Central')}) );
        results.add( new row(
            new List<cell>{new cell(''),
            new cell('COMEDY CENTRAL\n1575 N GOWER STREET\nHOLLYWOOD, CA  90028\nP: 310-752-8000'),
            new cell('COMEDY CENTRAL\n345 HUDSON STREET\nNEW YORK, NY  10014\nP: 212-767-8600'),new cell('')}) );
        results.add( new row(new List<cell>{new cell(show.Name)}) );
        results.add( new row(new List<cell>{new cell('NETWORK CONTACT LIST')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('President, Comedy Central / KENT ALTERMAN / Kent.Alterman@comedycentral.com / 310-407-4780')}) );
        results.add( new row(new List<cell>{new cell(''),new cell('Assistant to Kent Alterman / ANNA LOCKHART / anna.lockhardt@comedycentral.com / 310-407-1208')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('TALENT & DEVELOPMENT')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('EVP, Talent & Development, East Coast / SARAH BABINEAU / Sarah.Babineau@comedycentral.com / 212-767-8720')}) );
        results.add( new row(new List<cell>{new cell(''),new cell('Assistant to Sarah Babineau / MICHAEL STANGER / Michael.Stanger@comedycentral.com / 212-767-8683')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('EVP, Talent & Development, West Coast / JONAS LARSEN / Jonas.Larsen@comedycentral.com / 310-407-4765')}) );
        results.add( new row(new List<cell>{new cell(''),new cell('Assistant to Jonas Larson / JACKIE SOSA / Jacie.Sosa@comedycentral.com / 310-752-8853')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('PRODUCTION')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('EVP, Production - Viacom Global Entertainment Group / MOMITA SENGUPTA / Momita.SenGupta@viacom345.com / 310-407-4714')}) );
        results.add( new row(new List<cell>{new cell(''),new cell('Assistant to Momita SenGupta / MARIANA RAMIREZ / mariana.ramirez@mtvstaff.com / 310-752-8185')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('SVP, Production - Comedy Central / MEGAN RING / Megan.Ring@comedycentral.com / 212-767-8926')}) );
        results.add( new row(new List<cell>{new cell(''),new cell('Assistant to Megan Ring / SYNDI HUYNH / Syndi.Huynh@comedycentral.com / 212-654-4676')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('BUSINESS AND LEGAL AFFAIRS')}) );

        if ( showContactMap.containsKey('BALA') && showContactMap.get('BALA').size() > 0 ){
            for ( Show_Contact__c sc : showContactMap.get('BALA') ){
                results.add( new row(new List<cell>{new cell(sc.Full_Name__c.toUpperCase() + ' / ' + sc.Contact__r.Phone + ' / ' + sc.Contact__r.Email)}) );
            }
        }

        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('POST PRODUCTION OPERATIONS')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('VP, Post Production Operations - Viacom Global Entertainment Group / DEBBIE KIRSH / Debbie.Kirsh@viacom345.com / 212-767-8784')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Sr. Director, Post Production Operations - Viacom Global Entertainment Group / KIMBERLY ALLEN / Kimberly.Allen@viacom345.com / 212-767-9840')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Manager, Post Production Operations - Viacom Global Entertainment Group / LAURA PRESEDO / Laura.Presedo@viacom.com / 212-654-5740')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('FINANCE')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('VP, Finance / PATRICIA GOGEV / Patricia.Gogev@viacom.com / 212-846-4373')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('STANDARDS AND PRACTICES')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('VP, Standards and Practices / DEBORAH LAKE / Deborah.Lake@viacom.com / 212-846-3954')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Sr. Director, Standards and Practices / KRISTIE CARLSON / Kristie.Carlson@viacom.com / 212-846-7211')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('PRODUCTION CONTENT REVIEW (LITIGATION AND IP)')}) );
        //results.add( new row(new List<cell>{new cell('')}) );
        if ( showContactMap.containsKey('IP Lit') && showContactMap.get('IP Lit').size() > 0 ){
            for ( Show_Contact__c sc : showContactMap.get('IP Lit') ){
                results.add( new row(new List<cell>{new cell(sc.Full_Name__c.toUpperCase() + ' / ' + sc.Contact__r.Phone + ' / ' + sc.Contact__r.Email)}) );
                //results.add( new row(new List<cell>{new cell('')}) );
            }
        }
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('MUSIC AND MEDIA LICENSING')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('VP, Music and Media Licensing / SHARI ROTHSEID / Shari.Rothseid@viacom.com / 212-654-8588')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Sr. Director, Music and Media Licensing / WANDA McSWAIN / Wanda.Mcswain@viacom.com / 212-654-8575')}) );
        //results.add( new row(new List<cell>{new cell('')}) );
        if ( showContactMap.containsKey('MML') && showContactMap.get('MML').size() > 0 ){
            for ( Show_Contact__c sc : showContactMap.get('MML') ){
                results.add( new row(new List<cell>{new cell(sc.Full_Name__c.toUpperCase() + ' / ' + sc.Contact__r.Phone + ' / ' + sc.Contact__r.Email)}) );
                //results.add( new row(new List<cell>{new cell('')}) );
            }
        }
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('CONSUMER PRODUCTS')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('DOWNLOAD-TO-OWN, DVD AND  BONUS CONTENT:')}) );
        results.add( new row(new List<cell>{new cell('Manager, Video /ALEXANDRA VILLELLA / Alexandra.Villella@viacom.com /212-767-4287')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('CC RECORDS, CC RADIO, PODCASTS:')}) );
        results.add( new row(new List<cell>{new cell('Sr. Director, Audio / DARA FRANK / Dara.Frank@viacom.com / 212-846-4427')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('BRAND LICENSING AND MERCHANDISE:')}) );
        results.add( new row(new List<cell>{new cell('Director, Licensing & Merchandise / VALERIE LUGTU / Valerie.Lugtu@viacom.com / 212-846-3555')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('RISK MANAGEMENT')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Manager, Employment Law / CAMILLE JOHNSON / Camille.Johnson@viacom.com / 212-846-8089')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Sr. Director, Production Safety / CHRISTOPHER VELVIN / Chris.Velvin@viacom.com / O: 310-752-8593 / C: 424-280-9674')}) );

        results.add( new row(new List<cell>{new cell('LABOR RELATIONS/RESIDUALS')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('VP, Labor Relations, Viacom Music & Entertainment Group / JONAH COZIEN / Jonah.Cozien@viacom.com / 310-407-4723')}) );
        results.add( new row(new List<cell>{new cell(''),new cell('Assistant to Jonah Cozien/ SUZANNE SIMMONS / Suzanne.Simmons@viacom.com /  310-752-8207')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Sr. Manager, Labor Relations, Viacom Music & Ent. Group / BERTHA DELGADO-TORRES / Bertha.Delgado-Torres@viacom.com / 310-407-4743')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Sr. Director, Residuals and Guild Management / GLEN THOMASSON / Glen.Thomasson@viacom.com / 615-807-7219')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Residuals Analyst, Residuals and Guild Management / MICHAEL DROSS / Michael.Dross@viacom.com / 212-846-4981')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('MARKETING')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('SVP, Velocity / MICHELLE ZONI / Michelle.Zoni@viacom.com / 212-846-6881')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('VP, Integrated Marketing / MATTHEW MARCUS / Matthew.Marcus@viacom.com / 310-752-8852')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Sr. Director, Integrated Marketing / BROOKE HECKER / Brooke.Hecker@viacom.com / 212-767-8631')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Sr. Director, Integrated Marketing / JASMINE VICTOR / Jasmine.Victor@viacom.com / 310-907-2427')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('Director, Velocity / BENJAMIN CASPER / Benjamin.Casper@viacom.com / 212-767-8701')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        results.add( new row(new List<cell>{new cell('MULTIPLATFORM')}) );
        //results.add( new row(new List<cell>{new cell('')}) );
        if ( showContactMap.containsKey('Multiplatform') && showContactMap.get('Multiplatform').size() > 0 ){
            for ( Show_Contact__c sc : showContactMap.get('Multiplatform') ){
                results.add( new row(new List<cell>{new cell(sc.Full_Name__c.toUpperCase() + ' / ' + sc.Contact__r.Phone + ' / ' + sc.Contact__r.Email)}) );
                //results.add( new row(new List<cell>{new cell('')}) );
            }
        }
        results.add( new row(new List<cell>{new cell('')}) );
        
        return results;
    }

    public static List<row> getNetworkDistributionList(Id showId){
		Show__c show = queryShow(showId);

        List<row> results = new List<row>();
        results.add( new row(new List<cell>{new cell('Comedy Central')}) );
        results.add( new row(new List<cell>{new cell(show.Name)}) );
        results.add( new row(new List<cell>{new cell('NETWORK DISTRIBUTION LISTS')}) );
		//if (production type is 'series')
		//else if (production type is 'pilot' or 'presentation')
		//else if (production type is 'special')

        //if ( 'Specials' ){
		results.add( new row(new List<cell>{new cell('CONTACT/CREW LIST'),new cell(''),new cell('DISTRIBUTE UPON NEW REVISION')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        //if ( 'Specials' ){
        results.add( new row(new List<cell>{new cell('DRIVER SETUP FORM'),new cell(''),new cell('DISTRIBUTE UPON NEW REVISION')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        //if ( 'Specials' ){
        results.add( new row(new List<cell>{new cell('AFTRA AND DGA SETUP FORMS'),new cell(''),new cell('IF CENTRAL IS THE SIGNATORY: DISTRIBUTE AS SOON AS INFO IS AVAILABLE')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        //if ( 'Specials' ){
        results.add( new row(new List<cell>{new cell('CALENDAR'),new cell(''),new cell('DISTRIBUTE UPON NEW REVISION')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        //if ( 'Specials' ){
        results.add( new row(new List<cell>{new cell('SCHEDULE'),new cell(''),new cell('DISTRIBUTE UPON NEW REVISION')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        //if ( 'Specials' ){
        results.add( new row(new List<cell>{new cell('CALL SHEETS'),new cell(''),new cell('AT LEAST 24 HOURS BEFORE SHOOT')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        //if ( 'Specials' ){
        results.add( new row(new List<cell>{new cell('PRODUCTION REPORTS'),new cell(''),new cell('24 HOURS AFTER SHOOT')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        //if ( 'Specials' ){
        results.add( new row(new List<cell>{new cell('CONTRACT CHART'),new cell(''),new cell('DISTRIBUTE EVERY FRIDAY')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        //if ( 'Specials' ){
        results.add( new row(new List<cell>{new cell('CREDITS'),new cell(''),new cell('DISTRIBUTE UPON NEW REVISION')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        //if ( 'Specials' ){
        results.add( new row(new List<cell>{new cell('CONTENT VETTING - SCRIPTS'),new cell(''),new cell('DISTRIBUTE UPON NEW REVISION AS DETERMINED BY YOUR COMEDY CENTRAL CREATIVE EXECUTIVE')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        //if ( 'Specials' ){
        results.add( new row(new List<cell>{new cell('CONTENT VETTING - CUTS'),new cell(''),new cell('DISTRIBUTE UPON NEW CUT AS DETERMINED BY YOUR COMEDY CENTRAL CREATIVE EXECUTIVE')}) );
        results.add( new row(new List<cell>{new cell('')}) );

        return results;
    }

    public static List<row> getASSUMPTIONS(Id showId){
        Show__c show = queryShow(showId);
        List<String> guilds = new List<String>();
        if ( show.Covered_By_DGA__c > 0 ){
            guilds.add('DGA');
        }
        if ( show.Covered_By_IATSE__c > 0 ){
            guilds.add('IATSE');
        }
        if ( show.Covered_By_SAGAFTRA__c > 0 ){
            guilds.add('SAG/AFTRA');
        }
        if ( show.Covered_By_WGA__c > 0 ){
            guilds.add('WGA');
        }

        List<row> results = new List<row>();
        results.add(new row(new List<cell>{new cell('Assumptions')}) );
        results.add(new row(new List<cell>{new cell('DATE:'), new cell(system.today()+'')}) );
        results.add(new row(new List<cell>{new cell('SHOW:'), new cell(show.Name)}) );
        results.add(new row(new List<cell>{new cell('CYCLE/SEASON:'), new cell(show.Season__c)}) );
        results.add(new row(new List<cell>{new cell('EPISODES:'), new cell(show.NumberofEps__c)}) );
        results.add(new row(new List<cell>{new cell('PRODUCTION BUDGET:'), new cell(show.Production__c)}) );
        results.add(new row(new List<cell>{new cell('UNION/GUILDS:'), new cell(String.join(guilds,', ')) }) );
        results.add(new row(new List<cell>{new cell('PRODUCTION COMPANY:'), new cell(show.CentralProductions__c)}) );
        results.add(new row(new List<cell>{new cell('')}));

        results.add(new row(new List<cell>{new cell('schedule')}));
        results.add(new row(new List<cell>{new cell('WRITING'),new cell(show.Writing_Period_Start_Date__c)}) );
        results.add(new row(new List<cell>{new cell('PRE-PRODUCTION'),new cell(show.Pre_Production_Start_Date__c)}) );
        results.add(new row(new List<cell>{new cell('SHOOT'),new cell(show.Production_Start_Date__c)}) );
        results.add(new row(new List<cell>{new cell('POST'),new cell(show.Post_Production_Start_Date__c)}) );
        results.add(new row(new List<cell>{new cell('MISC'),new cell(show.Delivery__c)}) );
        results.add(new row(new List<cell>{new cell('')}));

        results.add(new row(new List<cell>{new cell('writing staff')}));
        results.add(new row(new List<cell>{new cell('EPs/WRITERS:')}));
        results.add(new row(new List<cell>{new cell('NUMBER OF WRITERS:')}));
        results.add(new row(new List<cell>{new cell('WEEKS:')}));
        results.add(new row(new List<cell>{new cell('OTHER:')}));
        results.add(new row(new List<cell>{new cell('')}));

        results.add(new row(new List<cell>{new cell('talent')}));
        results.add(new row(new List<cell>{new cell('PER CONTRACT')}));
        results.add(new row(new List<cell>{new cell('')}));

        results.add(new row(new List<cell>{new cell('assumptions')}));
        results.add(new row(new List<cell>{new cell('Copy and paste assumptions here')}));

        return results;
    }

    public static List<row> getDueDateSummary(Id showId){
        Show__c show = queryShow(showId);
        Set<String> guilds = new Set<String>();
        for ( Show_Rate__c r : show.Show_Rates__r ){
            guilds.add(r.Guild__c);
        }

        List<row> results = new List<row>();
        results.add( new row(new List<cell>{
            new cell('Made 4 Market'),
            new cell('Secondary Market'),
            new cell('Guild'),
            new cell('Basis'),
            new cell('Due Date'),
            new cell('Example'),
            new cell('Materials Due to Residuals by')
        }) );
        results.add( new row(new List<cell>{
            new cell('Basic Cable'),
            new cell('Basic Cable'),
            new cell(String.join( new List<String>(guilds),', ') ),
            new cell('Air Date'),
            new cell('120 Days after Re-Air Date'),
            new cell('Program Re airs on March 1, payment due to guilds on is 6/29'),
            new cell('')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell(''),
            new cell(''),
            new cell(''),
            new cell(''),
            new cell(''),
            new cell('')
        }) );
        results.add( new row(new List<cell>{
            new cell('Basic Cable'),
            new cell('ADSS'),
            new cell(String.join( new List<String>(guilds),', ') ),
            new cell('Airing Window'),
            new cell('67 Days after Free period'),
            new cell('Product begins streaming on March 1, 1st 7 days  are free, residuals are due 5/7'),
            new cell('')
        }) );
        return results;
    }


    public static List<row> getPackageFeeCalculation(Id showId){
        Show__c show = queryShow(showId);

        List<row> results = new List<row>();
        results.add( new row(new List<cell>{new cell('package fee calculation')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('DATE:'),new cell(system.today()),new cell('PACKAGE FEE DUE TO:'),new cell(show.Vendor_Name__c)}) );
        results.add( new row(new List<cell>{new cell('SHOW:'),new cell(show.Name),new cell('VENDOR NUMBER:'),new cell(show.Vendor_Id__c)}) );
        results.add( new row(new List<cell>{new cell('CYCLE/SEASON:'),new cell(show.Season__c),new cell('WBS ELEMENT:'),new cell(show.WBS_Element__c)}) );
        results.add( new row(new List<cell>{new cell('EPISODES:'),new cell(show.NumberofEps__c)}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{
            new cell('LOCKED BUDGET:'),
            new cell('$0.00'),
            new cell('PRODUCTION BUDGET BEFORE TAX CREDIT (IF ANY)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS ESTIMATED PACKAGE FEE)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS FRINGES)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS FRINGES)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS CONTINGENCIES)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS CURRENCY FLUCTUATION RESERVES)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS LEGAL FEES)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS DEFERMENTS)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS COMPLETION BOND FEES)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS COMPLETION BOND FEES)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS PRIZE MONIES)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS SETTLEMENTS)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS INTEREST)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS FINANCING COSTS)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS OVERAGES)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS BREAKAGE)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS ANY PRESENTATION, PILOT OR OTHER DEVELOPMENT COSTS - IF INCLUDED IN THE BUDGET AT ALL)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS BANK FEES)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('(LESS OTHER - FOR EXAMPLE: "best of", promotional, clip and "after" shows)')
        }) );
        results.add( new row(new List<cell>{
            new cell(''),
            new cell('$0.00'),
            new cell('ADJUSTED BUDGET FOR PACKAGE CALCULATION')
        }) );

        return results;
    }

    public static List<row> getSAGAFTRAFinalCastList(Id showId){
        Show__c show = queryShow(showId);

        List<row> results = new List<row>();
        results.add( new row(new List<cell>{new cell(show.Name)}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{
            new cell('Actor'),
            new cell('Episode Number'),
            new cell('Sketch or Episode Title'),
            new cell('Series Regular, Recurring, or Day Player'),
            new cell('Use of Name'),
            new cell('Photo/Actual Likeness'),
            new cell('Excerpt of Perfomance (On Air)'),
            new cell('Excerpt of Perfomance (Digital)'),
            new cell('BTS Footage (non-bloopers)'),
            new cell('Bloopers'),
            new cell('Addl Info'),
            new cell('Notes')
        }) );

        return results;
    }

    public static List<row> getWGAWeeklyWorkList(Id showId){
		Show__c show = queryShow(showId);

        List<row> results = new List<row>();
        results.add( new row(new List<cell>{new cell('WEEKLY WORKLIST - NOTICE OF HIRE')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('To:')}) );
        results.add( new row(new List<cell>{new cell('')}) );
        results.add( new row(new List<cell>{new cell('WGAW')}) );
        results.add( new row(new List<cell>{new cell('MEMBERSHIP DEPT')}) );
        results.add( new row(new List<cell>{new cell('7000 WEST 3RD ST')}) );
        results.add( new row(new List<cell>{new cell('LOS ANGELES CA  90048-4321')}) );
        results.add( new row(new List<cell>{
            new cell(''),new cell(''),
            new cell(''),new cell(''),new cell(''),new cell(''),
            new cell(''),new cell(''),new cell('CONTACT NAME:')}) );
        results.add( new row(new List<cell>{
            new cell('PHONE:'),new cell('(323) 782-4532'),
            new cell(''),new cell(''),new cell(''),new cell(''),
            new cell(''),new cell(''),new cell(''),new cell('PHONE:')
        }) );
        results.add( new row(new List<cell>{
            new cell('FAX:'),new cell('(323) 782-4804'),
            new cell(''),new cell(''),new cell(''),new cell(''),
            new cell(''),new cell(''),new cell(''),new cell('FAX:')
        }) );
        results.add( new row(new List<cell>{
            new cell('EMAIL:'),new cell('membership@wga.org'),
            new cell(''),new cell(''),new cell(''),new cell(''),
            new cell(''),new cell(''),new cell(''),new cell('EMAIL:')
        }) );
        results.add( new row(new List<cell>{
            new cell('LAST NAME'),new cell('FIRST'),new cell('MIDDLE'),new cell('SUFFIX'),
            new cell('SS#'),new cell('DEAL TYPE'),new cell('FIELD OF WORK'),new cell('PROJECT'),
            new cell('EPISODE'),new cell('EPISODE #'),new cell('START'),new cell('FINISH'),new cell('ADDL DATA')
        }) );
        return results;
    }
}