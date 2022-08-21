// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "openzeppelin-contracts/token/ERC721/IERC721Receiver.sol";
import "../src/FstNFT.sol";

contract NFTTest is Test {
    using stdStorage for StdStorage;
    
    FstNFT public nft;
    
    address Alice = address(0x123);
    address payable payee = payable(address(0xdc62));
    address receiver = address(0x456);
    address I333 = address(0x333);
    
    function setUp() public {
        //Deploy FstNFT contract
        nft = new FstNFT("FstNFT", "FST", "baseUri");
    }
    

    // No more than 100 NFTs can be minted
    function testFailedMaxSupplyReached() public {
        uint256 slot = stdstore
            .target(address(nft))
            .sig("nftId()")
            .find();
        bytes32 loc = bytes32(slot);
        bytes32 mockedCurrentTokenId = bytes32(abi.encode(100));
        vm.store(address(nft), loc, mockedCurrentTokenId);
        
        vm.startPrank(Alice);
        vm.deal(Alice, 0.02 ether);
        
        nft.mintNft{value: 0.01 ether}(1);
        
        vm.stopPrank();
    }
    
    // A token can not be minted if less value than cost (0.01) is provided
     function testFailedNoMintPricePaid() public {
        nft.mintNft(1);
    }
    
    // No more than five tokens can be minted in a single transaction
    function testFailedMaxPurchase() public {
        uint256 slot = stdstore
            .target(address(nft))
            .sig("maxNftPurchase()")
            .find();
        bytes32 loc = bytes32(slot);
        bytes32 mockedNumberOfTokens = bytes32(abi.encode(5));
        vm.store(address(nft), loc, mockedNumberOfTokens);
        
        vm.startPrank(Alice);
        vm.deal(Alice, 0.02 ether);
        
        nft.mintNft{value: 0.01 ether}(1);
        
        vm.stopPrank();
    }
    
    // The owner can withdraw the funds collected from the sale
    function testWithdrawalWorksAsOwner() public {
        //Mint an NFT, sending eth to the contract
        uint256 priorPayeeBalance = payee.balance;
        
        vm.startPrank(receiver);
        vm.deal(receiver, 0.02 ether);
        nft.mintNft{value: nft.PRICE()}(1);
        vm.stopPrank();
                
        //Check that the balance of the contract is correct
        assertEq(address(nft).balance, nft.PRICE());
        uint256 nftBalance = address(nft).balance;
        
        //Withdraw the balance and assert it was transferred        
        vm.startPrank(payee);
        vm.deal(payee, 0.02 ether);
        nft.refund();
        vm.stopPrank();
        
        assertEq(payee.balance, priorPayeeBalance + nftBalance);
    }
    
    // function testWithdrawalFailsAsNotOwner() public {
    //     // Mint an NFT and send eth to the contract
    //     Receiver receiver = new Receiver();
    //     nft.mintTo{value: nft.MINT_PRICE()}(address(receiver));
        
    //     //Check that the balance of the contract is correct
    //     assertEq(address(nft).balance, nft.MINT_PRICE());
        
    //     //Confirm that a non-owner cannot withdraw
    //     vm.expectRevert("Ownable: caller is not the owner");
    //     vm.startPrank(address(0xd3ad));
    //     nft.withdrawPayments(payable(address(0xd3ad)));
    //     vm.stopPrank();
    // }
    
    // You can mint one token provided the correct amount of ETH.
    function testMintPricePaid() public {
        
        vm.startPrank(Alice);
        vm.deal(Alice, 0.02 ether);
        
        nft.mintNft{value: 0.01 ether}(1);
        
        vm.stopPrank();
    }
    
    // You can mint three tokens in a single transaction provided the correct amount of ETH
    function testMintMultipleTokens() public {
        
        vm.startPrank(Alice);
        vm.deal(Alice, 0.04 ether);
        
        nft.mintNft{value: 0.03 ether}(3);
        
        vm.stopPrank();
    }
    
    // Check the balance of an account that minted three tokens 
    // (use multiple accounts to make it easy to understand and readable)
    function testCorrectBalanceIncremented() public {
        vm.startPrank(I333);
        vm.deal(I333, 0.04 ether);
        
        nft.mintNft{value: 0.01 ether}(1);
        uint256 slotBalance = stdstore
            .target(address(nft))
            .sig(nft.balanceOf.selector)
            .with_key(I333)
            .find();
            
        uint256 balanceFirstMint = uint256(
            vm.load(address(nft), bytes32(slotBalance))
        );
        assertEq(balanceFirstMint, 1);
        
        nft.mintNft{value: 0.01 ether}(1);
        uint256 balanceSecondMint = uint256(
            vm.load(address(nft), bytes32(slotBalance))
        );
        assertEq(balanceSecondMint, 2);
        
        nft.mintNft{value: 0.01 ether}(1);
        uint256 balanceThirdMint = uint256(
            vm.load(address(nft), bytes32(slotBalance))
        );
        assertEq(balanceThirdMint, 3);
    }
}