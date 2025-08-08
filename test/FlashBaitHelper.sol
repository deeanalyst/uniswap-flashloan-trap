// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// A helper contract for testing the self-destruct trap.
contract Helper {
    // Destroys the contract and sends any remaining Ether to the specified address.
    function destroy(address payable recipient) public payable {
        (bool success, ) = recipient.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }
}
