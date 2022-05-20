

pragma solidity ^0.6.0;

import "./AccessControl.sol";
import "./Ownable.sol";

contract RoleIsland is AccessControl, Ownable {
    bytes32 public constant governor = keccak256("_governor");
    bytes32 public constant whitelistAdmins = keccak256("_whitelistAdmins");

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
    modifier onlyWhitelistAdmin() {
        require(hasRole(governor, _msgSender()) || isOwner(), "no auth");
        _;
    }

    function isWhitelistAdmin(address account) public view returns (bool) {
        return hasRole(whitelistAdmins, account) || isOwner();
    }

    function addWhitelistAdmin(address account) public onlyOwner {
        _grantRole(whitelistAdmins, account);
    }

    function removeWhitelistAdmin(address account) public onlyOwner {
        _revokeRole(whitelistAdmins, account);
    }
    //role end

    uint8 internal locked = 0;

    event traillock(uint8 value);

    function isLocked() public view returns (bool){
        return locked == 1;
    }

    function aliveTest() internal {
        locked = 0;
        emit traillock(locked);
    }

    function endTest() internal {
        locked = 1;
        emit traillock(locked);
    }

    function unlock() external onlyWhitelistAdmin {
        aliveTest();
    }

    function lock() external onlyWhitelistAdmin {
        endTest();
    }

    modifier onlyUnlocked(){
        require(locked == 0, "locked");
        _;
    }

    modifier isHuman() {
        address q = _msgSender();
        uint codeLength;
        assembly {codeLength := extcodesize(q)}
        require(codeLength == 0, "humans only");
        require(tx.origin == _msgSender(), "humans only");
        _;
    }

    function isContract(address x) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(x)
        }
        return size > 0;
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

    function pauseSc() external onlyWhitelistAdmin {
        paused = 1;
    }

    function unpauseSc() external onlyWhitelistAdmin {
        paused = 0;
    }

}