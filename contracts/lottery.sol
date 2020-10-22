pragma solidity >=0.6.6 < 0.8.0;
contract Lottery {
    address public manager;
    address [] public players;
    address payable public winner;
     
    constructor() public {
        manager = msg.sender;
    }
    function getBalance() public view returns (uint) {
        address(this).balance;
    }
    function enter() public payable {
        require (msg.value >= 0.01 ether);
        players.push(msg.sender);
    }
    function random() private view returns (uint) {
        bytes memory val;
        val = abi.encodePacked(block.difficulty, block.timestamp, players);
        return uint (keccak256(val));
    }
    function pickWinner() public checkForOnlyManager {
        uint index = random() % players.length;
        //address payable winner;
        winner = payable (players[index]);
        winner.transfer(address(this).balance); //transfer ether from contract account to the winner
        //clear array for next round
        players = new address[](0); 
    } 
     modifier checkForOnlyManager {
        require (msg.sender == manager);
        _;  
    }
    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}