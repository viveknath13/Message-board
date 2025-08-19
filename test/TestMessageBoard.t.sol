// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MessageBoard} from "../src/MessageBoard.sol";

contract TestMessage is Test {
    address VIVEK = makeAddr("vivek");
    address Bob = makeAddr("Bob");
    address web3 = makeAddr("web3");
    address linux = makeAddr("linux");
    MessageBoard public testMessageBoard;

    function setUp() external {
        testMessageBoard = new MessageBoard();
    }

    function testSetMessage() public {
        string memory setMessage = "Hey there vivek here ";
        vm.prank(VIVEK);
        testMessageBoard.PostMessage(setMessage);
        (address author, string memory content, uint256 timestamp) = testMessageBoard.getMessages(1);
        assertEq(author, VIVEK);
        assertEq(content, setMessage);
        assertEq(timestamp, block.timestamp);
    }

    function testDeleteMessage() public {
        string memory setMessage = "i want to delete this message";
        vm.prank(VIVEK);
        testMessageBoard.PostMessage(setMessage);
        assertEq(testMessageBoard.getMessageCount(), 1);

        (address author, string memory content, uint256 timestamp) = testMessageBoard.getMessages(1);
        assertEq(author, VIVEK);
        assertEq(content, setMessage);
        assertEq(timestamp, block.timestamp);
        testMessageBoard.DeleteMessage(1);
        vm.expectRevert(MessageBoard.MessageNotFound.selector);

        console.log(testMessageBoard.getMessageCount());
    }

    function testGetMessage() public {
        vm.prank(VIVEK);
        string memory setMessage = "Hello i am vivek how are you...";
        testMessageBoard.PostMessage(setMessage);
        (address author, string memory content, uint256 timeStamp) = testMessageBoard.getMessages(1);
        assertEq(author, VIVEK);
        assertEq(content, setMessage);
        assertEq(timeStamp, block.timestamp);
    }

    function testGetMessageRevert() public {
        vm.expectRevert(MessageBoard.MessageNotFound.selector);
        testMessageBoard.getMessages(0);
    }

    function testZeroMessage() public {
        vm.prank(Bob);
        testMessageBoard.PostMessage("Hola you don't get any Message");
        vm.expectRevert(MessageBoard.MessageNotFound.selector);
        testMessageBoard.getMessages(0);
    }

    function testMultipleMessage() public {
        //set first message
        string memory firstMessage = "Hey i am vivek ";
        uint256 vivekMessageTime = block.timestamp;
        vm.prank(VIVEK);
        testMessageBoard.PostMessage(firstMessage);
        vm.warp(block.timestamp + 100);
        string memory secondMessage = "Hey i am Bob";
        uint256 bobMessageTime = block.timestamp;
        vm.prank(Bob);
        testMessageBoard.PostMessage(secondMessage);

        //Get vivek messages
        (address author, string memory content, uint256 timestamp1) = testMessageBoard.getMessages(1);
        assertEq(author, VIVEK);
        assertEq(content, firstMessage);
        assertEq(timestamp1, vivekMessageTime);

        //Get BOb messages

        (address author2, string memory content2, uint256 timeStamp2) = testMessageBoard.getMessages(2);
        assertEq(author2, Bob);
        assertEq(content2, secondMessage);
        assertEq(timeStamp2, bobMessageTime);
    }

    function testGetAllMessages() public {
        string memory web3Post = "The future of internet is Web3";
        vm.prank(web3);
        testMessageBoard.PostMessage(web3Post);

        string memory linuxPost = "The blockchain is trust ";
        vm.prank(linux);
        testMessageBoard.PostMessage(linuxPost);

        string memory vivek2post = "Solidity is the absolutely  best language to making contract";
        vm.prank(VIVEK);
        testMessageBoard.PostMessage(vivek2post);
        string memory Bob2Post =
            "Yes if you want to secure your data just put it in the blockchain because it's immutable decentralized";
        vm.prank(Bob);
        testMessageBoard.PostMessage(Bob2Post);

        MessageBoard.Message[] memory allMessages = testMessageBoard.getAllMessages(0, 4);
        console.log("all message are", allMessages.length);
        assertEq(allMessages[0].author, Bob);
        assertEq(allMessages[0].message, Bob2Post);
        assertEq(allMessages[1].author, VIVEK);
        assertEq(allMessages[1].message, vivek2post);
       assertEq(allMessages[2].author,linux);
       assertEq(allMessages[2].message,linuxPost);
       assertEq(allMessages[3].author,web3);
       assertEq(allMessages[3].message,web3Post);
    }
}
