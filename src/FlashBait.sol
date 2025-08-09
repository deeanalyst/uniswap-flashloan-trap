// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

/// @title FlashBait
/// @notice This trap detects Uniswap V2 and V3 flash loans by looking for the `swap` and `flash` function selectors in the transaction trace.
/// @dev Whitelisting of operators for this trap is handled in the `drosera.toml` configuration.
contract FlashBait is ITrap {
    /// @notice The function selector for the Uniswap V3 `flash` function.
    /// `flash(address,uint256,uint256,bytes)`
    bytes4 internal constant FLASH_SELECTOR_V3 = 0xb6313847;

    /// @notice The function selector for the Uniswap V2 `swap` function.
    /// `swap(uint256,uint256,address,bytes)`
    bytes4 internal constant SWAP_SELECTOR_V2 = 0x022c0d9f;

    function collect() external view returns (bytes memory) {
        return "Collecting data for flash loan trap";
    }

    /// @notice Checks the transaction trace for the `flash` or `swap` function selectors.
    /// @param data The calldata passed to the trap, containing the transaction trace.
    /// @return Returns true and the encoded flash loan data if a flash loan selector is found, otherwise false.
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        if (data.length == 0) {
            return (false, "");
        }
        // The trace contains the transaction's input data. We search for the flash selector.
        // A simple search is sufficient for this PoC. A more robust implementation
        // would parse the trace more deeply to ensure the selector is part of a call to a valid Uniswap pool.
        bytes memory trace = data[0];
        if (trace.length < 4) {
            return (false, "");
        }
        for (uint256 i = 0; i <= trace.length - 4; i++) {
            bytes4 selector;
            assembly {
                selector := mload(add(trace, add(i, 0x20)))
            }
            if (selector == FLASH_SELECTOR_V3) {
                // we found the selector, now we need to extract the data
                // we skip the 4 bytes of the selector
                address recipient;
                uint256 amount0;
                uint256 amount1;
                assembly {
                    let ptr := add(trace, add(0x20, add(i, 4)))
                    recipient := mload(ptr)
                    amount0 := mload(add(ptr, 0x20))
                    amount1 := mload(add(ptr, 0x40))
                }
                return (true, abi.encode(recipient, amount0, amount1));
            } else if (selector == SWAP_SELECTOR_V2) {
                // we found the selector, now we need to extract the data
                // we skip the 4 bytes of the selector
                uint256 amount0Out;
                uint256 amount1Out;
                address to;
                assembly {
                    let ptr := add(trace, add(0x20, add(i, 4)))
                    amount0Out := mload(ptr)
                    amount1Out := mload(add(ptr, 0x20))
                    to := mload(add(ptr, 0x40))
                }
                return (true, abi.encode(to, amount0Out, amount1Out));
            }
        }

        return (false, "");
    }
}
