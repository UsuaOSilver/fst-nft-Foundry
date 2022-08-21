// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/FstNFT.sol";

contract NFTTest is Test {
    
    FstNFT private nft;
    
    function setUp() public {
        //Deploy FstNFT contract
        nft = new FstNFT("FstNFT", "FST", "baseUri");
    }
    
    // A token can not be minted if less value than cost (0.01) is provided
     function testFailedNoMintPricePaid() public {
        nft.mintNft(1);
    }
    
    // You can mint one token provided the correct amount of ETH.
    function testMintPricePaid() public {
        nft.mintNft{value: 0.01 ether}(1);
    }

    // // No more than 100 NFTs can be minted
    // function testFailedMaxSupplyReached() public {
    //     uint256 slot = stdstore
    //         .target(address(nft))
    //         .sig("currentTokenId()")
    //         .find();
    //     bytes32 loc = bytes32(slot);
    //     bytes32 mockedCurrentTokenId = bytes32(abi.encode(100));
    //     vm.store(address(nft), loc, mockedCurrentTokenId);
    //     nft.mintTo{value: 0.01 ether}(address(1));
    // }
    
    // // The owner can withdraw the funds collected from the sale
    // function testWithdrawalWorksAsOwner() public {
    //     //Mint an NFT, sending eth to the contract
    //     Receiver receiver = new Receiver();
    //     address payable payee = payable(address(0x1337));
    //     uint256 priorPayeeBalance = payee.balance;
    //     nft.mintTo{value: nft.MINT_PRICE()}(address(receiver));
        
    //     //Check that the balance of the contract is correct
    //     assertEq(address(nft).balance, nft.MINT_PRICE());
    //     uint256 nftBalance = address(nft).balance;
        
    //     //Withdraw the balance and assert it was transferred
    //     nft.withdrawPayments(payee);
    //     assertEq(payee.balance, priorPayeeBalance + nftBalance);
    // }
    
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
    
    // // Check the balance of an account that minted three tokens 
    // // (use multiple accounts to make it easy to understand and readable)
    // function testBalanceIncremented() public {
    //     nft.mintTo{value: 0.01 ether}(address(1));
    //     uint256 slotBalance = stdstore
    //         .target(address(nft))
    //         .sig(nft.balanceOf.selector)
    //         .with_key(address(1))
    //         .find();
            
    //     uint256 balanceFirstMint = uint256(
    //         vm.load(address(nft), bytes32(slotBalance))
    //     );
    //     assertEq(balanceFirstMint, 1);
        
    //     nft.mintTo{value: 0.01 ether}(address(1));
    //     uint256 balanceSecondMint = uint256(
    //         vm.load(address(nft), bytes32(slotBalance))
    //     );
    //     assertEq(balanceSecondMint, 2);
    // }
}

// contract Receiver is ERC721TokenReceiver {
//     function onERC721Received(
//         address operator,
//         address from,
//         uint256 id,
//         bytes calldata data
//     ) external override returns (bytes4) {
//         return this.onERC721Received.selector;
//     }
// }