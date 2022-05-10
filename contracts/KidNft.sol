// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./FamilyNft.sol";


contract KidsFactory is ERC721, Ownable {
    FamilyFactory parents;

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    /// @dev KidsNft struct includes all required fields in a task
    struct KidNft {
        uint8 age;
        uint8 level;
        string name;
        string lastName;
        uint momId;
        uint dadId;
        uint kidDna;      
        }

    KidNft[] public kidsNfts;

    event NewKidNft(uint8 age, uint8 indexed level, string indexed Name, string indexed lastName, uint momId, uint dadId);

    constructor(address _familyAddress) ERC721("KidsNftoken", "KID") {
        parents = FamilyFactory(_familyAddress); 
    }

    function createNewKid(address to, uint parentsId, string memory name) external onlyOwner {
        _safeMint(to, parentsId, name);
    }

    function _safeMint(address to, uint parentsId, string memory name) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        uint8 age;

        uint8 level;
        (,level,,,,) = parents.familyNfts(parentsId);        

        string memory lastName;
        (,,lastName,,,) = parents.familyNfts(parentsId);

        uint familyDna;
        (,,, familyDna,,) = parents.familyNfts(parentsId);

        uint momId;
        (,,,,,momId) = parents.familyNfts(parentsId);

        uint dadId;
        (,,,,dadId,) = parents.familyNfts(parentsId);
       
       /**@notice If will born 2 and more kids from same parents,
        we want to keep their dna similar but not same. Therefore last to digits will be unique for each kid
       **/

        uint kidDna = familyDna - familyDna % 100 + uint(keccak256(abi.encodePacked(block.timestamp, name))) % 100;

        kidsNfts.push(KidNft(age, level, name, lastName, momId, dadId, kidDna));

        emit NewKidNft(age, level, name, lastName, momId, dadId);
    }

}