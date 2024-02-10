//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.23;

import {ERC404A} from "./ERC404A.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract Example is ERC404A {
    constructor(address _owner) ERC404A("Example", "EXM", 18, 10_000, _owner) {
        balanceOf[_owner] = totalSupply;
        setWhitelist(_owner, true);
    }

    function swapPosition(uint256 id1, uint256 id2) public {
        _posSwap(id1, id2);
    }

    function getNFTIndex(uint256 id) public view returns (uint256) {
        return _ownedIndex[id];
    }

    function getNFTs(address account) public view returns (uint256[] memory) {
        return _owned[account];
    }

    function tokenURI(uint256 id) public pure override returns (string memory){
      return string.concat("https://example.com/token/", Strings.toString(id));
    }
}
