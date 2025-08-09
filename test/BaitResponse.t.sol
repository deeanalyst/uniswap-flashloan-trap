// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BaitResponse.sol";

contract BaitResponseTest is Test {
    BaitResponse public baitResponse;

    function setUp() public {
        baitResponse = new BaitResponse();
    }

    function testExecuteBytes() public {
        // 1. Mock the data that would be passed from the FlashBait trap
        address recipient = address(0x1);
        uint256 amount0 = 100e18;
        uint256 amount1 = 200e18;
        bytes memory trapData = abi.encode(recipient, amount0, amount1);

        // 2. Expect the FlashLoanCaught event to be emitted
        vm.expectEmit(true, true, true, true);
        emit BaitResponse.FlashLoanCaught(recipient, amount0, amount1);

        // 3. Call the execute function
        baitResponse.executeBytes(trapData);
    }
}