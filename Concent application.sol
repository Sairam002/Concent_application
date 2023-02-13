//SPDX-License-Identifier:Unknown
pragma solidity ^0.8.0;


contract concent {

    address[] issuer = [0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2];
    
    modifier onlyissuer{
        for(uint i = 0; i < issuer.length; i++){
            if(msg.sender == issuer[i]){
                _;
            }
        }
    }

    modifier personInPersonalDataArray(address _personAddress){
        bool isThere = false;
        for(uint i = 0; i < (ownerGivenPermissionForPersonalData[_personAddress]).length; i++){
            if(msg.sender == (ownerGivenPermissionForPersonalData[_personAddress])[i]){
                isThere = true;
            }
            else if(msg.sender == personalDataMap[msg.sender].OwnerAddress){
                isThere = true;
            }
            else{
                continue;
            }
        }

        if(isThere == true){
            _;
        }
    }

    modifier personInLocationDataArray(address _personAddress){
        bool isThere = false;
        for(uint i = 0; i < (ownerGivenPermissionForLocationData[_personAddress]).length; i++){
            if(msg.sender == (ownerGivenPermissionForLocationData[_personAddress])[i]){
                isThere = true;
            }
            else if(msg.sender == personalDataMap[msg.sender].OwnerAddress){
                isThere = true;
            }
            else{
                continue;
            }
        }

        if(isThere == true){
            _;
        }
    }

    mapping (address => PersonalData) personalDataMap;
    mapping(address => Location) locationMap;
    mapping(address => address[]) ownerGivenPermissionForPersonalData;
    mapping(address => address[]) ownerGivenPermissionForLocationData;
    
    struct PersonalData{
        string name;
        uint age;
        address OwnerAddress;
    }
    PersonalData[] personalData;

    struct Location{
        string country;
        string state;
        string doorNumber;
        address OwnerAddress;
    }
    Location[] location;

    function addPersonalData(string memory _name, uint _age) public onlyissuer{
        personalData.push(PersonalData(_name, _age, msg.sender));
        personalDataMap[msg.sender] = PersonalData(_name, _age, msg.sender);
    }

    function addlocationData(string memory _country, string memory _state, string memory _doorNumber)public onlyissuer {
        location.push(Location(_country, _state, _doorNumber, msg.sender));
        locationMap[msg.sender] = Location(_country, _state, _doorNumber, msg.sender);    }

    function giveConcentForPersonalData(address _to) public{
        require(msg.sender == personalDataMap[msg.sender].OwnerAddress);
        ownerGivenPermissionForPersonalData[msg.sender].push(_to);
    }

    function giceConcentForLocationData(address _to) public{
        require(msg.sender == locationMap[msg.sender].OwnerAddress);
        ownerGivenPermissionForLocationData[msg.sender].push(_to);
    }

    function removeConcentForPersonalData(address _to) public{
        require(msg.sender == personalDataMap[msg.sender].OwnerAddress);
        delete ownerGivenPermissionForPersonalData[_to];
    }

    function removeConcentForLocationData(address _to) public{
        require(msg.sender == locationMap[msg.sender].OwnerAddress);
        delete ownerGivenPermissionForLocationData[_to];
    }

    function getPersonalDataMap(address _personAddress) public view personInPersonalDataArray(_personAddress) returns(PersonalData memory){
        return personalDataMap[_personAddress];
    }
    
    function getLocationMap(address _personAddress) public view personInLocationDataArray(_personAddress) returns(Location memory){
        return locationMap[_personAddress];
    } 
    function getownerGivenPermissionForPersonalData() public view returns(address[] memory){
        return ownerGivenPermissionForPersonalData[msg.sender];
    }

    function getownerGivenPermissionForLocationData() public view returns(address[] memory){
        return ownerGivenPermissionForLocationData[msg.sender];
    }
}