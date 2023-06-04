// SPDX-License-Identifier: 
Unlicensed pragma solidity ^0.8.7; 

//license identifier goes at the top of every file, MIT means it is open source
 // there are four basic data types in solidity: uint(integer non-negative numbers. it is used instead of integers
 // bc they have negative numbers as well), bool, string, address
// uint amountOfMoney
 // bool isTotal = 
// string 'hello' 
// address walletAddress
 //you can send money at any address, wallet address like metamask 

contract Cryptokids{ 

//owner DAD (of the contract)
 //when a contract is deployed is only deployed once, so constructor is only called one time when it's address owner; 
//when "dad" deployes this contract, it's going to call this constructor
 //and sign him his wallet address as the owner 

constructor(){ //msg: global variable available to the contract 
owner = msg.sender; 
}

 //in solidity dictionaries are called mappings 
// string is the key, uint is the value, the mapping is called kids 
//there are four modes of "visibility" in solidity , private and public(already known) //and internal and external. External are those that are accesible from other contracts as well,
 //internal are only visible to the current contract 

mapping (string => uint) public kids 	// uint[5] names; 
//an array of 5 fixed values 
// uint[] names; 
//dynamic array 
// names.push("Travs"); 
// names[0] = "Phil"; 
// delete names["Phil"]; 
// msg.sender; 
//address of sender 
// msg.value;
 //amount of ether provided to this contract in wei, the function should be marked "payable"
 // msg.data; 
//bytes, complete call data 
// msg.gas; 
//remaining gas 
//define kid 
//add kid to contract 
//deposit funds to a contract, specifically to a kid's account 
//kid checks if able to withdraw 
//withdraw the money 
 }


