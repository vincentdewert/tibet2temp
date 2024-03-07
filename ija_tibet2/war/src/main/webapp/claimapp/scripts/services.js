(function () {
    'use strict';
    var app = angular.module('claimapp');    
        
    app.factory('urlfactory', function()
    {
        var API_URL="";
        return{
            getApiUrl:getApiUrl           
        };
        function getApiUrl()
    {
        var theindex=window.location.href.indexOf("ija_tibet2");
        API_URL = window.location.href.slice(0 , theindex) + "ija_tibet2/api";
        return API_URL;
    }

    });




    app.factory('StaticDataFactory', function ( $http,urlfactory) {        
        return {
            getAllTibcoQueues: getAllTibcoQueues,
            claimQueue: claimQueue,
            unClaimQueue: unClaimQueue,
            getAvailableRoles: getAvailableRoles,
            GetClaimedRecordsList: GetClaimedRecordsList
        };

            
        
        
        function claimQueue(businessdomain, servapplname, role, claimrole)
        {
            var xmlstring = "<input><businessdomain>" + businessdomain + "</businessdomain><servapplname>" + servapplname + "</servapplname><claimrole>" +  claimrole + "</claimrole><role>" + role + "</role></input>";
            return $http({method: 'POST',url: urlfactory.getApiUrl() + '/claimqueue', data : xmlstring, headers: {"Content-Type" : 'application/xml'}})
            .then(function success(response)
            {
                return response;
            },function failure(failmessage)
            {
            	return failmessage;
            });
        }

        function unClaimQueue(businessdomain, servapplname,  role, claimrole)
        {
            var xmlstring = "<input><businessdomain>" + businessdomain + "</businessdomain><servapplname>" + servapplname + "</servapplname><claimrole>" +  claimrole + "</claimrole><role>" + role + "</role></input>";
            return $http({ method: 'POST', url: urlfactory.getApiUrl() + '/unclaimapplications', data: xmlstring, headers: { "Content-Type": 'application/xml' } })
                .then(function success(response) {
                    return response;
                }, function failure(failmessage) {
                    return failmessage;
                });
        }

        function getAllTibcoQueues()
        {
          return $http.get(urlfactory.getApiUrl() + '/getalltibcoqueues').then(function(data)
            {
                var afterCnv = xml.xmlToJSON(data.data);

                return afterCnv;

            }, function (error) {
            });
        }

        function getAvailableRoles()
        {
          return $http.get(urlfactory.getApiUrl() + '/getavailableroles').then(function(data)
            {
                var afterCnv = xml.xmlToJSON(data.data);

                return afterCnv;

            }, function (error) {

                return error;
            });
        }

        function GetClaimedRecordsList()
        {
            return $http.get(urlfactory.getApiUrl() + '/getclaimedrecords').then(function(data)
            {
                var afterCnv = xml.xmlToJSON(data.data) ;
                                
                if (afterCnv.claimedrecords.record.queue === 'dummy')
                {
                    return;
                }

                afterCnv.claimedrecords.record.splice(0,1);
                
                var removeindexes = [];
                afterCnv.claimedrecords.record.forEach( function(element, index)
                {
                    if (element.queue === 'dummy')
                    {
                        removeindexes.push(index);
                    }
                    else
                    {
                        element.queue.splice(0,1);   
                    }
                });
                console.log("alle claimed records na conversie naar json", afterCnv.claimedrecords.record);
                return afterCnv;
            },function (error)
            {
              console.log("server error :", error );
              return error;
            });
        }
    });

})();   