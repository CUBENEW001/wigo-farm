// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./OpenZeppelin/token/ERC20/IERC20.sol";
import "./OpenZeppelin/token/ERC20/TokenTimeLock.sol";
import "./OpenZeppelin/token/ERC20/SafeERC20.sol";
import "./OpenZeppelin/math/SafeMath.sol";

// To see openzepplin's audits goto: https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/audit
contract WigoVesting {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public wigo;
    IERC20 public wigoLP;
    address public devAddr;
    address public seedInvestor1;
    address public seedInvestor2;

    TokenTimelock[] public Locks;

    event Release(uint256 lockNumber, address indexed beneficiary);

    constructor(
        IERC20 _wigo,
        IERC20 _wigoLP,
        address _devAddr,
        address _seedInvestor1,
        address _seedInvestor2
    ) public {
        wigo = _wigo;
        wigoLP = _wigoLP;
        devAddr = _devAddr;
        seedInvestor1 = _seedInvestor1;
        seedInvestor2 = _seedInvestor2;
        uint256 currentTime = block.timestamp;

        createLock(wigo, seedInvestor1, currentTime.add(90 days));
        createLock(wigo, seedInvestor1, currentTime.add(180 days));
        createLock(wigo, seedInvestor1, currentTime.add(270 days));
        createLock(wigo, seedInvestor1, currentTime.add(360 days));

        createLock(wigo, seedInvestor2, currentTime.add(90 days));
        createLock(wigo, seedInvestor2, currentTime.add(180 days));
        createLock(wigo, seedInvestor2, currentTime.add(270 days));
        createLock(wigo, seedInvestor2, currentTime.add(360 days));

        createLock(wigoLP, devAddr, currentTime.add(360 days));
    }

    function createLock(
        IERC20 token,
        address sender,
        uint256 time
    ) internal {
        TokenTimelock lock = new TokenTimelock(token, sender, time);
        Locks.push(lock);
    }

    // Attempts to release tokens. This is done safely with
    // OpenZeppelin which checks the proper time has passed.
    // To see their code go to:
    // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/TokenTimelock.sol
    function release(uint256 lock) external {
        Locks[lock].release();
        emit Release(lock, Locks[lock].beneficiary());
    }

    function getLockAddress(uint256 lock) external view returns (address) {
        require(lock <= 8, "getLockAddress: lock doesnt exist");
        return address(Locks[lock]);
    }
}
