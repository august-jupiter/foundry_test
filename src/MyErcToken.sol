// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyErcToken is ERC20 {
    error AmountSHouldLargeThan1Ether();

    /**
     * 需要解释一下什么是topic， 什么是data
     * https://book.getfoundry.sh/cheatcodes/expect-emit
     * 被indexed的参数会被放到topic中，没有被indexed的参数会被放到data中
     * */
    event CustomEventOne(address indexed from, address indexed to);
    event CustomEventTwo(address indexed from, address indexed to, uint256 amount, uint256 timestamp);

    constructor() ERC20("AUGUST", "AUG") {
        this;
    }

    function customTransfer(uint256 amount) public pure{
        require(amount > 1 ether, "Amount must be greater than 1 ether");
    }

    function customTransferThrowError(uint256 amount) public pure{
        if(amount < 1 ether){
            revert AmountSHouldLargeThan1Ether();
        }
    } 

    function customEmit() public {
        emit CustomEventOne(msg.sender, msg.sender);
        emit CustomEventTwo(msg.sender, msg.sender, 100, block.timestamp);
    }

    function deposit() public payable {
        
    }
}