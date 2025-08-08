# 🛡️ Drosera Uniswap Flash Loan Trap 🎣

This repository contains a Drosera-powered security trap designed to proactively detect and respond to both Uniswap V2 and V3 flash loan attacks in real-time. I built this to demonstrate a practical, real-world example of how decentralized security monitors can be used to defend DeFi protocols.

---

## 🤔 The Problem: Flash Loan Attacks

Flash loans, while a powerful DeFi primitive, can be weaponized. In an attack, a malicious actor borrows a massive amount of cryptocurrency with no upfront collateral, uses it to manipulate a protocol's internal logic, and repays the loan—all within a single, atomic transaction. These attacks are incredibly fast and can be financially devastating to the target protocol. This project is a defense mechanism against such threats.

---

## ✨ The Solution: A Drosera-Powered Trap

This project uses the [Drosera](https://drosera.io) protocol to create a decentralized security enforcement layer. It consists of two main smart contracts:

1.  **`FlashBait.sol` (The Trap 🎣):** This is the lookout. The trap's code is executed by Drosera's network of operators, who monitor the public transaction pool (mempool). It inspects in-flight transactions for the function signatures of Uniswap V3 `flash` calls or Uniswap V2 `swap` calls, both of which can be used to initiate flash loans.

2.  **`BaitResponse.sol` (The Response 🚨):** This is the response unit. If the `FlashBait` trap signals a threat, the Drosera network immediately calls this contract. The response logic can be customized to the needs of a protocol—from pausing functionality to alerting a security council. In this example, it simply logs the event.

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

## 💡 Feedback & Contributions

I hope this project serves as a useful example for other developers exploring decentralized security. Feedback is highly welcome. If you have ideas for improvements or find any issues, please feel free to open an issue or submit a pull request. I would be happy to see others fork this repository and build upon this work.

---

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.