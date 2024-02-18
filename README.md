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
