(function () {
    'use strict';

    angular.module('claimapp')
        .controller('IndexController', function (StaticDataFactory, $scope, $uibModal, $timeout) {

            
            var vm = this;

            //Available function calles
            vm.unClaimQueue = unClaimQueue;
            vm.claimQueue = claimQueue;
            vm.selectQueue = selectQueue;
            vm.showResultDialog = showResultDialog;
            vm.showinfomodal = showinfomodal;
            vm.showinfomodal2 = showinfomodal2;
            vm.erase = erase;

            //Global variables
            vm.selectedbusinessdomain = "";
            vm.selectedservapp = "";
            vm.itemselected = "false";
            vm.selectedLdapGroup = "";
            vm.selectedManagementRole = "";
            vm.disableButton = false;
            vm.message = "Claim Application";
            vm.message2 = "My Claimed Applications";
            vm.dummy = "dummy informatie voor de ingelogde user";
            vm.ldapgroup = "BeheerSectie4";
            vm.claimRoles = [];

           
            //Initialisation, making sure this happens after services.js initialises the API-urls.
            
            $timeout(function()
            {
                getAvailableRoles();
                getqueues();
                getclaimedrecordslist();
            },0);
            

            //Watching the inputbox for keystrokes, adding it to a filtered list.
            $scope.$watch(function () {
                return vm.inputbox;
            },
                function (current, original) 
                {
                    
                    if (vm.queues === undefined) {
                        return;
                    }
                    if (current.length < 2) {
                        return;
                    }
                    vm.queuelistFiltered = [];
                    vm.queues.forEach(function (queueobject) {
                        if (queueobject.name.toUpperCase().includes(current.toUpperCase())) 
                        {
                            vm.queuelistFiltered.push(queueobject.name);
                        }
                    });
                    
                }, true);

            function erase() {
                vm.inputbox = "";
                document.getElementById("enterq").focus();
                vm.selecteditem = "";
            }

            //Responding to the dropdown. The displayed list will contain the queues with the same businessdomain and applicationname.
            function selectQueue() {
                if (vm.selecteditem === null) return;
                var myitem;
                for (var i =0 ; i, vm.queues.length ; i++)
                {
                    if (vm.queues[i].name === vm.selecteditem)
                    {
                        vm.selectedservapp = vm.queues[i].servapplname;
                        vm.selectedbusinessdomain = vm.queues[i].businessdomain;
                        
                        break;
                    }
                }
                var appobj = {};
                
                vm.applist = [];
                
                vm.queues.forEach(function (item) {
                    if (item.servapplname === vm.selectedservapp && item.businessdomain === vm.selectedbusinessdomain) {
                        vm.applist.push(item.name);
                    }
                });
            }

            //Getting a list of all available claim roles
            function getAvailableRoles() {
                StaticDataFactory.getAvailableRoles().then(function (data) {
                    vm.claimRoles = data.roles.role;
                    if(typeof vm.claimRoles === 'string')
                    {
                        vm.claimRoles = [];
                        vm.claimRoles.push(data.roles.role);
                    }
                    vm.selectedManagementRole = vm.claimRoles[0];
                    
                });
            }

            // Getting a list of all my claimed records
            function getclaimedrecordslist() {
                StaticDataFactory.GetClaimedRecordsList().then(function (data) {
                    if(data === undefined)
                    {
                        return;
                    }
                    vm.claimedRecords = data.claimedrecords;
                });
            }

            //Getting all the available Tibco queues
            function getqueues() {
                StaticDataFactory.getAllTibcoQueues().then(function (data) {
                    vm.queues = data.queues.queue;
                    document.getElementById("enterq").focus();
                    
                });
            }

            function claimQueue() {
                vm.disableButton = !vm.disableButton;
                Pace.start();
                
                if (vm.selectedLdapGroup.length === 0 || vm.selectedManagementRole.length === 0) {
                    showResultDialog({data:"Please fill LDAP-group; you will need something like 'CN=GRATAB-nJAMS_Application_Role_Control,OU=Application Security Groups,OU=Groups,OU=TST,OU=AB,OU=Tenants,DC=INSIM,DC=BIZ'"});
                    vm.disableButton = !vm.disableButton;
                    return;
                }
                return StaticDataFactory.claimQueue(vm.selectedbusinessdomain, vm.selectedservapp, vm.selectedLdapGroup, vm.selectedManagementRole).then(function (res) {
                    showResultDialog(res);
                    getclaimedrecordslist();
                    vm.disableButton = !vm.disableButton;
                }, function (error) {
                    showResultDialog(error);
                });
            }

            function unClaimQueue(index) {
                vm.disableButton = !vm.disableButton;
                var itemtodelete = vm.claimedRecords.record[index];
                if(vm.selectedManagementRole !== itemtodelete.claimrole)
                {
                    showResultDialog({data:"You have to own this queue before you can unclaim it!"});
                    vm.disableButton = !vm.disableButton;
                    return;
                }
                return StaticDataFactory.unClaimQueue(itemtodelete.businessdomain, itemtodelete.servapplname, itemtodelete.role, itemtodelete.claimrole)
                .then(function (res) {
                    vm.claimedRecords.record.splice(index, 1);
                    showResultDialog(res);
                    vm.disableButton = !vm.disableButton;
                }, function (error) {
                    showResultDialog(error);
                });
            }

            function showResultDialog(serverreponse) {
                var modalInstance = $uibModal.open(
                    {
                        templateUrl: "./views/claimresponse.html",
                        controller: "showResultDialog as vm2",
                        size: "lg",
                        resolve: {
                            response: function () {
                                return serverreponse;
                            }
                        }
                    });
                modalInstance.result.then(
                    function success(resp) {

                    }, function failure(err) {

                    });
            }

            function showinfomodal() {
                var modalInstance = $uibModal.open(
                    {
                        templateUrl: "./views/infomodal.html",
                        controller: "showInfoModal as vm3",
                        size: "lg"

                    });
                modalInstance.result.then(
                    function success(resp) {

                    }, function failure(err) {

                    });

            }

            function showinfomodal2() {
            
                showResultDialog({ data: "Some info about show info my claimed queues." })
            }

        })

        //info modal rechts bovenin
        .controller('showInfoModal', function ($uibModalInstance) {
            

            var vm3 = this;
            vm3.closeModal = closeModal;

            function closeModal() {
                $uibModalInstance.dismiss();
            }
        })

        .controller('showResultDialog', function ($uibModalInstance, response) {
            
            var vm2 = this;
            vm2.message = response.data;
            vm2.closeModal = closeModal;

            function closeModal() {
                $uibModalInstance.dismiss();
            }
        })

})();


