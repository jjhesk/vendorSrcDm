pragma solidity ^0.8.0;

contract ReentrancyGuard {
    bool internal locked;

    modifier nonReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}
