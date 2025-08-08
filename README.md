# 🛡️ Drosera Uniswap Flash Loan Trap 🎣

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

This repository contains a Drosera-powered security trap designed to proactively detect and respond to both Uniswap V2 and V3 flash loan attacks in real-time. I built this to demonstrate a practical, real-world example of how decentralized security monitors can be used to defend DeFi protocols.

---

## 🤔 The Problem: Flash Loan Attacks

Flash loans, while a powerful DeFi primitive, can be weaponized. In an attack, a malicious actor borrows a massive amount of cryptocurrency with no upfront collateral, uses it to manipulate a protocol's internal logic, and repays the loan—all within a single, atomic transaction. These attacks are incredibly fast and can be financially devastating to the target protocol. This project is a defense mechanism against such threats.

---

## ✨ The Solution: A Drosera-Powered Trap

This project uses the [Drosera](https://drosera.io) protocol to create a decentralized security enforcement layer. It works by watching the public transaction pool (mempool) for transactions that initiate flash loans and triggering an immediate, on-chain response.

### Key Components

1.  **`FlashBait.sol` (The Trap 🎣):** This is the core detection logic. Deployed as a Drosera trap, its code is executed by a decentralized network of operators who inspect in-flight transactions. It specifically looks for the function selectors corresponding to a Uniswap V3 `flash` call or a Uniswap V2 `swap` call, which are the entry points for flash loans on their respective platforms.

2.  **`BaitResponse.sol` (The Response 🚨):** This is the action-taker. If the `FlashBait` trap identifies a potential threat, the Drosera network immediately calls this contract. The response logic can be customized to the needs of a protocol—from pausing functionality to alerting a security council or executing a counter-measure. In this example, it simply logs the event for on-chain proof.

### Workflow

The security flow is designed to be simple, fast, and effective:

```
+---------------------------------+
|   Malicious Transaction Appears |
|         (in Mempool)            |
+---------------------------------+
                 |
                 v
+---------------------------------+
|   Drosera Operators Detect It   |
+---------------------------------+
                 |
                 v
+---------------------------------+
|  `FlashBait` Trap Confirms      |
|           Threat                |
+---------------------------------+
                 |
                 v
+---------------------------------+
| `BaitResponse` Contract         |
|         is Triggered            |
+---------------------------------+
```

---

### Tech Stack

*   **Solidity:** For the smart contracts.
*   **Foundry:** For the development environment, testing, and deployment scripts.
*   **Drosera:** For the decentralized security monitoring and response network.

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

## ⚙️ Configuration & Usage

To use this trap, you need to:

1.  **Deploy the `BaitResponse.sol` contract.** This will be the action-taker when a threat is detected.
2.  **Update `drosera.toml`:** Set the `response_contract` field to the address of your deployed `BaitResponse` contract.
3.  **Deploy the trap:** Run `drosera apply` to register the trap with the Drosera network, which will begin monitoring for threats.

---

## ✅ Testing

The project includes a full test suite. To run the tests and verify the logic, use the following Foundry command:

```bash
forge test
```

The tests simulate both V2 and V3 flash loan attacks, as well as normal transactions, to ensure the trap logic is sound.

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

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
