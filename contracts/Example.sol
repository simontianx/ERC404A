//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ERC404A} from "./ERC404A.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract Example is ERC404A {
    constructor(address _owner) ERC404("Example", "EXM", 18, 10_000, _owner) {
        balanceOf[_owner] = totalSupply;
        setWhitelist(_owner, true);
    }

    function swap(uint256 id1, uint256 id2) public {
        _swap(id1, id2);
    }

    function tokenURI(uint256 id) public pure override returns (string memory){
      return string.concat("https://example.com/token/", Strings.toString(id));
    }
}
