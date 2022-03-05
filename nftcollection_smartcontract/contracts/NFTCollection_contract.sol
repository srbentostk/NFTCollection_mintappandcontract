// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import {Base64} from "./libraries/Base64.sol";

contract NFTCollection_contract is
    ERC721,
    ERC721URIStorage,
    ERC721Enumerable,
    ERC2981,
    Ownable
{
    //Cost, MaxSupply and MintAmount settings
    uint256 public cost = 0.0005 ether;
    uint256 public maxSupply = 7777;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 500 500'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string[] space1 = ["</text><text x='50' y='120' class='base'>"];
    string[] names = [
        "Jess",
        "Bearpig ",
        "Bradd ",
        "Matador ",
        "Rob ",
        "Lui ",
        "Kayo ",
        "Tony ",
        "Wally ",
        "Matthew ",
        "Rick ",
        "Sogna ",
        "Farmer ",
        "Killer ",
        "Anonymous ",
        "Soro ",
        "Steve ",
        "Astasheram "
    ];
    string[] space2 = ["</text><text x='50' y='200' class='base'>"];
    string[] classes = [
        "Bard ",
        "Healer ",
        "Farmer ",
        "Swordsman ",
        "Necromancer ",
        "Archer ",
        "Warrior ",
        "Thief ",
        "Mage ",
        "Batata ",
        "Wizard ",
        "Paladin ",
        "Assassin ",
        "Barbarian ",
        "Depravado ",
        "Cooker ",
        "Hunter ",
        "Vigilant ",
        "Watchman ",
        "Witcher ",
        "Shooter ",
        "Ironman ",
        "Blacksmith "
    ];
    string[] space3 = ["</text><text x='50' y='280' class='base'>"];
    string[] races = [
        "Elf ",
        "Human ",
        "Dwarf ",
        "Giant ",
        "Goblin ",
        "Dark_elf ",
        "Ogre ",
        "Orc ",
        "Pigman ",
        "Ghost ",
        "Demigod ",
        "Undead ",
        "Mermaid ",
        "Fairy ",
        "Minotaur ",
        "Werewolf ",
        "Vampire ",
        "Saci ",
        "Curgala "
    ];
    string[] space4 = ["</text><text x='50' y='360' class='base'>"];
    string[] alignment = [
        "Lawful Good",
        "Neutral Good",
        "Chaotic Good",
        "Lawful Neutral",
        "True Neutral",
        "Chaotic Neutral",
        "Lawful Evil",
        "Neutral Evil",
        "Chaotic Evil"
    ];
    event NewNFTMinted(address sender, uint256 tokenId);

    constructor(uint96 _royaltyFeesInBips) ERC721("Boring_RPG", "BHERO") {
        setRoyaltyInfo(msg.sender, _royaltyFeesInBips);
        console.log("My NFT collection contract is on blockchain");
    }

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % names.length;
        return names[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % classes.length;
        return classes[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % races.length;
        return races[rand];
    }

    function pickRandomFourthWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FOURTH_WORD", Strings.toString(tokenId)))
        );
        rand = rand % alignment.length;
        return alignment[rand];
    }

    function pickSpace1() public view returns (string memory) {
        return space1[0];
    }

    function pickSpace2() public view returns (string memory) {
        return space2[0];
    }

    function pickSpace3() public view returns (string memory) {
        return space3[0];
    }

    function pickSpace4() public view returns (string memory) {
        return space4[0];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnNFT() public payable {
        uint256 supply = totalSupply();
        require(msg.value >= cost, "You need more ether");
        uint256 newItemId = _tokenIds.current();
        require(newItemId < 10, "newItemId invalid");
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory fourth = pickRandomFourthWord(newItemId);
        string memory tab1 = pickSpace1();
        string memory tab2 = pickSpace2();
        string memory tab3 = pickSpace3();
        string memory tab4 = pickSpace4();
        string memory combinedWord = string(
            abi.encodePacked(
                tab1,
                first,
                tab2,
                second,
                tab3,
                third,
                tab4,
                fourth
            )
        );
        string memory combinedName = string(
            abi.encodePacked(third, first, second)
        );
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedName,
                        '", "description": "A boring RPG NFT-based game. Your NFT shows a boring hero name, class, race and alignment. Anyone who owns an Boring Hero can make an game using any hero of the collection.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");
        //Mint requirements
        //require(newItemId < maxSupply, "newItemId invalid");
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        supply += 1;
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        emit NewNFTMinted(msg.sender, newItemId);
    }

    function ownerClaim() public onlyOwner {
        uint256 supply = totalSupply();
        uint256 newItemId = _tokenIds.current();
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory fourth = pickRandomFourthWord(newItemId);
        string memory tab1 = pickSpace1();
        string memory tab2 = pickSpace2();
        string memory tab3 = pickSpace3();
        string memory tab4 = pickSpace4();
        string memory combinedWord = string(
            abi.encodePacked(
                tab1,
                first,
                tab2,
                second,
                tab3,
                third,
                tab4,
                fourth
            )
        );
        string memory combinedName = string(
            abi.encodePacked(third, first, second)
        );
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedName,
                        '", "description": "A boring RPG NFT-based game. Your NFT shows a boring hero name, class, race and alignment. Anyone who owns an Boring Hero can make an game using any hero of the collection.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");
        //Mint requirements
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        supply += 1;
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        emit NewNFTMinted(msg.sender, newItemId);
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC2981, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips)
        public
        onlyOwner
    {
        _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
    }
}
