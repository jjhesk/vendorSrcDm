

pragma solidity ^0.6.0;

import "./AccessControl.sol";
import "./Ownable.sol";

contract WhitelistedRole is AccessControl, Ownable {
    bytes32 public constant governor = keccak256("_governor");
    bytes32 public constant whitelistinvestor = keccak256("_whitelistinvestor");

    //role end
    modifier onlyGovernor() {
        require(hasRole(governor, _msgSender()), "no auth");
        _;
    }

    function isOwner() public view returns (bool){
        return owner() == _msgSender();
    }

    function isGovernor(address account) public view returns (bool) {
        return hasRole(governor, account);
    }

    function addGovernor(address account) public onlyOwner {
        _grantRole(governor, account);
    }

    function removeGovernor(address account) public onlyOwner {
        _revokeRole(governor, account);
    }

    //role end
    modifier onlyWhitelisted() {
        require(hasRole(governor, _msgSender()) || isOwner(), "no auth");
        _;
    }

    function isWhitelisted(address account) public view returns (bool) {
        return hasRole(whitelistinvestor, account) || isOwner();
    }

    function addWhitelist(address account) public onlyGovernor {
        _grantRole(whitelistinvestor, account);
    }

    function removeWhitelist(address account) public onlyGovernor {
        _revokeRole(whitelistinvestor, account);
    }
    //role end
    modifier isHuman() {
        address q = _msgSender();
        uint codeLength;
        assembly {codeLength := extcodesize(q)}
        require(codeLength == 0, "humans only");
        require(tx.origin == _msgSender(), "humans only");
        _;
    }

    uint8 internal paused = 0;

    event contractPaused(bool value);

    function isPaused() public view returns (bool){
        return paused == 1;
    }

    modifier pauseCheck(){
        require(paused == 0, "p0");
        _;
    }

    function pauseSc() external onlyGovernor {
        paused = 1;
    }

    function unpauseSc() external onlyGovernor {
        paused = 0;
    }

}