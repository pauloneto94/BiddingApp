var Bidding = artifacts.require("./Bidding.sol");

contract('MultiNumberBettinV1', function(accounts){
    it("Should assert true", function(){
        var bidding;
        return Bidding.deployed().then(function(instance){
            bidding = instance;
            bidding.placeBid("Paulo", 20, {from: accounts[0]});
            return bidding.getHighBid.call();
        }).then(function(result){
            console.log(result.toNumber());
            bidding.placeBid("Joao", 15, {from: accounts[1]});
            return bidding.getHighBid.call();
        }).then(function(result){
            console.log(result.toNumber());
            bidding.placeBid("Lucas", 30, {from: accounts[2]});
            return bidding.getHighBid.call();
        }).then(function(result){
            console.log(result.toNumber());
            return bidding.getClaimAmount.call({from: accounts[1]});
        }).then(function(result){
            console.log(result.toNumber());
        });
    });
});