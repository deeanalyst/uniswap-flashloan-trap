// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BaitResponse
/// @notice This contract is the response to the FlashBait trap. It decodes the flash loan data and emits an event.
contract BaitResponse {
    /// @notice Emitted when a flash loan is detected.
    /// @param recipient The address that received the flash loan.
    /// @param amount0 The amount of token0 borrowed.
    /// @param amount1 The amount of token1 borrowed.
    event FlashLoanCaught(address indexed recipient, uint256 amount0, uint256 amount1);

    /// @notice Executes the response when the trap is triggered.
    /// @param data The calldata passed to the response, containing the original transaction's calldata.
    function executeBytes(bytes calldata data) external {
        (address recipient, uint256 amount0, uint256 amount1) =
            abi.decode(data, (address, uint256, uint256));

        emit FlashLoanCaught(recipient, amount0, amount1);
    }
}