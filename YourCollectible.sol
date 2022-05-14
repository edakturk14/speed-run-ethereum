// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

// get the OpenZeppelin Contracts, we will use to creat our own
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { Base64 } from "./Lib/Base64.sol";

// Contract for Challenge 6: 🎁 SVG NFT 🎫 Building Cohort

contract YourContract is ERC721URIStorage {

    // keep count of the tokenId
    using Counters for Counters.Counter; // keep track of the token id's
    Counters.Counter private _tokenIds;
    event createdNFT(address sender, uint256 tokenId);

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='blue' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    uint public constant maxSupply = 20; // set the max supply of NFT's for your collection

    constructor() ERC721 ("EdaSVGCollection", "EDA") { 
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256){
        uint256 newItemId = _tokenIds.current();
        return newItemId;
    }

    function mintItem() public { //function to create nfts
        uint256 newItemId = _tokenIds.current();
        require(newItemId < maxSupply);
        string memory result = "yes";
        string memory finalSvg = string(abi.encodePacked(baseSvg, result, "</text></svg>"));
        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        result,
                        '", "description": "Did you win or loose, if yes reach out to Eda!", "image": "data:image/svg+xml;base64,',
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
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        _tokenIds.increment();
        emit createdNFT(msg.sender, newItemId);
    }

}
