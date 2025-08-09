# 🛡️ Drosera Uniswap Flash Loan Trap 🎣

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains a Drosera-powered security trap designed to proactively detect and respond to both Uniswap V2 and V3 flash loan attacks in real-time. I built this to demonstrate a practical, real-world example of how decentralized security monitors can be used to defend DeFi protocols.

---

## 🤔 What is a Flash Loan Attack?

A flash loan allows a user to borrow a massive amount of cryptocurrency with no upfront collateral, but it must be repaid within the same blockchain transaction. While a powerful DeFi tool, this feature can be weaponized.

In a **flash loan attack**, a malicious actor borrows funds, uses them to manipulate a protocol's internal logic (e.g., by creating an imbalance in a price oracle), and then repays the loan, all in one atomic transaction. These attacks are incredibly fast and can be financially devastating to the target protocol. This project is a defense mechanism against such threats.

---

## ✨ What Does This Trap Do?

This Drosera trap provides real-time, on-chain threat monitoring. It is designed to:

1.  **Watch the Mempool:** Continuously inspect in-flight transactions before they are included in a block.
2.  **Identify Flash Loan Signatures:** Specifically look for the function calls that initiate flash loans on Uniswap V2 (`swap`) and V3 (`flash`).
3.  **Trigger an Automated Response:** If a flash loan signature is detected, the trap immediately calls a separate `BaitResponse` contract to execute a pre-defined security action.

All of this happens decentrally, without relying on any off-chain infrastructure.

---

## 💡 Why Is It Innovative?

This approach to security offers several key advantages:

*   **Proactive, Not Reactive:** It detects threats *before* they are executed on-chain, unlike post-mortem analysis tools.
*   **Fully Decentralized:** The detection and response mechanism is run by a network of independent Drosera operators, removing single points of failure.
*   **Transparent & Verifiable:** Since the trap and response are on-chain, anyone can audit the logic and verify the actions taken.
*   **Cost-Efficient:** It avoids the need to build, host, and maintain centralized monitoring infrastructure.

---

## 🛠️ Technologies Used

| Layer             | Tool / Protocol                               |
| ----------------- | --------------------------------------------- |
| **Security Engine** | [Drosera](https://app.drosera.io)        |
| **Blockchain**    | Ethereum Hoodi Testnet |
| **Smart Contracts**| Solidity (^0.8.30)                            |
| **Dev Framework** | [Foundry](https://getfoundry.sh/)             |

---

## 📝 The Response Mechanism

As defined in `drosera.toml`, when the trap is triggered, the Drosera network makes a direct function call to the `BaitResponse` contract.

**1. The Function Call (The Direct Response):**
The network calls the `execute` function, passing the encoded flash loan data as a `bytes` argument.

```solidity
function execute(bytes calldata data) external;
```

**2. The On-Chain Record (The Result):**
Inside the `execute` function, the contract decodes the data and emits a `FlashLoanCaught` event. This event serves as the permanent, on-chain record of the detected threat.

```solidity
event FlashLoanCaught(
    address indexed recipient,
    uint256 amount0,
    uint256 amount1
);
```

This two-step process provides a robust and verifiable response to detected threats.

---

## 📂 Project Structure

```
/
├── src/
│   ├── FlashBait.sol       # The trap logic that detects the attack.
│   └── BaitResponse.sol    # The response contract that gets triggered.
├── test/
│   ├── FlashBait.t.sol     # Tests for the trap contract.
│   └── BaitResponse.t.sol  # Tests for the response contract.
├── scripts/
│   └── DeployBaitResponse.s.sol # A Foundry script to deploy the response contract.
├── drosera.toml            # The main configuration file for the Drosera trap.
└── foundry.toml            # The main configuration file for the Foundry toolkit.
```

---

## 🚀 Setup & Deploy

To get this project running, follow these steps. You will need [Foundry](https://getfoundry.sh/) and [Bun](https://bun.sh/) installed.

**1. Clone and Install Dependencies:**
```bash
git clone https://github.com/deeanalyst/uniswap-flashloan-trap.git
cd uniswap-flashloan-trap
bun install
forge build
```

**2. Create Environment File:**
Create a `.env` file in the root directory and add your RPC URL and private key. This file is ignored by Git.
```
HOODI_RPC_URL="your_hoodi_testnet_rpc_url"
PRIVATE_KEY="your_wallet_private_key"
```

**3. Deploy the Response Contract:**
This command deploys the `BaitResponse.sol` contract, which will be triggered by the trap.
```bash
source .env && forge script scripts/DeployBaitResponse.s.sol:DeployBaitResponse --rpc-url $HOODI_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

**4. Configure and Deploy the Trap:**
Open `drosera.toml` and paste the deployed `BaitResponse` contract address into the `response_contract` field. Then, deploy the trap to the Drosera network.
```bash
# In drosera.toml:
# response_contract = "0xYourBaitResponseContractAddress"

source .env && drosera apply --private-key $PRIVATE_KEY
```

---

## ✅ Testing

The project includes a full test suite. To run the tests and verify the logic, use the following Foundry command:

```bash
forge test
```

---

## 💡 Future Improvements

This project provides a solid foundation, but there are many ways it could be extended:

*   **Deeper Inspection:** Instead of just matching function selectors, the trap could be enhanced to parse the transaction data more deeply, such as verifying that the call is being made to a legitimate Uniswap pool address.
*   **Broader DEX Support:** The logic could be expanded to detect flash loans from other major DEXs like Sushiswap, Aave, or Balancer.
*   **More Sophisticated Responses:** The `BaitResponse` contract could be built out with more advanced logic, such as a circuit-breaker that pauses critical protocol functions or a mechanism to notify a multi-sig wallet via an on-chain event.
*   **Gas Optimization:** Further analysis could be done to optimize the gas usage of the trap's detection logic, making it even more efficient for the Drosera operators to run.

---

## 🤝 Contributing

I hope this project serves as a useful example for other developers exploring decentralized security. Feedback and contributions are highly welcome. If you have ideas for improvements or find any issues, please feel free to open an issue or submit a pull request. I would be happy to see others fork this repository and build upon this work.

---
