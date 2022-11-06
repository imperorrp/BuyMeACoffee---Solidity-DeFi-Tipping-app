//SPDX-License-Identifier: MIT

// contracts/BuyMeACoffee.sol
pragma solidity ^0.8.0;

//BuyMeACoffee2- updated for challenge #1: enable changing of withdrawal address- line 91 (successfully tested locally) 
//deployed to 0x98f11F3b779Ba4273723E3Afc661D73c2552a6AE
contract BuyMeACoffee {
    // Event to emit when a Memo is created.
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );
    
    // Event to emit when a new withdrawer is set
    event NewWithdrawer(
        address newwithdrawer
    );

    // Memo struct.
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }
    
    // Address of contract deployer. Marked payable so that
    // we can withdraw to this address later.
    address payable owner;

    //Address of new withdrawer. Initially defaults to the owner.
    address payable withdrawer;

    // List of all memos received from coffee purchases.
    Memo[] memos;

    constructor() {
        // Store the address of the deployer as a payable address.
        // When we withdraw funds, we'll withdraw here.
        owner = payable(msg.sender);
        //Default withdrawer is initialized to the owner but can be changed later on
        withdrawer = owner;
    }

    /**
     * @dev fetches all stored memos
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    /**
     * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        // Must accept more than 0 ETH for a coffee.
        require(msg.value > 0, "can't buy coffee for free!");

        // Add the memo to storage!
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // Emit a NewMemo event with details about the memo.
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(withdrawer.send(address(this).balance));
    }

    /**
     * @dev changes withdrawer from owner to some other address
     */
    function changeWithdrawer(address _newwithdrawer) public {
        //Ensure only the contract owner can change withrawal addresses
        require(msg.sender == owner);
        withdrawer = payable(_newwithdrawer);
        emit NewWithdrawer(
            _newwithdrawer
        );
    }

    /**
     * @dev fetches the current withdrawer
     */
    function getCurrentWithdrawer() public view returns (address) {
        return withdrawer;
    }
}