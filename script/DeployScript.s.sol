// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {MessageBoard} from "../src/MessageBoard.sol";

contract DeployScript is Script {
    function run() external returns (MessageBoard) {
        vm.startBroadcast();
        MessageBoard deployMessageBoard = new MessageBoard();
        vm.stopBroadcast();
        console.log("Your Deploy address is ", address(deployMessageBoard));
        return deployMessageBoard;
    }
}
