// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "openzeppelin-contracts/utils/Counters.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/access/Ownable.sol";
import "openzeppelin-contracts/utils/Strings.sol";

contract FstNFT is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    
    // A total supply of 100 tokens - only 100 tokens can be minted.
    uint256 public TOTAL_SUPPLY = 100;
    
    //Cost of minting the NFT 0.01 ETH.
    uint256 public constant PRICE = 10000000000000000; // 0.01 ETH
    
    //No user can mint more than 5 NFTs in a single transaction 
    uint256 public constant maxNftPurchase = 5;
    
    string public URI;
    
    constructor(
        string memory name, 
        string memory symbol, 
        string memory baseURI
    ) ERC721(name, symbol) {
        URI = baseURI;
    }
    
    function mintNft(uint numberOfTokens) public payable {
        uint256 nftMinted = totalSupply();
        uint256 remainingSupply = TOTAL_SUPPLY - nftMinted;
        uint256 totalPrice = numberOfTokens * PRICE;
        
        require(numberOfTokens <= maxNftPurchase, "You can only mint up to 5 NFTs in a single transaction"); // No user can mint more than 5 NFTs in a single transaction
        require(nftMinted + numberOfTokens <= TOTAL_SUPPLY, string.concat("Sold out! Only ", Strings.toString(remainingSupply), " NFT(s) left.")); // The total supply of NFTs cannot be exceeded
        require(msg.value >= totalPrice, string.concat("You must send at least ", Strings.toString(totalPrice), " ether")); // Ensure enough ether is sent to purchase the NFTs
        
        uint256 nftId = nftMinted + 1;
        
        for (uint i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, nftId + i);
        }
    }
    
    /** 
    * Deployed address is set as “owner” upon deployment and can trigger refund function 
    * which will allow them to receive all the funds collected by the NFT contract from the sale. 
    */
    function refund() public onlyOwner {
        uint balance = address(this).balance;
        (bool transferTx, ) = msg.sender.call{value: balance}("");
        require(transferTx, "Failed to transfer funds");
    }
}
