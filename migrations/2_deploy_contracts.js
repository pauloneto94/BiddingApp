// #1 Get an instance of the contract to be deployed/migrated
var Bidding = artifacts.require("./Bidding.sol");

module.exports = function(deployer) {
  // #2 Deploy the instance of the contract
  deployer.deploy(Bidding);//, 10);
};