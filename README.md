# Hardened ERC20 Token

A production-grade ERC20 token implementation with controlled minting, burning capabilities, and a maximum supply cap.

## 🔗 Deployed Contract

**Network:** Sepolia Testnet  
**Contract Address:** `0x2eee79fE7E9BA9B851A6860192eba4d13A643417`  
**Verified on Etherscan:** [View Contract](https://sepolia.etherscan.io/address/0x2eee79fe7e9ba9b851a6860192eba4d13a643417)

## 📋 Token Overview

**RealityCheckToken** is a hardened ERC20 implementation designed with security and simplicity in mind. It uses OpenZeppelin's battle-tested contracts as a foundation and adds controlled minting with an immutable supply cap.

### Key Characteristics

- **Name:** RealityCheckToken
- **Symbol:** RealityCheckToken  
- **Decimals:** 18 (standard)
- **Max Supply:** 1,000,000 tokens (1,000,000 * 10^18 wei)
- **Access Control:** Single owner (Ownable pattern)
- **Special Features:** Mintable (owner only), Burnable (anyone)

### Core Features

- ✅ **ERC20 Standard** - Full compliance with ERC20 token standard
- ✅ **Controlled Minting** - Only contract owner can create new tokens
- ✅ **Supply Cap** - Hard limit on total supply prevents inflation
- ✅ **Burn Functionality** - Token holders can destroy their tokens
- ✅ **Enhanced Events** - Additional events for better tracking
- ✅ **Modern Solidity** - Built with Solidity 0.8.20 safety features

## 🏗️ Architecture Decisions

### Why OpenZeppelin?

I chose OpenZeppelin contracts as the foundation because:

1. **Battle-Tested** - Used by thousands of projects, collectively securing billions of dollars
2. **Audited** - Professionally audited by multiple reputable security firms
3. **Community Standard** - Industry-standard implementation that developers expect
4. **Well-Maintained** - Active development with regular security updates
5. **Gas-Optimized** - Efficient implementations refined over years
6. **Comprehensive** - Modular design allows picking exactly what's needed

Using OpenZeppelin reduces risk by leveraging code that has been thoroughly tested in production environments.

### Why Ownable over AccessControl?

This was a critical design decision. I chose **Ownable** instead of **AccessControl** for these reasons:

#### Ownable Advantages for This Use Case:

**1. Simplicity**
- Single owner model is straightforward to understand and audit
- Fewer moving parts means fewer potential bugs
- Clear mental model: one address controls minting

**2. Gas Efficiency**
- Smaller deployment size (~50KB less bytecode)
- Lower gas costs for ownership checks
- Simpler storage layout (one address vs mapping)

**3. Sufficient for Requirements**
- This token only needs ONE privileged action: minting
- No need for multiple roles or hierarchies
- Owner can always transfer ownership if structure changes

**4. Security Through Simplicity**
- Smaller attack surface with fewer functions
- Less complexity = easier to reason about security
- No role management logic that could be misconfigured

**5. Clear Responsibility**
- Single point of accountability
- No confusion about who can do what
- Easier to coordinate in small teams

#### When AccessControl Would Be Better:

AccessControl would be the right choice if we needed:
- **Multiple distinct roles** (e.g., MINTER, PAUSER, ADMIN, UPGRADER)
- **Role delegation** without full ownership transfer
- **Hierarchical permissions** with different privilege levels
- **DAO governance** with multiple signers and roles
- **Complex permission logic** that changes over time

For a token with a single privileged operation (minting), Ownable is the superior choice.

### Maximum Supply Design

The `MAX_SUPPLY` implementation uses several key techniques:
```solidity
uint256 public immutable MAX_SUPPLY;

constructor(..., uint256 maxSupply_) {
    require(maxSupply_ > 0, "Max supply must be > 0");
    MAX_SUPPLY = maxSupply_;
}

function mint(address to, uint256 amount) external onlyOwner {
    require(totalSupply() + amount <= MAX_SUPPLY, "Cap exceeded");
    // ...
}
```

**Design Benefits:**

1. **Immutable** - Uses `immutable` keyword, set once in constructor
2. **Gas Efficient** - Stored in bytecode, not storage (cheaper reads)
3. **Transparent** - Publicly readable, no hidden inflation
4. **Enforced** - Every mint checks against cap before execution
5. **Predictable** - Token holders have certainty about maximum dilution

This prevents the "infinite money printer" problem seen in some tokens while maintaining flexibility during deployment.

## 🔒 Security Considerations

### Implemented Security Features

**1. Overflow Protection**
- Solidity 0.8.x has built-in overflow/underflow checks
- No need for SafeMath library
- Automatic revert on arithmetic errors

**2. Input Validation**
- Zero address checks prevent burning to void
- Maximum supply validation in constructor
- Amount checks before minting

**3. Access Control**
- `onlyOwner` modifier on mint function
- OpenZeppelin's tested access control patterns
- No privileged functions exposed

**4. Reentrancy Safety**
- Uses OpenZeppelin's patterns
- No external calls before state changes
- State updates follow checks-effects-interactions

**5. Event Emissions**
```solidity
event TokensMinted(address indexed to, uint256 amount);
event MaxSupplyReached(uint256 maxSupply);
```
- Enhanced transparency for off-chain monitoring
- Helps detect unusual activity
- Provides audit trail

### Known Limitations & Trade-offs

**1. Centralization Risk**
- **Issue:** Single owner controls all minting
- **Impact:** Owner could mint to themselves or manipulate supply
- **Mitigation Strategy:**
  - Transfer ownership to multisig wallet (e.g., Gnosis Safe)
  - Use timelock contract for delayed actions
  - Eventually renounce ownership to make supply fixed
  
**2. No Emergency Pause**
- **Issue:** Cannot stop transfers if exploit discovered
- **Trade-off Decision:** Simpler code, lower gas, no centralized control
- **Consideration:** Could add OpenZeppelin's `Pausable` if needed
- **Why Omitted:** Prioritized decentralization over emergency controls

**3. No Blacklist Capability**
- **Issue:** Cannot block specific addresses from receiving/sending
- **Design Choice:** Prioritizes censorship resistance
- **Consideration:** Some regulated tokens need this feature
- **Why Omitted:** Preserves permissionless nature of crypto

**4. Simple Ownership Transfer**
- **Issue:** Owner could accidentally transfer to wrong address
- **Current:** Single-step `transferOwnership()`
- **Better Alternative:** OpenZeppelin's `Ownable2Step` with two-step process
- **Why Not Used:** Keeping initial version simple, can upgrade later

### Security Best Practices Applied

- ✅ No assembly or delegatecall (reduces complexity)
- ✅ Explicit function visibility on all functions
- ✅ Custom events for important state changes
- ✅ Follows checks-effects-interactions pattern
- ✅ Uses established libraries over custom implementations
- ✅ Immutable variables for constants
- ✅ Descriptive error messages for debugging

### Pre-Mainnet Checklist

Before deploying to mainnet with real value:

- [ ] **Professional Security Audit** by firm like Trail of Bits, OpenZeppelin, or Consensys
- [ ] **Transfer Ownership** to multisig wallet (minimum 3-of-5 signers)
- [ ] **Implement Timelock** for ownership changes (e.g., 48-hour delay)
- [ ] **Set Up Monitoring** for minting events and large transfers
- [ ] **Emergency Procedures** documented and tested
- [ ] **Bug Bounty Program** to incentivize white-hat disclosure
- [ ] **Economic Attack Analysis** to model game theory scenarios
- [ ] **Formal Verification** if protecting high value

## 🚀 How to Deploy and Test

### Prerequisites
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Verify installation
forge --version
cast --version
```

### Setup
```bash
# Clone repository
git clone https://github.com/ustisa/hardened-erc20.git
cd hardened-erc20

# Install dependencies
forge install

# Compile contracts
forge build
```

### Environment Configuration

Create `.env` file:
```env
PRIVATE_KEY=your_private_key_without_0x
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/your_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

⚠️ **Never commit `.env` to version control!**

### Running Tests
```bash
# Run all tests
forge test

# Run with detailed output
forge test -vvv

# Run specific test
forge test --match-test testMint

# Generate gas report
forge test --gas-report

# Check coverage
forge coverage
```

### Deploying to Sepolia
```bash
# Load environment variables
source .env

# Deploy with automatic verification
forge script script/DeployRealityCheckToken.s.sol:DeployRealityCheckToken \
  --rpc-url $SEPOLIA_RPC_URL \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY
```

### Customizing Deployment

Edit `script/DeployRealityCheckToken.s.sol` to change parameters:
```solidity
new RealityCheckToken(
    "YourTokenName",      // Token name
    "SYMBOL",             // Token symbol
    1_000_000 * 10 ** 18  // Max supply in wei
);
```

### Interacting with Deployed Contract
```bash
# Check total supply
cast call 0x2eee79fE7E9BA9B851A6860192eba4d13A643417 \
  "totalSupply()(uint256)" \
  --rpc-url $SEPOLIA_RPC_URL

# Mint tokens (owner only)
cast send 0x2eee79fE7E9BA9B851A6860192eba4d13A643417 \
  "mint(address,uint256)" \
  RECIPIENT_ADDRESS \
  1000000000000000000000 \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY

# Burn tokens
cast send 0x2eee79fE7E9BA9B851A6860192eba4d13A643417 \
  "burn(uint256)" \
  500000000000000000000 \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY
```

## 🛠️ Technology Stack

- **Solidity** ^0.8.20 - Smart contract language
- **Foundry** - Development framework, testing, deployment
- **OpenZeppelin Contracts** v5.x - Audited contract library
- **Sepolia** - Ethereum test network
- **Etherscan** - Contract verification and exploration

## 📄 License

MIT License - See contract SPDX identifier

## ⚠️ Disclaimer

This contract is deployed on Sepolia testnet for educational purposes. It has **not** undergone a professional security audit. 

**DO NOT use in production or with real funds without:**
- Comprehensive security audit by reputable firm
- Extensive testing including fuzz testing and invariant testing  
- Economic modeling and game theory analysis
- Proper key management and operational security

The authors are not responsible for any losses incurred through use of this code.

## 🙏 Acknowledgments

- OpenZeppelin for their excellent and secure contract library
- Foundry team for powerful development tools
- Ethereum community for continuous innovation and learning resources

---

**Built with care for the Week 1 Solidity & ERC20 Reality Check assignment**