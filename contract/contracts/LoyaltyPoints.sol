// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract LoyaltyPoints {
    // Model a Consumer
    struct Consumer {
        address consumerAddress;
        string firstName;
        string lastName;
        string email;
        uint points;
        bool isRegistered;
    }

    // Model a Partner
    struct Partner {
        address partnerAddress;
        string name;
        bool isRegistered;
    }

    // Model Points Transaction
    enum TransactionType {
        Earned,
        Redeemed
    }
    struct PointsTransaction {
        uint points;
        TransactionType transactionType;
        address consumerAddress;
        address partnerAddress;
    }

    //consumers and partners on the network mapped with their address
    mapping(address => Consumer) public consumers;
    mapping(address => Partner) public partners;

    //public transactions and partners information
    Partner[] public partnersInfo;
    PointsTransaction[] public transactionsInfo;

    //register sender as consumer
    function registerConsumer(
        string memory _firstName,
        string memory _lastName,
        string memory _email
    ) public {
        //check msg.sender in existing consumers
        require(
            !consumers[msg.sender].isRegistered,
            "Account already registered as Consumer"
        );

        //check msg.sender in existing partners
        require(
            !partners[msg.sender].isRegistered,
            "Account already registered as Partner"
        );

        //add consumer account
        consumers[msg.sender] = Consumer(
            msg.sender,
            _firstName,
            _lastName,
            _email,
            0,
            true
        );
    }

    //register sender as partner
    function registerPartner(string memory _name) public {
        //check msg.sender in existing consumers
        require(
            !consumers[msg.sender].isRegistered,
            "Account already registered as Consumer"
        );

        //check msg.sender in existing partners
        require(
            !partners[msg.sender].isRegistered,
            "Account already registered as Partner"
        );

        //add partner account
        partners[msg.sender] = Partner(msg.sender, _name, true);

        //add partners info to be shared with consumers
        partnersInfo.push(Partner(msg.sender, _name, true));
    }

    //update consumer with points earned
    function earnPoints(uint _points, address _partnerAddress) public {
        // only consumer can call
        require(
            consumers[msg.sender].isRegistered,
            "Sender not registered as Consumer"
        );

        // verify partner address
        require(
            partners[_partnerAddress].isRegistered,
            "Partner address not found"
        );

        // update consumer account
        consumers[msg.sender].points = consumers[msg.sender].points + _points;

        // add transction
        transactionsInfo.push(
            PointsTransaction({
                points: _points,
                transactionType: TransactionType.Earned,
                consumerAddress: consumers[msg.sender].consumerAddress,
                partnerAddress: _partnerAddress
            })
        );
    }

    //update consumer with points used
    function usePoints(uint _points, address _partnerAddress) public {
        // only consumer can call
        require(
            consumers[msg.sender].isRegistered,
            "Sender not registered as Consumer"
        );

        // verify partner address
        require(
            partners[_partnerAddress].isRegistered,
            "Partner address not found"
        );

        // verify enough points for consumer
        require(consumers[msg.sender].points >= _points, "Insufficient points");

        // update consumer account
        consumers[msg.sender].points = consumers[msg.sender].points - _points;

        // add transction
        transactionsInfo.push(
            PointsTransaction({
                points: _points,
                transactionType: TransactionType.Redeemed,
                consumerAddress: consumers[msg.sender].consumerAddress,
                partnerAddress: _partnerAddress
            })
        );
    }

    //get length of transactionsInfo array
    function transactionsInfoLength() public view returns (uint256) {
        return transactionsInfo.length;
    }

    //get length of partnersInfo array
    function partnersInfoLength() public view returns (uint256) {
        return partnersInfo.length;
    }
}
