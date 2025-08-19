// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract MessageBoard is Ownable {
    error InvalidMessage();
    error MessageNotFound();

    struct Message {
        address author;
        string message;
        uint256 timeStamp;
    }

    uint256 MessageId;
    Message[] public messages;

    event MessagePost(address indexed author, string message, uint256 indexed timeStamp);
    event MessageDelete(address indexed author, uint256 DeleteMessageId);

    constructor() Ownable(msg.sender) {}

    function PostMessage(string memory _content) public {
        if (bytes(_content).length == 0) {
            revert InvalidMessage();
        }
        MessageId++;

        messages.push(Message({author: msg.sender, message: _content, timeStamp: block.timestamp}));
        emit MessagePost(msg.sender, _content, block.timestamp);
    }

    function DeleteMessage(uint256 _messageId) public onlyOwner {
        if (_messageId == 0 || _messageId > messages.length) {
            revert MessageNotFound();
        }
        uint256 index = messages.length - 1;

        messages[index] = messages[messages.length - 1];
        messages.pop();
        emit MessageDelete(msg.sender, _messageId);
    }

    function getMessageCount() public view returns (uint256) {
        if (messages.length == 0) {
            revert MessageNotFound();
        }
        return messages.length;
    }

    function getMessages(uint256 _messageId)
        public
        view
        returns (address author, string memory message, uint256 timeStamp)
    {
        if (_messageId == 0 || _messageId > messages.length) {
            revert MessageNotFound();
        }

        Message memory getMessage = messages[_messageId - 1];
        return (getMessage.author, getMessage.message, getMessage.timeStamp);
    }

    function getAllMessages(uint256 _startingMessage, uint256 _lastMessage) public view returns (Message[] memory) {
        if (_startingMessage >= messages.length) return new Message[](0);
        uint256 total = _startingMessage + _lastMessage;
        if (total > messages.length) total = messages.length;
        uint256 length = total - _startingMessage;
        Message[] memory getPostMessages = new Message[](length);

        for (uint256 i = 0; i < length; ++i) {
            getPostMessages[i] = messages[messages.length - 1 - _startingMessage - i];
        }

        return getPostMessages;
    }
}
