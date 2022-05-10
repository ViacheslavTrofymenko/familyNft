// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ManNft.sol";
import "./WomanNft.sol";


contract FamilyFactory is ERC721, Ownable {
    ManNftFactory husband;
    WomanNftFactory wife;

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    /// @dev FamilyNft struct includes all required fields in a task
    struct FamilyNft {
        uint8 members;
        uint8 level;
        string lastName;
        uint familyDna;
        uint husbandId;
        uint wifeId;    
        }

    FamilyNft[] public familyNfts;
    

    event NewFamilyNft(uint8 members, uint8 indexed level, string indexed lastName);

    constructor(address _husbandAddress, address _wifeAddress) ERC721("FamilyNftoken", "FML") {
        husband = ManNftFactory(_husbandAddress);
        wife = WomanNftFactory(_wifeAddress);
    }

    function createNewFamily(address to, uint husbandId, uint wifeId, uint8 members) external onlyOwner {
        _safeMint(to, husbandId, wifeId, members);
    }

    function _safeMint(address to, uint husbandId, uint wifeId, uint8 _members) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        uint8 members = _members;

        uint8 level = (husband.getManLevel(husbandId) + wife.getWomanLevel(wifeId)) / 2;

        string memory lastName;
        (,,,lastName,) = husband.manNfts(husbandId);

        uint husbandDna;
        uint wifeDna;
        (,,,,husbandDna) = husband.manNfts(husbandId);
        (,,,,wifeDna) = wife.womanNfts(wifeId);
        uint familyDna = (husbandDna + wifeDna) / 2;

        familyNfts.push(FamilyNft(members, level, lastName, familyDna, husbandId, wifeId));

        emit NewFamilyNft(members, level, lastName);
    }
}

