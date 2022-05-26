//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
We need to call the Whitelist Contract to check and give presale access to the whitelisted addresses. 
These addresses are stored in "whitelistedAddresses" mapping. 
So we create this interface to call only this mapping and not the entire contract
to save some gasfee.
*/
interface IWhitelist {
    function whitelistedAddresses(address) external view returns (bool);
}
