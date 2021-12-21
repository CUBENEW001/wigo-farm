// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface ICollectionWhitelistChecker {
    function canList(uint256 _tokenId) external view returns (bool);
}