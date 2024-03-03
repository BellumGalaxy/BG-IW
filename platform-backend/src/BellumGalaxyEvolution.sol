// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

        ///////////////
        /// IMPORTS ///
        ///////////////

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage, Strings} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

        /////////////
        /// ERROR ///
        /////////////
error BellumGalaxyEvolution__InvalidNFTId();
error BellumGalaxyEvolution__AlreadyHasANFT();
error BellumGalaxyEvolution__ThereAreOnlyFiveLevels();

contract BellumGalaxyEvolution is ERC721, ERC721URIStorage {
    using Strings for uint256;

    struct Star{
        uint256 lvl;
        uint256 exp;
        string name;
        string image;
        string uri;
    }

    /////////////////////////////
    /// CONSTANT & IMMUTABLES ///
    /////////////////////////////
    uint256 constant TOTAL_LEVELS = 6;

    /////////////////////
    ///STATE VARIABLES///
    /////////////////////
    uint256 private s_nextTokenId;

    string[7] private starName = [
        "Stelar Dust",
        "Protostar",
        "Principal Sequence",
        "Red Giant",
        "White Dwarf",
        "Supernova",
        "BlackHole"
    ];

    string[7] private starImage = [
        "https://bafybeihdkzwuyfhjicomsyuwz2dmdqxhsp2dm3a5p6jootg6dymlb6hju4.ipfs.nftstorage.link/StelarDust.png",
        "https://bafybeihdkzwuyfhjicomsyuwz2dmdqxhsp2dm3a5p6jootg6dymlb6hju4.ipfs.nftstorage.link/Protostar.png",
        "https://bafybeihdkzwuyfhjicomsyuwz2dmdqxhsp2dm3a5p6jootg6dymlb6hju4.ipfs.nftstorage.link/PrincipalSequence.png",
        "https://bafybeihdkzwuyfhjicomsyuwz2dmdqxhsp2dm3a5p6jootg6dymlb6hju4.ipfs.nftstorage.link/RedGiant.png",
        "https://bafybeihdkzwuyfhjicomsyuwz2dmdqxhsp2dm3a5p6jootg6dymlb6hju4.ipfs.nftstorage.link/WhiteDwarf.png",
        "https://bafybeihdkzwuyfhjicomsyuwz2dmdqxhsp2dm3a5p6jootg6dymlb6hju4.ipfs.nftstorage.link/Supernova.png",
        "https://bafybeihdkzwuyfhjicomsyuwz2dmdqxhsp2dm3a5p6jootg6dymlb6hju4.ipfs.nftstorage.link/Black%20Hole.png"
    ];

    mapping(uint256 tokenId => Star) private starEvolution;
    mapping(uint256 lvl => uint256 exp) private level;

    //////////////
    /// EVENTS ///
    //////////////
    event BellumGalaxyEvolution__NewLevelAddedOrUpdated(uint256 level, uint256 exp);
    event BellumGalaxyEvolution__TheGasIsFreezingABirthIsOnTheWay(uint256 tokenId);


    constructor()
        ERC721("Bellum Galaxy Evolution", "BGE")
    {}

    //////////////////////////
    /// EXTERNAL FUNCTIONS ///
    //////////////////////////

    function safeMint() external {
        if(balanceOf(msg.sender) >= 1){
            revert BellumGalaxyEvolution__AlreadyHasANFT();
        }

        uint256 tokenId = s_nextTokenId;

        string memory uri = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "', starName[0], '",'
                        '"description": "Bellum Galaxy Star Evolution",',
                        '"image": "', starImage[0], '",'
                        '"attributes": [',
                            '{"trait_type": "Exp",',
                            '"value": ', "0",'}',
                            ',{"trait_type": "Level",',
                            '"value": ', "0",'}',
                            ',{"trait_type": "Next Level",',
                            '"value": ', "1",'}',
                        ']}'
                    )
                )
            )
        );
        // Create token URI
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", uri)
        );

        starEvolution[tokenId] = Star({
            lvl: 0,
            exp: 0,
            name: starName[0],
            image: starImage[0],
            uri: finalTokenURI
        });

        ++s_nextTokenId;

        emit BellumGalaxyEvolution__TheGasIsFreezingABirthIsOnTheWay(tokenId);

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, finalTokenURI);
    }
    
    //Must add control access here
    function updateNFT(uint256 _tokenId, uint256 _exp) external {
        if(_tokenId > s_nextTokenId){
            revert BellumGalaxyEvolution__InvalidNFTId();
        }
        
        uint256 nextLvl = starEvolution[_tokenId].lvl + 1;

        starEvolution[_tokenId].exp += _exp;

        if(starEvolution[_tokenId].exp > level[nextLvl] && starEvolution[_tokenId].lvl < TOTAL_LEVELS){
            starEvolution[_tokenId].lvl++;
        }

        updateNFTMetadata(_tokenId, starEvolution[_tokenId].lvl, starEvolution[_tokenId].exp);

        //Se atingir o level máximo, para de aumentar Level, mas o exp acumulado se torna tokenStar.
        //Precisa mintar o Token ao invés de upar level aqui.
    }

    function addOrAdjustLevels(uint256 _level, uint256 _expNeeded) external {
        if(_level > TOTAL_LEVELS){
            revert BellumGalaxyEvolution__ThereAreOnlyFiveLevels();
        }
        level[_level] = _expNeeded;

        emit BellumGalaxyEvolution__NewLevelAddedOrUpdated(_level, _expNeeded);
    }

    ////////////////////////
    /// PUBLIC FUNCTIONS ///
    ////////////////////////
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool){
        return super.supportsInterface(interfaceId);
    }

    //////////////////////////
    /// INTERNAL FUNCTIONS ///
    //////////////////////////
    function updateNFTMetadata(uint256 _tokenId, uint256 _lvl, uint256 _exp) internal {
        uint256 nextLvl = _lvl+1;

        string memory uri = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "', starName[_lvl], '",'
                        '"description": "Bellum Galaxy Star Evolution",',
                        '"image": "', starImage[_lvl], '",'
                        '"attributes": [',
                            ',{"trait_type": "Level",',
                            '"value": ', _lvl.toString(),'}',
                            '{"trait_type": "Exp",',
                            '"value": ', _exp.toString(),'}',
                            ',{"trait_type": "Next Level",',
                            '"value": ', nextLvl.toString(),'}',
                        ']}'
                    )
                )
            )
        );
        // Create token URI
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", uri)
        );
        _setTokenURI(_tokenId, finalTokenURI);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }

    ///////////////////////////
    ///VIEW & PURE FUNCTIONS///
    ///////////////////////////
    function getNFTLevel(uint256 _tokenId) external returns(uint256 nftLevel){
        nftLevel = starEvolution[_tokenId].lvl;
    }
}
