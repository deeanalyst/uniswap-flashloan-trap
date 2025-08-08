// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/FlashBait.sol";

contract FlashBaitTest is Test {
    FlashBait public flashBait;

    function setUp() public {
        flashBait = new FlashBait();
    }

    function testShouldRespond_FlashLoanV3() public view {
        // 1. Mock the transaction trace data for a Uniswap V3 flash loan.
        bytes4 selector = 0xb6313847; // flash(address,uint256,uint256,bytes)
        address recipient = address(0x1);
        uint256 amount0 = 100e18;
        uint256 amount1 = 200e18;
        bytes memory flashData = abi.encodeWithSelector(selector, recipient, amount0, amount1, "");
        bytes[] memory trapData = new bytes[](1);
        trapData[0] = flashData;

        // 2. Call the shouldRespond function
        (bool result, bytes memory data) = flashBait.shouldRespond(trapData);

        // 3. Assert that the trap was triggered
        assertTrue(result, "FlashBait should detect the flash loan");

        // 4. Assert that the returned data is correct
        (address decodedRecipient, uint256 decodedAmount0, uint256 decodedAmount1) = abi.decode(data, (address, uint256, uint256));
        assertEq(decodedRecipient, recipient);
        assertEq(decodedAmount0, amount0);
        assertEq(decodedAmount1, amount1);
    }

    function testShouldRespond_FlashLoanV2() public view {
        // 1. Mock the transaction trace data for a Uniswap V2 flash loan.
        bytes4 selector = 0x022c0d9f; // swap(uint256,uint256,address,bytes)
        uint256 amount0Out = 100e18;
        uint256 amount1Out = 200e18;
        address to = address(0x1);
        bytes memory flashData = abi.encodeWithSelector(selector, amount0Out, amount1Out, to, "");
        bytes[] memory trapData = new bytes[](1);
        trapData[0] = flashData;

        // 2. Call the shouldRespond function
        (bool result, bytes memory data) = flashBait.shouldRespond(trapData);

        // 3. Assert that the trap was triggered
        assertTrue(result, "FlashBait should detect the flash loan");

        // 4. Assert that the returned data is correct
        (address decodedTo, uint256 decodedAmount0, uint256 decodedAmount1) = abi.decode(data, (address, uint256, uint256));
        assertEq(decodedTo, to);
        assertEq(decodedAmount0, amount0Out);
        assertEq(decodedAmount1, amount1Out);
    }

    function testShouldRespond_NoFlashLoan() public view {
        // 1. Mock a transaction trace for a simple transfer, which should not trigger the trap.
        bytes memory flashData = abi.encodeWithSignature("transfer(address,uint256)", address(0x2), 100e18);
        bytes[] memory trapData = new bytes[](1);
        trapData[0] = flashData;

        // 2. Call the shouldRespond function
        (bool result, ) = flashBait.shouldRespond(trapData);

        // 3. Assert that the trap was not triggered
        assertFalse(result, "FlashBait should not detect a simple transfer");
    }
}
