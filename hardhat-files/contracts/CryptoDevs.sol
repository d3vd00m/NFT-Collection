// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    /*
     _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
     token will be the concatenation of the 'baseURI' and the 'tokenId'.
     */
    string _baseTokenURI;

    //  Define the price of one Crypto Dev NFT
    uint256 public _price = 0.01 ether;

    // _paused is used to pause the contract
    bool public _paused;

    // Define the max number of NFTs
    uint256 public maxTokenIds = 20;

    // Define the total number of tokenIds minted
    uint256 public totalTokenIds;

    // Whitelist contract instance
    IWhitelist whitelist;

    // boolean to keep track of presale started or not
    bool public presaleStarted;

    // uint to define the presale end in terms of minutes
    uint256 public presaleEnded;

    // Modifier for the current status of the contract
    modifier onlyWhenNotPaused() {
        require(!_paused, "Contract currently paused");
        _;
    }

    /*
    ERC721 constructor takes in a `name` and a `symbol` to the token collection.
    Constructor for Crypto Devs takes in the baseURI to set _baseTokenURI for the collection.
    It also initializes an instance of whitelist interface.
     */
    constructor(string memory baseURI, address whitelistContract)
        ERC721("Crypto Devs", "CD")
    {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    // This starts a 5 minutes presale for the whitelisted addresses
    function startPresale() public onlyOwner {
        presaleStarted = true;
        // Set presaleEnded time as current timestamp + 5 minutes
        presaleEnded = block.timestamp + 5 minutes;
    }

    // This allows a user to mint one NFT per transaction during the presale.
    function presaleMint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp < presaleEnded,
            "Presale is not running"
        );
        require(
            whitelist.whitelistedAddresses(msg.sender),
            "You are not whitelisted"
        );
        require(
            totalTokenIds < maxTokenIds,
            "Exceeded maximum Crypto Devs supply"
        );
        require(msg.value >= _price, "Check your Ether amount!");
        totalTokenIds += 1;
        _safeMint(msg.sender, totalTokenIds);
    }

    // mint allows a user to mint 1 NFT per transaction after the presale has ended.
    function mint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp >= presaleEnded,
            "Presale has not ended yet"
        );
        require(
            totalTokenIds < maxTokenIds,
            "Exceed maximum Crypto Devs supply"
        );
        require(msg.value >= _price, "Check your Ether amount!");
        totalTokenIds += 1;
        _safeMint(msg.sender, totalTokenIds);
    }

    //_baseURI overides the Openzeppelin's ERC721 implementation which by default
    // returned an empty string for the baseURI
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // setPaused makes the contract paused or unpaused
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    // withdraw sends all the ether in the contract to the owner
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
