// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ManNftFactory is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint dnaDigits = 6;
    uint dnaModulus = 10 ** dnaDigits;

    /// @dev ManNft struct includes all required fields in a task
    struct ManNft {
        uint8 age;
        uint8 level;
        string name;
        string lastName;
        uint manDna;
    }

    ManNft[] public manNfts;

    event NewManNft(uint8 age, uint8 indexed level, string name, string indexed lastName);

    constructor() ERC721("ManNftoken", "MAN") {}

    /// @dev Create a new ManNFT token with required NFT fields as per task #4.

    function createNewMan(address to, uint8 age, uint8 level, string memory name, string memory lastName) external onlyOwner {
        _safeMint(to, age, level, name, lastName);
    }

    function _safeMint(address to, uint8 age, uint8 level, string memory name, string memory lastName) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        uint manDna = uint(keccak256(abi.encodePacked(age, level, name, lastName))) % dnaModulus;
        manNfts.push(ManNft(age, level, name, lastName, manDna));

        emit NewManNft(age, level, name, lastName);
    }

    function getManLevel(uint256 _tokenId) external view returns(uint8) {
        ManNft memory _man = manNfts[_tokenId];
        uint8 _level = _man.level;
        return _level;
        }
    
    function getMan(uint256 _tokenId) external view returns (ManNft memory) {
        return manNfts[_tokenId];
    }
}