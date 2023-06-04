// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;

//license identifier goes at the top of every file, MIT means it is open source

// there are four basic data types in solidity: uint(integer non-negative numbers. it is used instead of integers 
// bc they have negative numbers as well), bool, string, address
// uint amountOfMoney
// bool isTotal = 
// string 'hello'
// address walletAddress   //you can send money at any address, wallet address like metamask

///!!!!!
//learnxinyminutes.com SITE TO LEARN SOLIDITY!!!!!
//!!!!!!
// https://www.youtube.com/watch?v=s9MVkHKV2Vw&list=PLMWaiMDcY5ny-Mzu4NFLFEyzQVQnhGbAO&index=6&t=686s

contract Cryptokids{


    //1. owner DAD (of the contract) 
    //when a contract is deployed is only deployed once, so constructor is only called one time when it's - .
    
    address owner; 

    // The event is defined here and then we have to emit it.
    event LogKidFundingReceived(address addr, uint amount, uint contractBalance);

    //when "dad" deployes this contract, it's going to call this constructor
    //and sign him his wallet address as the owner
    constructor(){  //msg: global variable available to the contract
        owner = msg.sender;
    }

    //in solidity dictionaries are called mappings
    // string is the key, uint is the value, the mapping is called kids
    //there are four modes of "visibility" in solidity , private and public(already known)
    //and internal and external. External are those that are accesible from other contracts as well, 
    //internal are only visible to the current contract
    //mapping (string => uint) public kids
 


    // uint[5] names; //an array of 5 fixed values
    // uint[] names; //dynamic array
    // names.push("Travs");
    // names[0] = "Phil";
    // delete names["Phil"];
    
    // msg.sender; //address of sender
    // msg.value;  //amount of ether provided to this contract in wei, the function should be marked "payable"
    // msg.data;   //bytes, complete call data
    // msg.gas;    //remaining gas

    //define kid

    struct Kid{
        address payable walletAddress;
        string firstName; 
        string lastName;
        // all time in solidity is considered uint type
        uint releaseTime;
        uint amount;
        bool canWithdraw;

    }
    // access struct:    Kid.firstName;
    Kid[] public kids; //array of kids objects

    // you can put this function anywhere needed, by calling it from a function call the code jumps here, executes the first command
    // and then the "_;" shows that it has to go back to the function and execute it
    modifier onlyOwner(){
        require(msg.sender == owner, "Only the owner can add kids");
        _;
    }

    //add kid to contract

    // calling strings in the function is bothering for the compiler. 
    // anything stored like that (address owner, on the top of the contract) is called storage, it "persists" on the contract.
    // anything in functions is considered memory, so for strings we have to add the "memory" keyword,
    // so it lives only when the function is running
    function  addKid(address payable walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public onlyOwner(){
         kids.push(Kid(
             walletAddress, firstName, lastName, releaseTime, amount, canWithdraw
         ));
    }
    // then we deploy the contract, in Deployed Contracts section we see 2 buttons: addKid and kids (which corresponds to function
    // and array accordingly), so we choose another account to input to the addKid field, 
    // to add the release time we go to epoch converter, add about 10 minutes later and generate the timestamp
    // When we finish input the data to addKid (the input field must look like this: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, "Achilleas", "Nalmpantis", 1685884281, 0, false)
    // we click addKid and a green check comes up , which describes the gas and other details

    // whenever you call these functions (addKid, balanceOf) it costs gas to interact with the contract (transaction fees)
    // View means that it cannot change the state of the storage variables (i.e. address owner), it can only execute locally, not on the blockchain
    // so it protects the funciton from executing anything on the blockchain that it can cause cost
    // Another option is pure (instead of view). It is more strict and it does not allow to even read storage variables.
    function balanceOf() public view returns (uint){
        return address(this).balance;
    }

    //deposit funds to a contract, specifically to a kid's account
    //when we are sending ether we use payable keyword
    function deposit(address walletAddress) payable public{
        addToKidsBalance(walletAddress);

    }

    // for this small amount of kids we can sacrifice the gas, the loop is not gonna be so large
    function addToKidsBalance(address walletAddress) private onlyOwner(){
        for(uint i=0; i<kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                kids[i].amount += msg.value;
                emit LogKidFundingReceived(walletAddress, msg.value, balanceOf());  //wallet address of the kid
            }
        }
    }

    function getIndex(address walletAddress) view private returns (uint){
        for(uint i=0; i<kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                return i;
            }
        }
        // if the first if is never accessed, nothing is returned, but at the same time we can't use "return -1;" bc we return a uint (only positives)
        //but we don't want to change from uint to int bc we will have to make conversions to other points of the program as well
        return 999;
    }

    //kid checks if able to withdraw
    function availableToWithdraw(address walletAddress) public returns(bool){
        uint i= getIndex(walletAddress);
        require(block.timestamp > kids[i].releaseTime, "you can't withdraw yet");
        if(block.timestamp > kids[i].releaseTime){
            kids[i].canWithdraw  = true;
            return true;
        }
        else{
            return false;
        }
    }


    //withdraw the  money
    // We have to make this function payable bc it must send money to an address when called
    function withdraw(address payable walletAddress) payable public{
        uint i = getIndex(walletAddress);
        require(msg.sender == kids[i].walletAddress, "You must be the kid to withdraw");
        require(kids[i].canWithdraw == true, "you can't withdraw at this time");
        kids[i].walletAddress.transfer(kids[i].amount);
    }

    // when something happens, i.e. an event, you want it to trigger a function


}


// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, "Jane", "Doe",  1685885150, 0, false

