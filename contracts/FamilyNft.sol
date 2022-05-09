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
        }

    FamilyNft[] public familyNfts;

    event NewFamilyNft(uint8 members, uint8 indexed level, string indexed lastName);

    constructor(address _husbandAddress, address _wifeAddress) ERC721("FamilyNftoken", "FML") {
        husband = ManNftFactory(_husbandAddress);
        wife = WomanNftFactory(_wifeAddress);
    }

    function createNewFamily(address to, uint husbandId, uint wifeId) external onlyOwner {
        _safeMint(to, husbandId, wifeId);
    }

    function _safeMint(address to, uint husbandId, uint wifeId) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        uint8 members = 2;

        uint8 level = (husband.getManLevel(husbandId) + wife.getWomanLevel(wifeId)) / 2;

        string memory lastName;
        (,,,lastName,) = husband.manNfts(husbandId);

        familyNfts.push(FamilyNft(members, level, lastName));

        emit NewFamilyNft(members, level, lastName);
    }


}
