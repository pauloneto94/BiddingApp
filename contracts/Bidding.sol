pragma solidity >=0.4.21 <0.7.0;

contract Bidding{

    address payable owner;
    string name;
    string description;
    uint duration;
    uint startBid;

    uint createdAt;

    struct Bidder{
        address bidder;
        string name;
        uint bidAmount;
        bool claimedEthers;
    }

    //Store all bidders
    Bidder[] bidders;

    //Store the High Bidder
    Bidder highBidder;

    //Events
    event HighBidChanged(address addr, string nm, uint newHighBid);
    event BidFail(address addr, string nm, uint bidAmt);

    modifier OwnerOnly{require(msg.sender == owner, "Not Owner");_;}


    constructor(string memory nm, string memory desc, uint dur, uint sBid) public {
        owner = msg.sender;
        name = nm;
        description = desc;
        duration = dur;
        startBid = sBid;
        createdAt = now;
    }

    function getHighBid() public view returns(uint){
        return highBidder.bidAmount;
    }

    function placeBid(string memory name, uint bid) public payable{
        require((now - createdAt) < duration, "Contract expired");

        uint currentBid = highBidder.bidAmount;
        if(bid <= currentBid){
            emit BidFail(msg.sender, name, bid);
            bidders.push(Bidder(msg.sender, name, bid, false));
        }else{
            bidders.push(Bidder(msg.sender, name, bid, false));
            highBidder.bidder = msg.sender;
            highBidder.name = name;
            highBidder.bidAmount = bid;
            highBidder.claimedEthers = false;
            emit HighBidChanged(msg.sender, name, bid);
        }
    }

    function getClaimAmount() public view returns (uint) {
        for(uint i = 0 ; i < bidders.length ; i++){
            if(msg.sender == bidders[i].bidder){
                if(bidders[i].claimedEthers == false){
                    return bidders[i].bidAmount;
                }else{
                    return 0;
                }
            }
        }
        revert("No bidders from you");
    }

    function claimEthers() public {
        for(uint i = 0 ; i < bidders.length ; i++){
            if(msg.sender == bidders[i].bidder){
                if(bidders[i].claimedEthers == false){
                    msg.sender.transfer(bidders[i].bidAmount);
                    delete(bidders[i]);
                }
            }
        }
        revert("No bidders from you");
    }

    function canBidEnd() public view returns (bool) {
        if(bidders.length == 0){
            if((now - createdAt) < duration){
                return true;
            }else{
                return false;
            }
        }else {
            return false;
        }
    }

    function endBidding() public OwnerOnly{
        selfdestruct(owner);
    }

}