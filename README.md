# ERC20 Crypto Currency

We are going to develop an ERC20 Crypto Currency. You will:

1. learn the fundamentals of ERC20
2. manually create your own token
3. explore the OpenZeppelin
4. deploy your new ERC20 token
5. test your token using AI

## ERC20 Basics

In this section we're going to be diving into `ERC20s`, and how to develop, deploy and test them.

### ERCs and EIPs

The Web3 and blockchain ecosystem is fundamentally democratic and open source. As such major blockchains will often implement methods by which the community can submit suggestions for changes in methodologies and standards. These are typically known is `Improvement Proposals`, and in the Ethereum ecosystem they are `Ethereum Improvement proposals` (`EIPs`).

If `EIPs` get enough traction to warrant genuine consideration they will often generate a `Request for Comments`, in Ethereum these are known as `Ethereum Request for Comments` (`ERCs`).

> ❗ **NOTE** > `EIPs` and `ERCs` are numbered chronologically! `ERC20` is the 20th request for comments that was created.

New `Improvement Proposals` and `Requests for Comments` are tracked on websites such as **[eips.ethereum.org](https://eips.ethereum.org/)**, where you can watch these proposals go through the process real time and be adopted or rejected by the community.

<img src='./images/erc20-basics1.png' alt="erc20-basics1" />

### EIP status terms

* **Idea** - An idea that is pre-draft. This is not tracked within the EIP Repository.
* **Draft** - The first formally tracked stage of an EIP in development. An EIP is merged by an EIP Editor into the EIP repository when properly formatted.
* **Review** - An EIP Author marks an EIP as ready for and requesting Peer Review.
* **Last Call** - This is the final review window for an EIP before moving to FINAL. An EIP editor will assign Last Call status and set a review end date (`last-call-deadline`), typically 14 days later. If this period results in necessary normative changes it will revert the EIP to Review.
* **Final** - This EIP represents the final standard. A Final EIP exists in a state of finality and should only be updated to correct errata and add non-normative clarifications.
* **Stagnant** - Any EIP in Draft or Review if inactive for a period of 6 months or greater is moved to Stagnant. An EIP may be resurrected from this state by Authors or EIP Editors through moving it back to Draft.
* **Withdrawn** - The EIP Author(s) have withdrawn the proposed EIP. This state has finality and can no longer be resurrected using this EIP number. If the idea is pursued at a later date it is considered a new proposal.
* **Living** - A special status for EIPs that are designed to be continually updated and not reach a state of finality. This includes most notably EIP-1.

### ERC20

One of the most recognized `Ethereum Requests for Comments` is the **[ERC20 Token Standard](https://eips.ethereum.org/EIPS/eip-20)**. This is a proposal in which the methodology for creating and managing these tokens on the Ethereum blockchain was tabled.

These tokens essentially exists as records of value within smart contracts on chain and this smart contract tracking of balances is a very powerful thing in Web3.

_**Why make an ERC20?**_

There are a few common reasons that someone may choose to launch an `ERC20 token`, but there's very little limit to the possibilities of their application in a digital space. A few common use cases include:

* Governance Tokens
* Securing an underlying network
* Synthetic Assets
* Stable Coins

...and more.

_**How do I build an ERC20?**_

All anyone has to do to develop and `ERC20` is to deploy a smart contract which follows the **[token standard](https://eips.ethereum.org/EIPS/eip-20)**. This ultimate boils down to assuring our contract includes a number of necessary functions: `transfer`, `approve`, `name`, `symbol`, `balanceOf` etc.

## Creating an ERC20

set up the foundry project environment using `forge init` command.

You can begin by creating a new token our `src` directory named `ManualToken.sol`. We can start this contract the same way we've been practicing this whole time.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ManualToken {}
```

All we need to do to make our token compatible is follow the **[ERC20 Token Standard](https://eips.ethereum.org/EIPS/eip-20)**. Essentially this means we need to include the required functions/methods for our deployment to follow this standard. Let's add thing functionality then!

Let's start with name, decimals and totalSupply

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ManualToken {

    function name() public pure returns(string memory) {
        return "Manual Token";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether; // 100000000000000000000
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }
}
```

> ❗ **NOTE**
> Despite being an optional method, we're including `decimals` here as a point of clarification since we're declaring our total supply as 100 ether. 100 ether = 100 + 18 decimals places.

The next functions required by the ERC20 standard are `balanceOf` and `transfer`.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ManualToken {

    function name() public pure returns(string memory) {
        return "Manual Token";
    }

    function totalSupply() public pure returns (uint256){
        return 100 ether; // 100000000000000000000
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public pure returns (uint256){
        return // ???
    }
}
```

What is this function meant to return exactly? We're going to need a mapping to track the balances of each address...

```solidity
mapping(address => uint256) private s_balances;
```

So now our `balanceOf` function can return this mapped value based on the address parameter being passed.

```solidity
function balanceOf(address _owner) public pure returns (uint256) {
   return s_balances[_owner];
}
```

An interesting thing that comes to light from this function is - someone's balance of a token is really just some mapping on a smart contract that says `this number is associated with this address` That's it. All swaps, transfers and trades are represented as an updating to the balance of this mapping.

> ❗ **PROTIP**
> Our name function could also be represented by a public declaration such as `string public name = "ManualToken";`. This is because Solidity creates public getter functions when compiled for any publicly accessible storage variables!

Our next required function is transfer:

```solidity
function transfer(address _to, uint256 _amount) public {
    uint256 previousBalance = balanceOf(msg.sender) + balanceOf(_to);
    s_balances[msg.sender] -= _amount;
    s_balances[_to] = _amount;

    require(balanceOf(msg.sender) + balanceOf(_to) == previousBalance);
}
```

So, a basic transfer function could look something like the above, a simple adjustment of the balances mapped to both the sender and receiver addresses in our contract.

## ERC20 OpenZeppelin

Let's using the OpenZeppelin Library to achieve pre-deployed, audited, and ready-to-go contracts to build our ERC20 token.

> ❗ **NOTE**
> OpenZeppelin is renowned for its Smart Contract framework, offering a vast repository of audited contracts readily integrable into your codebase.

Access [OpenZeppelin's documentation](https://docs.openzeppelin.com/contracts/5.x/) via their official website. By navigating to [Products -> Contracts Library](https://www.openzeppelin.com/contracts), you can discover a vast array of ready-to-use contracts.

Additionally, OpenZeppelin offers a contract wizard, streamlining the contract creation process — perfect for tokens, governances, or custom contracts.

<img src="./images/erc20-open-zeppelin1.png" alt="OpenZeppelin Contract Wizard" />

Let's leverage OpenZeppelin to create a new ERC20 Token. Create a new file within `src` named `MyToken.sol`. Once that's done, let's install the OpenZeppelin library into our contract.

```bash
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

Once installed you'll see the ERC20 contract from OpenZeppelin within `lib/openzeppelin-contracts/token/ERC20/ERC20.sol`. Let's add a remapping in our foundry.toml to make importing a little easier on us.Within foundry.toml add the line:

```toml
remappings = ["@openzeppelin=lib/openzeppelin-contracts"]
```

We can now import and inherit this contract into `MyToken.sol`!

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    //constructor goes here
}
```

By importing the OpenZeppelin implementation of ERC20 this way, we inherit all the functionality of the ERC20 standard with much less work and a level of confidence that the code has been testing and verified.

> ❗ **PROTIP**
> If you're looking for an alternative library full of trusted contracts, I recommend looking at the **[Solmate Repo](https://github.com/transmissions11/solmate)** by Transmissions11.

Now, we should recall that when inheriting from a contract with a constructor, our contract must fulfill the requirements of that constructor. We'll need to define details like a name and symbol for MyToken.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("MyToken", "OT") {
        _mint(msg.sender, initialSupply);
    }
}
```

For the purposes of simple examples like this, I like to mint the initialSupply to the deployer/msg.sender, which I've demonstrated above.

As always we can perform a sanity check to assure things are working as expected by running `forge build`.

### ERC20 Deploy Script

With our simple token contract written, we'll of course want to test and deploy it. Let's get started with writing a deploy script.

In your workspace's `script` folder, create a file named `DeployMyToken.s.sol`.

We expect MyToken to behave the same, regardless of the chain it's deployed on, so we don't really need a `HelperConfig` for this example. We'll skip that step and move write into writing the deploy script.

To begin, we can import Script and MyToken as well as add the skeleton of our run function:

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeployMyToken is Script {
    function run() external {}
}
```

We're going to keep this really basic, we just want to deploy MyToken. We know that MyToken requires an initial supply as a constructor parameter, so let's declare that and then deploy our contract.

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeployMyToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (MyToken) {
        vm.startBroadcast();
        MyToken ot = new MyToken(INITIAL_SUPPLY);
        vm.stopBroadcast();

        return ot;
    }
}

```

run `anvil` in a new terminal window and then and then run:
```bash
@forge script script/DeployMyToken.s.sol:DeployMyToken --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast
```

## Test ERC20 using AI

We're going to write a couple tests together, then see if an AI can help us with some others. Go ahead and create a new file within our `test` folder named `MyTokenTest.t.sol`.

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    function setUp() public {}
}
```

With this boiler plate set up in `MyTokenTest.t.sol` we can begin by declaring `MyToken` and `Deployer` variables and deploying these. We'll also need to create some accounts/addresses for our tests.

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public myToken;
    DeployMyToken public deployer;

    address mra = makeAddr("mra");
    address mahla = makeAddr("mahla");

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();
    }
}
```

The last thing we need in our `setUp` function is to assure one of our accounts is given some `MyToken` to play with. We wrote `MyToken` to mint it's `INITIAL_SUPPLY` to the `msg.sender`. Let's have our `msg.sender` contract transfer `100 ether` worth of `MyToken` to mra.

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public myToken;
    DeployMyToken public deployer;

    address mra = makeAddr("mra");
    address mahla = makeAddr("mahla");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();

        vm.prank(msg.sender);
        myToken.transfer(mra, STARTING_BALANCE);
    }
}
```

Bam! With this we're ready to start writing our first test. We'll start with a simple one, let's assure that the `STARTING_BALANCE` was in fact sent to mra.

```solidity
function testmraBalance() public view {
    assertEq(STARTING_BALANCE, myToken.balanceOf(mra));
}
```

```bash
forge test --mt testmraBalance
```

<img src="./images/erc20-ai-tests-and-recap1.png" alt="erc20-ai-tests-and-recap1">

### Approvals and transferFrom

Next, let's test some approvals. The ERC20 standard contains an important function, `transferFrom`. It is often the case that a smart contract protocol may need to transfer tokens _on behalf_ of a user the way this access is controlled is through the `transferFrom` function.

<img src="./images/erc20-ai-tests-and-recap2.png" alt="erc20-ai-tests-and-recap2">

In summary, an address needs to be approved by another in order to transfer tokens on their behalf, otherwise the transaction should revert with an error.

Approvals, naturally, are handled through the `approve` and allowance functionality within the ERC20 standard.

<img src="./images/erc20-ai-tests-and-recap3.png" alt="erc20-ai-tests-and-recap3">

Through these methods a user is able to approve another address to spend, or otherwise interact with, a limited (or often unlimited) number of tokens.

The security risks associated with this are pretty clear, which is why we've seen services like Etherscan's Token Approval Checker pop up. These allow you to see at a glance which addresses possess approvals for tokens in your wallet.

<img src="./images/erc20-ai-tests-and-recap4.png" alt="erc20-ai-tests-and-recap4">

While it costs a little gas, it's good practice to regularly assess your approvals and revoke them when no longer applicable or appropriate.

With all this context in mind, let's look at what a test for MyToken allowances looks like.

```solidity
function testAllowancesWork() public {
    uint256 initialAllowance = 1000;

    // mra approves Mahla to spend 1000 tokens.
    vm.prank(mra);
    myToken.approve(mahla, initialAllowance);

    uint256 transferAmount = 500;

    vm.prank(mahla);
    myToken.transferFrom(mra, mahla, transferAmount)
}
```

Here, we're declaring an initial balance and pranking mra to call approve on `MyToken`. This is allowing `Mahla` to transfer up to `1000 MyTokens`.

We then declare a transfer amount, and prank `Mahla` as we call `transferFrom`, transferring tokens from `mra`'s address to `Mahla`'s.

> ❗ **NOTE**
> The `transfer` function won't work here as the `from` address defaults to msg.sender!


```solidity
assertEq(outToken.balanceOf(mahla), transferAmount);
assertEq(myToken.balanceOf(mra), STARTING_BALANCE - transferAmount);
```

```bash
forge test --mt testAllowancesWork
```

<img src="./images/erc20-ai-tests-and-recap5.png" alt="erc20-ai-tests-and-recap5">

run `forge coverage`


<img src="./images/erc20-ai-tests-and-recap6.png" alt="erc20-ai-tests-and-recap6">

AI can be a little hit and miss when it comes to accuracy and reliability, but one thing they're pretty good at are tests. I've prepared a prompt you can use in the GitHub repo (and below) as an example of good formatting of a question for AI models. AI models are essentially sophisticated prediction engines, the higher quality your prompt, the higher quality a response.

OpenAI has a very capable free tier for ChatGPT available **[here](https://chatgpt.com)**. Navigate to the platform and create an account if needed.

### AI Prompt

````text
Here is my solidity ERC20 token.

```

// contracts/MyToken.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
constructor(uint256 initialSupply) ERC20("MyToken", "OT") {
\_mint(msg.sender, initialSupply);
}
}

```

And here our my first couple of tests written in solidity.

```

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
function mint(address, uint256) external;
}

contract MyTokenTest is StdCheats, Test {
MyToken public myToken;
DeployMyToken public deployer;

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();
    }

    function testInitialSupply() public {
        assertEq(myToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(myToken)).mint(address(this), 1);
    }

}

```

Can you write the rest of the tests? Please include tests for:

- Allowances
- transfers
- anything else that might be important
````

> ❗ **NOTE**
> Your specific response will differ from mine, I encourage you to try using an AI tool like ChatGPT to generate a few tests of your own. I've included my AI response below, generated by GPT4o May 31, 2024.

### Example AI Response

````text
Sure, here are the rest of the tests for your ERC20 token, including tests for allowances, transfers, and a few other important functionalities.

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract MyTokenTest is StdCheats, Test {
    MyToken public myToken;
    DeployMyToken public deployer;
    address public user1 = address(0x123);
    address public user2 = address(0x456);

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();
        vm.deal(user1, 1 ether); // Giving some initial balance to user1 for transactions
        vm.deal(user2, 1 ether); // Giving some initial balance to user2 for transactions
    }

    function testInitialSupply() public {
        assertEq(myToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(myToken)).mint(address(this), 1);
    }

    function testAllowance() public {
        uint256 amount = 1000 * 10 ** 18; // Example amount
        vm.prank(msg.sender);
        myToken.approve(user1, amount);

        assertEq(myToken.allowance(msg.sender, user1), amount);
    }

    function testTransfer() public {
        uint256 amount = 1000 * 10 ** 18; // Example amount
        vm.prank(msg.sender);
        myToken.transfer(user1, amount);

        assertEq(myToken.balanceOf(user1), amount);
        assertEq(myToken.balanceOf(msg.sender), deployer.INITIAL_SUPPLY() - amount);
    }

    function testTransferFrom() public {
        uint256 amount = 500 * 10 ** 18; // Example amount
        vm.prank(msg.sender);
        myToken.approve(user1, amount);

        vm.prank(user1);
        myToken.transferFrom(msg.sender, user2, amount);

        assertEq(myToken.balanceOf(user2), amount);
        assertEq(myToken.allowance(msg.sender, user1), 0);
    }

    function testFailTransferExceedsBalance() public {
        uint256 amount = deployer.INITIAL_SUPPLY() + 1;
        vm.prank(msg.sender);
        myToken.transfer(user1, amount); // This should fail
    }

    function testFailApproveExceedsBalance() public {
        uint256 amount = deployer.INITIAL_SUPPLY() + 1;
        vm.prank(msg.sender);
        myToken.approve(user1, amount); // This should fail
    }

    function testTransferEvent() public {
        uint256 amount = 1000 * 10 ** 18; // Example amount
        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit Transfer(msg.sender, user1, amount);
        myToken.transfer(user1, amount);
    }

    function testApprovalEvent() public {
        uint256 amount = 1000 * 10 ** 18; // Example amount
        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit Approval(msg.sender, user1, amount);
        myToken.approve(user1, amount);
    }
}
```

### Explanation

- **testAllowance**: Tests the `approve` function by setting an allowance and checking if it is recorded correctly.
- **testTransfer**: Tests the `transfer` function by transferring tokens from the deployer to `user1` and verifying the balances.
- **testTransferFrom**: Tests the `transferFrom` function by approving `user1` to transfer tokens on behalf of the deployer and verifying the balances and allowance.
- **testFailTransferExceedsBalance**: Ensures that transferring more than the balance fails.
- **testFailApproveExceedsBalance**: Ensures that approving more than the balance fails.
- **testTransferEvent**: Verifies that the `Transfer` event is emitted correctly during a transfer.
- **testApprovalEvent**: Verifies that the `Approval` event is emitted correctly during an approval.
````

I'll caution you against blindly copying and pasting AI responses and to use what's generated intelligently. Some things will make more sense for your situation that others.

When you've implemented your AI suggestsion, run `forge test -vvvv` and see what happens!

### AI Tests

```solidity
function testTransfer() public {
    uint256 amount = 1000 * 10 ** 18; // Example amount
    vm.prank(msg.sender);
    myToken.transfer(user1, amount);

    assertEq(myToken.balanceOf(user1), amount);
    assertEq(myToken.balanceOf(msg.sender), deployer.INITIAL_SUPPLY() - amount);
}

function testTransferFrom() public {
    uint256 amount = 500 * 10 ** 18; // Example amount
    vm.prank(msg.sender);
    myToken.approve(user1, amount);

    vm.prank(user1);
    myToken.transferFrom(msg.sender, user2, amount);

    assertEq(myToken.balanceOf(user2), amount);
    assertEq(myToken.allowance(msg.sender, user1), 0);
}

function testFailTransferExceedsBalance() public {
    uint256 amount = deployer.INITIAL_SUPPLY() + 1;
    vm.prank(msg.sender);
    myToken.transfer(user1, amount); // This should fail
}

function testFailApproveExceedsBalance() public {
    uint256 amount = deployer.INITIAL_SUPPLY() + 1;
    vm.expectRevert();
    vm.prank(msg.sender);
    myToken.approve(user1, amount); // This should fail
}
```
