// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract NFTCollection_contract is ERC721URIStorage {
    // OpenZeppelin help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
  string[] firstWords = ["Jess", "Bearpig ", "Bradd ", "Matador ", "Rob ", "Lui ", "Kayo ", "Tony ", "Wally ", "Matthew ", "Rick ", "Sogna ", "Farmer ", "Killer ", "Anonymous ", "Soro ", "Steve ", "Astasheram "];
  string[] secondWords = ["Bard ", "Healer ", "Farmer ", "Swordsman ", "Necromancer ", "Archer ", "Warrior ", "Thief ", "Mage ", "Batata ", "Wizard ", "Paladin ", "Assassin ", "Barbarian ", "Depravado ", "Cooker ", "Hunter ", "Vigilant ", "Watchman ", "Witcher ", "Shooter ", "Ironman ", "Blacksmith "];
  string[] thirdWords = ["Elf ", "Human ", "Dwarf ", "Giant ", "Goblin ", "Dark_elf ", "Ogre ", "Orc ", "Pigman ", "Ghost ", "Demigod ", "Undead ", "Mermaid ", "Fairy ", "Minotaur ", "Werewolf ", "Vampire ", "Saci ", "Curgala "];
  event NewNFTMinted(address sender, uint256 tokenId);




  // We need to pass the name of our NFTs token and its symbol.
  constructor() ERC721 ("Boring_RPG", "CHAR") {
    console.log("My NFT collection contract is on blockchain");
  }
  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator.
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }


  // A function our user will hit to get their NFT.
  function makeAnNFT() public {
     // Get the current tokenId, this starts at 0.
    uint256 newItemId = _tokenIds.current();
     // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));
     // Get all the JSON metadata in place and base64 encode it.
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A boring RPG NFT-based game. Your NFT shows a boring hero name, class and race.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");
    //require(_mintAmount <= maxSupply, "max NFT limit exceeded");

     // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);

    // Set the NFTs data.
    _setTokenURI(newItemId, finalTokenUri);

    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    emit NewNFTMinted(msg.sender, newItemId);
  }
  // About mint
  function getTotalNFTsMintedSoFar() public view returns (uint256) {
    return _tokenIds.current() + 1;
  }
  uint256 public maxSupply = 8000;
  uint256 public cost = 1.5 ether;
  event MintEvent(address sender, uint256 tokenId);


}
