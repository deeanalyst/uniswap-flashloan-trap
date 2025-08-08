# 🛡️ Drosera Uniswap Flash Loan Trap 🎣

Welcome to my **Drosera Uniswap Flash Loan Trap** project! This repository is a powerful, real-world example of how to build a decentralized security monitor using [Drosera](https://drosera.io) to proactively defend against both Uniswap V2 and V3 flash loan attacks.

Ever wondered how you could stop an attack *before* it drains a protocol's funds? This project demonstrates exactly that. I built a "trap" that listens to the blockchain for malicious transactions and triggers an immediate, automated response. Let's dive in! 🌊

---

## 🤔 What's the Problem? Flash Loan Attacks

Flash loans are a powerful DeFi tool, but they can also be used for evil. In a flash loan attack, a malicious actor borrows a massive amount of cryptocurrency (with no upfront collateral), uses it to manipulate the market or exploit a protocol's vulnerability, and repays the loan all within a *single transaction*. These attacks are incredibly fast and can be devastating.

**This project is a defense mechanism.** It's a security system designed to detect the signature of a Uniswap V2 or V3 flash loan attack as it's happening and take immediate, automated action to neutralize the threat.

---

## ✨ How It Works: The Drosera Magic

This project uses the Drosera protocol to create a decentralized security enforcement layer. It consists of two main smart contracts:

1.  **`FlashBait.sol` (The Trap 🎣):** This is my lookout. The trap's code is continuously executed by Drosera's network of operators, who are watching the blockchain's transaction pool (the "mempool"). The trap inspects in-flight transactions to see if they contain the function signature for a Uniswap V3 `flash` call or a Uniswap V2 `swap` call, both of which are used to initiate flash loans.

2.  **`BaitResponse.sol` (The Response 🚨):** This is my response unit. If the `FlashBait` trap signals a threat, the Drosera network immediately calls this contract. The response can be anything you define—pausing the protocol, alerting a multi-sig, or, in this simple example, just logging the event.

The flow is simple but powerful:

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

This all happens automatically and at machine speed, providing a crucial defense layer for any DeFi protocol.

---

## 📂 Project Structure

Here's a look at the key files and what they do:

```
/
├── src/
│   ├── FlashBait.sol       # The trap logic that detects the attack.
│   └── BaitResponse.sol    # The response contract that gets triggered.
├── test/
│   ├── FlashBait.t.sol     # Tests for my trap contract.
│   └── BaitResponse.t.sol  # Tests for my response contract.
├── scripts/
│   └── DeployBaitResponse.s.sol # A Foundry script to deploy the response contract.
├── drosera.toml            # The main configuration file for the Drosera trap.
├── foundry.toml            # The main configuration file for the Foundry toolkit.
└── .env                    # Your environment variables (RPC URL, Private Key).
```

---

## 🚀 Getting Started: Setup & Installation

Follow these steps to get the project running on your local machine.

### 1. Prerequisites

Make sure you have the following tools installed:

-   **Foundry:** The blazing-fast toolkit for Ethereum development.
    ```bash
    curl -L https://foundry.paradigm.xyz | bash && foundryup
    ```
-   **Bun:** A fast JavaScript runtime (used for dependency management).
    ```bash
    curl -fsSL https://bun.sh/install | bash
    ```
-   **Drosera CLI:** The command-line interface for interacting with the Drosera network.
    ```bash
    curl -L https://app.drosera.io/install | bash && droseraup
    ```

### 2. Install Dependencies

Clone the repository and install the necessary node modules.

```bash
git clone <repository_url>
cd drosera-uniswap-flashloan-trap
bun install
```

### 3. Configure Your Environment

This project uses an `.env` file to manage sensitive information like your RPC endpoint and private key.

First, create the file:
```bash
touch .env
```

Then, open `.env` and add the following, replacing the placeholder values with your own:

```
HOODI_RPC_URL="your_hoodi_testnet_rpc_url"
PRIVATE_KEY="your_wallet_private_key"
```

**Security Note:** The `.gitignore` file is already configured to ignore the `.env` file, so your secrets will not be accidentally committed to Git.

---

## ⚙️ Deployment & Configuration

Deploying the trap is a three-step process.

### Step 1: Deploy the Response Contract

First, I need to deploy my `BaitResponse.sol` contract to the Hoodi testnet. This gives me a contract address that the trap can call when it's triggered.

The following command uses Foundry to run the deployment script. It will use the RPC URL and Private Key you defined in your `.env` file.

```bash
source .env && forge script scripts/DeployBaitResponse.s.sol:DeployBaitResponse --rpc-url hoodi --private-key $PRIVATE_KEY --broadcast
```

After running this, Foundry will save the deployment details in the `broadcast/` directory. Look inside the JSON file there to find your new contract's address.

### Step 2: Configure the Trap

Now, open the `drosera.toml` file. This file tells the Drosera network everything it needs to know about the trap.

You need to update the `response_contract` field with the address of the `BaitResponse` contract you just deployed.

```toml
# drosera.toml

[traps.flashbait]
path = "out/FlashBait.sol/FlashBait.json"
# 👇 Paste your deployed contract address here!
response_contract = "0xYourBaitResponseContractAddress"
response_function = "execute(bytes)"
# ... other settings
```

### Step 3: Deploy the Trap to Drosera!

With everything configured, you can now register the trap with the Drosera network. This command sends the trap's configuration and code to the Drosera operators.

```bash
source .env && drosera apply --private-key $PRIVATE_KEY
```

If successful, the CLI will add an `address` field to your `drosera.toml` file.

**Congratulations! 🎉 Your decentralized security monitor is now live and watching the Hoodi testnet for flash loan attacks!**

---

## ✅ Testing Your Trap

You can run the local test suite to ensure all the contract logic is working as expected. The tests simulate both V2 and V3 flash loan attacks and a normal transaction to verify the trap behaves correctly in all scenarios.

```bash
forge test
```

You should see all tests passing, confirming that the trap can correctly identify a threat.

---

## A Note on Drosera Network Requirements

During development, I encountered a nuance with the Drosera network. The Solidity compiler suggests that the `collect` function in `FlashBait.sol` can be `pure` since it doesn't read from the state. However, the Drosera verifier specifically requires this function to be `view`. I have intentionally left it as `view` to ensure compatibility with the network. This is a great example of the specific requirements that can arise when building for specialized decentralized networks!
