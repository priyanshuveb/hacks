## Re-Entrancy
The fallback function is the core ingredient of the reentrancy attack.
<br>
Due to the logic flaw in the victim contract to not update the state variable at the right step, the attacker contract is able to reenter the victim contract before the victim contract is able to update the state variable and flush out the funds.
## Self-destruct
```solidity
selfdestruct(address payable recipient)
```
Destroys the current contract, sending its funds to the given Address and end execution. The receiving contract’s receive function is not executed.
<br>

A contract either requires a fallback or receive function to receive any ether into it otherwise it rejects the incoming ether. The self-destruct  function bypasses that and forcefully sends the ether into that the receiving contract, the receiving contract need not be implementing fallback/receive function.

## DoS (Denial of Service)
Causing a function or a transaction not being able to execute. In an overview while analyzing the code for DoS always look into:
1) for-loops if they are unbounded
2) external calls to other contracts and if that call can fail, if yes then is it reverting the whole tx and how this will affect the some function/service from being happening. For example:
   1) Sending ether to a contract that does not accept it
   2) Calling a function that does not exist
   3) The external call execution runs out of gas
   4) Third party contract is malicious and intentionally reverts false

## Private Variable
- 1 bit = 1 or 0
- 1 byte = 8 bits
  - 10011001 = 2<sup>0</sup>+2<sup>3</sup>+2<sup>4</sup>+2<sup>7</sup> = 153 (conversion of a binary value to decimal value)
- 1 Hex char = 4 bits
  - 0,1,2,3,4,5,6,7,8,9,A=10,B=11,C=12,D=13,E=14,F=15
  - 0x3EA = (3x16)<sup>2</sup> + (14x16)<sup>1</sup> + (10x16)<sup>0</sup> = 1002 (conversion on hex to decimal)
- 1 byte = 8 bits = 2 hex
- bytes32 = uint256 
- 1 byte = uint8
- 2 bytes = uint16 and so on
- bool = 1 byte
- address  = 20 byte (160 bits)

### Storage
- [Layout of state variables in storage ](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html) 
- 32 bytes for each slot
- data is stored sequentially in the order of declaration
- storage is optimized to save space. If neighboring variables fit in a single
  32 bytes, then they are packed into the same slot, starting from the right

### Access storage slot
- Start Anvil
```bash
anvil
```
- Deploy contract
```bash
forge script script/DeployStorage.sol:DeployStorage --rpc-url anvil --private-key ${PRIVATE_KEY_ANVIL}  --broadcast -vvvv
```
- Access slot value
```bash
cast storage --rpc-url anvil <CONTRACT_ADDRESS> <SLOT_NUMBER>
```

## Weak PRNG (Pseudo Random Number Generator)
block.timestamp can be manipulated by miners with the following constraints

- it cannot be stamped with an earlier time than its parent
- it cannot be too far in the future
### Prevention
- Chainlink VRF
- Commit Reveal Scheme
