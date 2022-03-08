//SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./ColorsNFT.sol";

contract ColomintJackpot is VRFConsumerBase, Ownable {
    address payable[] public minters;
    address payable admin;

    constructor()
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709 // LINK Token
        )
    {
        admin = payable(msg.sender);
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10**18; // 0.1 LINK
    }

    receive() external payable {
        require(msg.value == 0.063 ether, "Must be exact ammount");
        require(msg.sender != admin, "Admin can not be in jackpot");
        players.push(payable(msg.sender));
    }

    function getBalance() public returns (uint256) {

        return address(this).balance;
    }

    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.dificulty,
                        block.timestamp,
                        minters.length
                    )
                )
            );
    }

    function pickWinner() public {
        require(admin == msg.sender, "You are not the owner");
        require(minters.length >= 5, "Not enough minters participating");
        address payable winner;
        // winner = minters[random() % minters.length];
        //get random rgb with chainlink
        getRandomnumber();

        
        // check who has the nft closest

    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 _randomness)
        internal
        override
    {
        randomness = _randomness;

        randomHash = keccak256(abi.encodePacked(_randomness));

        //transform randomHash into RGB

        
        // here you search from ColorsNFT.sol if someone has the winning RGB confimbination

        // thats the winner

        winner.transfer(getBalance());
        minters = new address payable[](0);
}
