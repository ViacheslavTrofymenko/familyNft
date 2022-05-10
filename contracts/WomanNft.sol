// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract WomanNftFactory is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint dnaDigits = 6;
    uint dnaModulus = 10 ** dnaDigits;

    /// @dev WomanNft struct includes all required fields in a task
    struct WomanNft {
        uint8 age;
        uint8 level;
        string name;
        string lastName;
        uint manDna;
    }

    WomanNft[] public womanNfts;

    event NewWomanNft(uint8 age, uint8 level, string name, string lastName);

    constructor() ERC721("WomanNftoken", "WMN") {}

    /// @dev Create a new WomanNFT token with required NFT fields as per task #4.

    function createNewWoman(address to, uint8 age, uint8 level, string memory name, string memory lastName) external onlyOwner {
        _createNewWoman(to, age, level, name, lastName);
    }

    function _createNewWoman(address to, uint8 age, uint8 level, string memory name, string memory lastName) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        uint womanDna = uint(keccak256(abi.encodePacked(age, level, name, lastName))) % dnaModulus;

        womanNfts.push(WomanNft(age, level, name, lastName, womanDna));

        emit NewWomanNft(age, level, name, lastName);
    }

    function getWomanLevel(uint256 _tokenId) external view returns(uint8) {
        WomanNft memory _woman = womanNfts[_tokenId];
        uint8 _level = _woman.level;
        return _level;
    }
}